---
layout: post
title: Increasing Maximum Volume with ALSA
date: 2013-03-16 11:21
categories: desktop
---
Since I don't have a set of monitors for my desktop, I use a pair of headphones 
often as speakers for audio. This setup usually is insufferable because of low 
audio, though mplayer has a "softvol" plugin that lets you increase your sound 
output's decibel level - and since I hardly needed sound for anything other than 
music or video, this solution worked perfectly (of course, for anything else I 
could put on my headphones).

That solution sufficed for me until recently, and I found out ALSA actually has 
a [softvol plugin][] that lets you set `max_dB` (usually 0 by default). This can 
be done in `/etc/asound.conf` or `~/.asoundrc` with the following definitions:

    pcm.softvol {
            type softvol
            slave.pcm "cards.pcm.default"
            control {
                    name "Software"
                    card 0
            }
            max_dB 20.0
    }
    pcm.!default {
            type            plug
            slave.pcm       "softvol"
    }

Depending on your configuration, the line `slave.pcm "cards.pcm.default"` and 
`card 0` may need modification - you can run `aplay -Ll` to list your devices 
and card indices. Changes will take effect upon restarting applications that 
use sound.

This will create a "Software" control in applications like `alsamixer`, which 
will let you increase the decibel level up to 20dB (though there isn't any 
indication of what the decibel level is at other than percentages). Since I 
didn't specify `min_dB`, it defaults to -51dB.

You can also control the left and right channels independently, which is 
useful when you need volume to be louder in one speaker or headphone in a 
stereo setup.

[softvol plugin]: http://www.alsa-project.org/alsa-doc/alsa-lib/pcm_plugins.html
