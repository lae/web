---
layout: post
title: A Simple Bash Alarm Clock
date: 2012-02-22 17:30
categories: code
---
Someone on IRC linked to a script called [DEADLINE][], which got me to thinking, 
a simple alarm clock script should be easy to concoct in bash if that's what 
the end goal is. I did a quick Google search but didn't find any *simple* 
solutions - they were all excessive in some way. So, here I ended up creating a 
bash one-liner in a few minutes to see it in practice and confirm I wasn't crazy:

    sleep $(( $(date --date="7 pm Feb 23, 2012" +%s) - $(date +%s))); echo "It's been a year since you touched this, and the sky is dark! Lalala."

I could easily expand this to request a simple date and play an audio file:

    #!/bin/bash
    printf "What time are you setting this alarm for? "
    read date
    echo Okay! Will ring you on $(date --date="$date").
    sleep $(( $(date --date="$date" +%s) - $(date +%s) ));
    echo Wake up!
    while true; do
      /usr/bin/mpg123 ~/alarm.mp3
      sleep 1
    done

This can accept date inputs like "january 1 next year", "tomorrow", "23:00 today" 
and so forth. In fact, one could expand this script to test for valid dates, or 
replace the prompt with argument parsing for the same behaviour as "Deadline." 
I would also probably suggest adding `nohup` to the script, to relay its execution
from the shell and into the background after the date has been inputted.

In fact, I may update this later when I have the time with a more robust (but still 
short and inexpensive) version.

There are a lot of things you can do with native UNIX utilities, and I'm not quite 
understanding why they aren't taken more advantage of.

[DEADLINE]: http://www.dettus.net/deadline/
