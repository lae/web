+++
title = "A Practical Behind the Scenes, Running Mastodon at Scale (Translation)"
date = 2017-04-19T09:40:00Z

[taxonomies]
categories = ["infrastructure"]
tags = ["translation", "aws"]
+++

*The following is a translation of [this pixiv inside article][].*

![](http://inside.pixiv.blog/wp-content/uploads/2017/04/pawoo1854-680x357.png)

Good morning! I'm [harukasan](https://pawoo.net/@harukasan), the technical lead
for ImageFlux. 3 days ago at Pixiv, on April 14, we decided to do a spontaneous
launch of Pawoo—and since then I've found myself constantly logged into Pawoo's
server environment. Our infrastructure engineers have already configured our
monitoring environment to monitor Pawoo as well as prepared runbooks for alert
handling. As expected, we started receiving alerts for the two days following
launch and, despite it being the weekend, found ourselves working off hours on
keeping the service healthy. After all, no matter the environment, it's the job
of infrastructure engineers to react to and resolve problems!

## pawoo.net Architecture

Let's take a look at the architecture behind Pawoo. If you perform a `dig`,
you'll find that it's hosted on AWS. While we do operate a couple hundred
physical servers here at Pixiv, it's not really that possible to procure and
build up new ones so quickly. This is where cloud services shine. [nojio, an
infrastructure engineer who joined us this April](https://pawoo.net/@nojio),
and [konoiz](https://pawoo.net/@konoiz), a recent graduate with 2 years of
experience, prepared the following architecture diagram pretty quickly.

![Pawoo Architecture Diagram](http://inside.pixiv.blog/wp-content/uploads/2017/04/pawoo-structure.png)
Using as many of the services provided by AWS as we could, we were able to
bring up this environment in about 5 hours and were able to launch the service
later that day.

## Dropping Docker

One can pretty easily bring up Mastodon using Docker containers via
`docker-compose`, but we decided to not use Docker in order to separate
services and deploy to multiple instances. It's a lot of extra effort to deal
with volumes and cgroups, to name a few, when working with Docker containers -
it's not hard to find yourself in sticky situations, like "Oh no, I
accidentally deleted the volume container!" Mastodon does also provide a
[Production Guide][] for deploying without Docker.

So, after removing Docker from the picture, we decided to let `systemd` handle
services. For example, the systemd unit file for the web application looks like
the following:

```
Description=mastodon-web
After=network.target

[Service]
Type=simple
User=mastodon
WorkingDirectory=/home/mastodon/live
Environment="RAILS_ENV=production"
Environment="PORT=3000"
Environment="WEB_CONCURRENCY=8"
ExecStart=/usr/local/rbenv/shims/bundle exec puma -C config/puma.rb
ExecReload=/bin/kill -USR1 $MAINPID
TimeoutSec=15
Restart=always

[Install]
WantedBy=multi-user.target
```

For RDB, Redis and the load balancer, we decided to use their AWS managed
service counterparts. That way, we could quickly prepare a redundant multi-AZ
data store. Since ALB supports WebSocket, we could easily distribute streaming
as well. We're also utilizing S3 as our CDN/uploaded file store.

Utilizing AWS' managed services, we were able to launch Pawoo as fast as we
could, but this is where we began to run into problems.

## Tuning nginx

At launch, we had stuck with the default settings for nginx provided by the
distro, but it didn't take too long before we started seeing HTTP errors
returned so I decided to tweak the config a bit. That said, the important
settings to increase are `worker_rlimit_nofile` and `worker_connections`.

    user www-data;
    worker_processes 4;
    pid /run/nginx.pid;
    worker_rlimit_nofile 65535;

    events {
      worker_connections 8192;
    }

    http {
      include /etc/nginx/mime.types;
      default_type application/octet-stream;

      sendfile on;
      tcp_nopush on;
      keepalive_timeout 15;
      server_tokens off;

      log_format global 'time_iso8601:$time_iso8601\t'
                      'http_host:$host\t'
                      'server_name:$server_name\t'
                      'server_port:$server_port\t'
                      'status:$status\t'
                      'request_time:$request_time\t'
                      'remote_addr:$remote_addr\t'
                      'upstream_addr:$upstream_addr\t'
                      'upstream_response_time:$upstream_response_time\t'
                      'request_method:$request_method\t'
                      'request_uri:$request_uri\t'
                      'server_protocol:$server_protocol\t'
                      'body_bytes_sent:$body_bytes_sent\t'
                      'http_referer:$http_referer\t'
                      'http_user_agent:$http_user_agent\t';

      access_log /var/log/nginx/global-access.log global;
      error_log /var/log/nginx/error.log warn;

      include /etc/nginx/conf.d/*.conf;
      include /etc/nginx/sites-enabled/*;
    }

Afterward, without changing a lot of settings, nginx started to work pretty
well. This and other ways to optimize nginx are written in my book,
["nginx実践入門"][] (A practical introduction to nginx).

## Configure Connection Pooling

PostgreSQL, which Mastodon uses, by nature forks a new process for every
connection made to it. As a result, it's a very expensive operation to
reconnect. This is the biggest difference Postgres has from MySQL.

Rails, Sidekiq, and the nodejs Streaming API all provide the ability to use a
connection pool. These should be set to an appropriate value for the
environment, keeping in mind the number of instances. If you suddenly increase
the number of application instances to e.g. handle high load, the database
server will cripple (or should I say, became crippled). For Pawoo, we're using
AWS Cloud Watch to monitor the number of connections to RDS.

As the number of connections increased, our RDS instance would become more and
more backed up, but it was easy to bring it back to stability just by scaling
the instance size upwards. You can see that CPU usage has been swiftly quelled
after maintenance events in the graph below:


![RDS Graph](http://inside.pixiv.blog/wp-content/uploads/2017/04/RDS-graph.png)


## Increasing Process Count for Sidekiq

Mastodon uses Sidekiq to pass around messages, though it was originally
designed to be a job queue. Every time someone toots, quite a few tasks are
enqueued. The processing delay that comes from Sidekiq has been a big problem
since launch, so finding a way to deal with this is probably the most important
part of operating a large Mastodon instance.

Mastodon uses 4 queues by default (we're using a modified version with 5 queues
for Pawoo - see [issue](https://github.com/tootsuite/mastodon/pull/1929)):

- default: for processing toots for display when submitted/received, etc
- mail: for sending mail
- push: for sending updates to other Mastodon instances
- pull: for pulling updates from other Mastodon instances

For the push/pull queues, the service needs to contact the APIs of other
Mastodon instances, so when another Mastodon instance is slow or unresponsive,
this queue can become backlogged, which then causes the default queue to become
backlogged. To prevent this, run a separate Sidekiq instance for each queue.

Sidekiq provides a CLI flag that lets you specify what queue to process, so we
use this to run multiple instances of Sidekiq on a single server. For example,
one unit file looks like this:

```
[Unit]
Description=mastodon-sidekiq-default
After=network.target

[Service]
Type=simple
User=mastodon
WorkingDirectory=/home/mastodon/live
Environment="RAILS_ENV=production"
Environment="DB_POOL=40"
ExecStart=/usr/local/rbenv/shims/bundle exec sidekiq -c 40 -q default　# defaultキューだけにする
TimeoutSec=15
Restart=always

[Install]
WantedBy=multi-user.target
```

The most congested queue is the default queue. Whenever a user that has a lot
of followers toots, a ginormous number of tasks are dropped into the queue, so
if you can't process these tasks immediately, the queue becomes backlogged and
everyone notices a delay in their timeline. We're using 720 threads for
processing the default queue on Pawoo, but this is a big area for introducing
and discussing performance improvements in.

## Changing the Instance Type

We weren't quite sure of what kind of load to expect at launch, so we decided to use a standard instance type and change it around after figuring out how Mastodon uses its resources. We started out with instances from the t- family, then switched to using the c4- family after distinguishing that heavy load was occurring every time an instance's CPU credits ran out. We're probably going to move to using spot instances in the near future to cut down costs.

## Contributing to Mastodon

Now, we've been mainly trying to improve Mastodon performance by changing
aspects of the infrastructure behind it, but modifying the software is the more
effective way of achieving better performance. That said, several engineers
here at Pixiv have been working to improve Mastodon and have submitted PRs
upstream.

#### A list of submitted Pull Requests:  

- abcang: [fix regex filter #184][]
- alpaca-tc: [ActiveRecord::NotFound -> ActiveRecord::RecordNotFound #1864][]
- walf443: [reduce unneed query when post without attachements. #1907][]
- ikasoumen: [Enlarge font size to avoid autozooming of iPhone #1911][]
- alpaca-tc: [Fixed NoMethodError in UnfollowService #1918][]
- alpaca-tc: [Check @recipient.user at the first #1939][]
- geta6: [Improve streaming API server performance with cluster #1970][]

We actually even have a PR contributed by someone who's just joined the company
this month fresh out of college! It's difficult to showcase all of the
improvements that our engineers have made within this article, but we expect to
continue to submit further improvements upstream.

## Summary

We've only just begun but we expect Pawoo to keep growing as a service.
Upstream has been improving at great momentum, so we expect that there will be
changes to the application infrastructure in order to keep up.

*This work is licensed under a [Creative Commons Attribution-ShareAlike 4.0
International License][].*

*The translator of this article can be found on Mastodon at [lae@kirakiratter][].*

[this pixiv inside article]: http://inside.pixiv.blog/harukasan/1284
[Production Guide]: https://github.com/tootsuite/documentation/blob/master/Running-Mastodon/Production-guide.md
["nginx実践入門"]: https://www.amazon.co.jp/dp/4774178667/
[fix regex filter #184]: https://github.com/tootsuite/mastodon/pull/1845
[ActiveRecord::NotFound -> ActiveRecord::RecordNotFound #1864]: https://github.com/tootsuite/mastodon/pull/1864
[reduce unneed query when post without attachements. #1907]: https://github.com/tootsuite/mastodon/pull/1907
[Enlarge font size to avoid autozooming of iPhone #1911]: https://github.com/tootsuite/mastodon/pull/1911
[Fixed NoMethodError in UnfollowService #1918]: https://github.com/tootsuite/mastodon/pull/1918
[Check @recipient.user at the first #1939]: https://github.com/tootsuite/mastodon/pull/1939
[Improve streaming API server performance with cluster #1970]: https://github.com/tootsuite/mastodon/pull/1970
[Creative Commons Attribution-ShareAlike 4.0 International License]: http://creativecommons.org/licenses/by-sa/4.0/
[lae@kirakiratter]: https://kirakiratter.com/@lae
