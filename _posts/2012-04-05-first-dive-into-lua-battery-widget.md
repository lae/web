---
layout: post
title: First Dive Into Lua - A Battery Widget
date: 2012-04-05 09:16
categories: code desktop
---
So, it's come to the point where my laptop has unexpectedly turned off from 
a dead battery one too many times, so I decided to write a [battery widget 
using Vicious][] for the [window manager][] I'm using, [Awesome][]. The 
configuration files are all written in Lua, and honestly I've never touched 
Lua or felt like programming in it since it looks so...confuzzling.

Nevertheless, I took a look at the [Vicious][] and [Naughty][] libraries, and 
some Lua documentation to get this up and running:

	batmon = awful.widget.progressbar()
	batmon:set_width(8)
	batmon:set_vertical(true)
	batmon:set_border_color("#3f3f3f")
	batmon:set_color("#5f5f5f")
	batmon_t = awful.tooltip({ objects = { batmon.widget },})
	vicious.register(batmon, vicious.widgets.bat, function (widget, args)
		batmon_t:set_text(" State: " .. args[1] .. " | Charge: " .. args[2] .. "% | Remaining: " .. args[3])
		if args[2] <= 5 then
			naughty.notify({ text="Battery is low! " .. args[2] .. " percent remaining." })
		end
		return args[2]
	end , 60, "BAT0")

What this basically does is create a progressbar widget with the Awful library, 
configure its [settings][], create a tooltip with detailed information, and 
registers the widget I created with Vicious. The Vicious portion of it uses 
the battery widget type and sets a timer to update it every 60 seconds, which 
updates the progressbar percentage and the tooltip. It also checks for a low 
battery, which for me pops up a little box at the upper right of my screen.

I'm probably not going to be touching Lua for a while again.

[battery widget using Vicious]: http://pastebin.com/uQyqxemq
[Vicious]: https://awesome.naquadah.org/wiki/Vicious
[window manager]: https://en.wikipedia.org/wiki/Window_manager
[Awesome]: https://awesome.naquadah.org/
[Naughty]: https://awesome.naquadah.org/wiki/Naughty
[settings]: https://awesome.naquadah.org/wiki/Widgets_in_awesome#Progressbar
