---
layout: page
title: Resume
updated: 2012-06-12
source: https://github.com/liliff/resume/blob/master/resume.md
---
# Musee Ullah

<milkteafuzz@gmail.com>  
<http://milkteafuzz.com>  
Austin, TX  
+14086869736  

## Overview

I am a 20 year old systems administrator and server firefighter aspiring to 
become both a developer and administrator. I learn very quickly in practice and am 
not afraid to take on new ventures. I enjoy what I do and hope to someday create 
and maintain world-changing applications.

## Work Experience

### [HostGator.Com, LLC][], Austin, TX

#### Systems Administrator - June 2011 to present

Resolved hundreds of issues per week through a support ticket system, including:  
- PHP/MySQL/Rails/website/application errors, issues  
- Backups and restorations  
- Reboot triage and server tuning (MySQL and Apache particularly)  
- Software upgrades and installations (Apache/PHP modules, Redmine, phpBB, etc.)  
Also filed internal bug reports and wrote documentation for our support 
knowledgebase and internal wikis.

**Highlight**: I was employee of the month for November 2011 (out of ~120 admins).

#### Systems Monitoring - December 2011 to present

I proactively monitor the shared server portion of our farm (>4500 servers), as
part of a team (of 1-2 others usually). My typical day consists of the following:  
- Severe load issues, immediate response and triage, gathering data and acting on it (ties into below)  
- User abuse issues, mostly site performance related, some spam and miscellaneous abuse  
- Server health, including disk space/performance issues, filesystem checks, general server happiness, etc.  
- Network/service uptime, resolving UDP/SYN floods, Slowloris/(D)DoS, broken configurations, etc.  
- Individual site performance reviews, and keeping sessions open on problem servers all night.  
I also write [public announcements][] on our [network status forums][] 
for extended downtime issues.

**Highlight**: I was an important asset in migrating our shared/reseller 
servers from 32- to 64-bit.

## Projects

### [ZMonitor][]

Console client for the Zabbix monitoring suite, developed in Ruby. It 
interfaces with the Zabbix API using JSON for gathering current active 
triggers and acknowledging events. It basically provides a CLI dashboard, 
a method to easily acknowledge several related alerts, and one to feed 
output to other applications.

## Skills

**OS/Distros:** CentOS, Arch Linux, Gentoo Linux, Fedora, Ubuntu\*, WinXP  
**Scripting:** Bash, Ruby  
**Markup:** Markdown, (X)HTML (incl. HTML5), CSS3, YAML, LaTeX  
**Programming:** PHP, Ruby  
**HTTP:** Lighttpd, Apache, nginx\*, Mongrel  
**Database:** MySQL, PostgreSQL\*  
**Mail:** Exim, Dovecot  
**Monitoring:** Zabbix, sysstat, IPMI  
**Network:** tcpdump/ngrep, iptables  
**Data/FS:** RAID (3ware, Adaptec, MegaRAID)\*, LVM2, FUSE, rsync, testdisk  
**Version Control:** Git\*, Subversion\*  
**Package Managers:** portage, pacman, yum/rpm  
**Virtualisation:** Virtuozzo\*, VirtualBox, TightVNC  
**Miscellaneous:** cPanel/WHM, LAMP, GCC/Compiling software, BIND, Jekyll  
*&#42; indicates partial understanding and ability to set-up/troubleshoot, and that it is a skill in progress*

## Education

**University of Illinois at Urbana-Champaign:** Completed a semester as an East Asian Languages major, 
with a 4.0 GPA in Japanese.

[HostGator.Com, LLC]: http://www.hostgator.com
[public announcements]: http://forums.hostgator.com/search.php?do=finduser&u=126179
[network status forums]: http://forums.hostgator.com/network-status-f14.html
[ZMonitor]: https://github.com/liliff/zmonitor
