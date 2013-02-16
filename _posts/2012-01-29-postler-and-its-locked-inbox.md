---
layout: post
title: Postler and it's "INBOX is locked" message
date: 2012-01-29 01:53
categories: desktop
---
I'm sure some of you have had Postler stop being able to receive messages from 
your email account one day or another, but have had no idea why.

Running postler in a command line, I would see the following when attempting to 
"receive mail":

	** (postler-service:2376): DEBUG: postler-service.vala:67: Line/ input: Connection is now encrypted
	** (postler-service:2376): DEBUG: postler-service.vala:67: Line/ input: Logging in...
	** (postler-service:2376): DEBUG: postler-service.vala:67: Line/ input: Opening slave local...
	** (postler-service:2376): DEBUG: postler-service.vala:67: Line/ error: Error: channel :remote:INBOX-:local:INBOX is locked
	** (postler-service:2376): DEBUG: postler-service.vala:303: Done: 0 new messages

I couldn't figure it out at first, and the first time it happened I thought it 
was a transitory issue since it seemed to have been fixed when I reinstalled 
Postler and move the old configuration directory out of the way. Then, it 
happened again and I had stopped using Postler to check mail.

Just yesterday, however, when I had a process to kill, I saw a postler-mbsync 
process while I wasn't running Postler. I killed it (`killall postler-mbsync`) 
and then started up Postler today, and lo and behold, the inbox is no longer 
locked and I am able to receive mail~
