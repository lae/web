---
layout: post
title: Using SCP to Provide a Public Upload Service
date: 2013-02-16 07:54
categories: code
---
Half a year ago, I wrote a poorly detailed post about setting up 
[a public upload site using SSH][], which used the `authorized_keys` file 
to restrict the key to an rsync command with certain flags enabled and a 
specified destination directory. This was pretty poorly implemented so I 
ended up removing the upload script and private key to prevent abuse.

Some time ago I did look into finding solutions to prevent all the mishaps 
that could have happened with that method. I ended up writing a pass-through 
bash script that basically parses the command sent to the SSH server, 
checks that the input is sane and then executes it.

### The Implementation

To start things off, here's the result:

    #!/bin/bash -fue
    set -- $SSH_ORIGINAL_COMMAND # passes the SSH command to ARGV
    up='/home/johndoe/example.jp'
    function error() {
        if [ -z "$*" ]; then details="request not permitted"; else details="$*"; fi
        echo -e "\aERROR: $details"
        exit
    }
    if [ "$1"  != 'scp' ]; then error; fi # checks to see if remote is using scp
    if [ "$2" != "-t" ]; then error; fi # checks flags for local scp to retrieve a file
    shift
    shift
    if [[ "$@" == '.' ]]; then error "destination not specified"; fi # checks that the command isn't scp -t .
    if [[ "$@" == ../* ]] || [[ "$@" == ./* ]] || [[ "$@" == /* ]] || [[ "$@" == */* ]] || [[ "$@" == .. ]]; then
        error "destination traverses directories"
    fi
    dest=$up$@
    if [[ -f "$dest" ]]; then error "file exists on server"; fi
    exec scp -t "$dest"

We'll make this executable and place it at `/home/johndoe/bin/restrict.sh`. 
The following line should then be appended to `/home/johndoe/.ssh/authorized_keys`:

    no-port-forwarding,no-X11-forwarding,no-pty,command="/home/johndoe/bin/restrict.sh" $PUBLICKEY

Of course, replace `$PUBLICKEY` with a valid public key (you should create 
a key pair that doesn't require a password to use, but that's up to you). 
Then, we basically use SCP to upload a file. For the `restrict.sh` script 
I provided above, you'll need to actually specify the destination file 
(because scp runs with '.' as the destination, and that could very well 
be the entire directory locally):

    scp (-i $pathtoprivatekey) $srcfile johndoe@example.jp:$destfile

You can also write a script (like I have) or use an alias to make this simpler 
to perform on an everyday basis.

### The Explanation

The comments in the script should explain what happens for the most part, 
but I'll reiterate here. I begin by defining the variables to be used throughout 
the script. `$SSH_ORIGINAL_COMMAND` is a variable provided by OpenSSH 
to the program specified by the `command` parameter in your `authorize_keys`
file, which contains the command issued remotely. I use `set` here primarily 
to reduce the amount of code I have to write (it basically does the splitting 
of the variable for me). `up` is then defined to specify where files 
will be uploaded to (and in this case I use a directory accessible via HTTP).

The `error()` function is defined to return a message to the person sending 
a request to the server and then exit. I included an escaped alarm beep 
only because it seems that the 'E' disappears if I don't put anything other 
than an 'e' in front. (I tried removing it now and, for some reason, it 
works fine, so it might have just been a bug with an older SSH client from 
last year.)

The next two lines then check to see if the command being executed is `scp` 
with the `t` flag specified - this is the server counterpart to the `scp` 
command. After that's done, I use `shift` to remove the first two arguments.

`$@` should then include the remaining arguments, which in most cases 
will be the destination file. Flags like the recursive flag `r` seem to
get specified before `t` so this will prevent entire directories from 
being uploaded (it also prevents usage of the verbose flag, but you could 
add more logic to check). `$@` is then matched against any patterns that 
would allow the destination to be any other directory than the one specified 
by the `up` variable defined earlier (it also matches root, but then again, 
you wouldn't use this script with root, would you?).

We then check to see if the destination file exists, and proceed to upload 
it if it does not.

### Things to be Concerned About

There are a few serious issues with this approach, however. You'd want to 
implement a check for how much disk space is available on the server, and 
possibly prevent uploads if the disk is 90% full or so. The issue with this 
is that SCP doesn't pass any other metadata about the file being uploaded, 
so you can't check to see if uploading the file would cause the disk to 
become 100% full and cause server wide problems (of which you may not even 
be aware that this script could be the source of the issue).

You would also want to implement a flood check within the script. This could 
be pretty simple: you could have a [data store][] that keeps track of files, 
dates of when the files were uploaded, and the size of files (after they 
were uploaded, of course), and then you could check to see how many files 
were uploaded in the last 30 minutes or count how much data was transferred 
in that time, and prevent any uploads for a limited amount of time. This 
could be an effective deterrent, but it won't stop floods with an extended 
duration (in other words, it's not difficult to write a `while true` loop 
that runs scp every minute on a randomly generated file). Since SCP doesn't 
even pass the IP of the uploader, you can't deny requests to certain IPs 
(well, I suppose you could parse `netstat`, but that doesn't seem like 
a reliable, effective method).*  
<br />

In short, I would only use this to provide a service to friends and others 
I can trust not to abuse it. If either of those two problems have a solution 
I'm not aware about, I'm open to suggestions (and new knowledge, of course).

\* (update 5 Mar) I just realised a week ago that SSH actually does pass the 
[SSH\_CONNECTION and SSH\_CLIENT][] environment variables containing the 
sender's IP, so one should be able to track uploads via IP within the script 
easily. I'll see what I can do about the other issue.


[a public upload site using SSH]: {% post_url 2012-06-25-kyoto.maidlab.jp %}
[data store]: http://redis.io
[SSH\_CONNECTION and SSH\_CLIENT]: http://en.wikibooks.org/wiki/OpenSSH/Client_Applications#ssh_client_environment_variables
