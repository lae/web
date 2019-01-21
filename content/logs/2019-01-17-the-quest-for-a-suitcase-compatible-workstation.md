+++
title = "The Quest for a Suitcase-Compatible Workstation"
description = "Some logs about my hardware choices and reasoning."
date = 2019-01-17T18:00:00Z
draft = true

[taxonomies]
categories = ["personal"]
+++

my requirements:
- fits in my carry-on luggage. approximately 250mm x 330mm x 500mm
- mobo should support 4 DIMM slots, a GPU, and at least 1 m.2 nvme
- GPU must not require a PCI-e riser cable (point of failure)
- mobo must have IPMI
- case preferably has room for 2 3.5" HDDs. 2.5" SSD is a bonus, but I have nvme already
- case should have appropriate dust filters and be capable of decent air cooling.
    - water cooling raises complications for getting through TSA.

case considerations:
there are no itx motherboards that tick all my boxes, specifically 4 DIMMs.
thus, the case needs to support micro-atx or larger.

Jonsbo C2 - poor cooling capability (esp if you opt to mount drive instead of
fan), not long enough for a GPU, only 1 drive bay with matx

Jonsbo/Cooltek C3. It's made of aluminum (= good heat dissipation), only 20 litre in volume, only 2kg (about 4 pounds) in weight. It's a very good mATX case that is lighter and smaller than many ITX cases. It can even fit into a backpack. Supports fully ATX power fupply and graphic card up to 27 centimeter in length.

Jonsbo V4 - unobtainium, seemed pretty cramped but usable. possibly runs hot

Thermaltake Urban SD1 - UNOBTAINIUM BUT OTHERWISE PERFECT (it ticks all of my
boxes). Server-like build in that you can pull out the motherboard tray.

Silverstone Fortress FT03 - the side panels have poor locking and easily come
off, otherwise really interesting design and would have gotten this. but the
diagonally oriented fan is apparently very noisy because the mount is only
fastened on one end. hot-swap drive is dumb, would probably have been better
with 2 extra 2.5" mounts. slim slot loading BD drive is expensive.

Thermaltake Core G3 - originally bought this for my "new" build after using my
last for 6 years. It's like 2cm too deep to fit in my suitcase, and it requires
using a PCI-e riser cable that I've grown to not like (given the
Thermaltake-provided one was DOA). Good case *overall* though, if you're
looking for ATX and slim.

Jonsbo UMX3 - might have been a good choice with decent cooling (unlike other
Jonsbo cases), but depth was 28mm too long, and only 1 3.5" bay (but up to 4
2.5" if you went ssd only)

Raijintek Styx - hotbox. also literally 5mm too long in height. full length GPU
doesn't fit when using an ATX PSU (need an SFX-ATX bracket) and thermals aren't
super great, but would probably be just fine with a power conscious workstation
(low power Xeon or Ryzen). super easy to build however - recommended to watch
https://www.youtube.com/watch?v=ITotk4Pqb-w for caveats.

Fractal Design Node 605 - discontinued, would probably be spectacular but is
19mm too deep.

Silverstone Grandia GD05 - pretty strong option since it ticks all my boxes.
CPU cooler options are limited to 70mm if using ODD (and you can use a full
5.25" ODD), 120mm if not, which is still not that great. dust filters are on
the inside rather than the outside, so fans will accumulate dust. Easy to
build.

Silverstone SG11/SG12 - Despite having a lot of openings, there are no dust
filters. Otherwise, while noticeably bigger than other options, is an appealing
chassis that would still fit in my suitcase. Probably the best option if you
have a lot of SSDs (9)/HDDs (3).

Thermaltake Core P3 - why is this micro-atx open air chassis so big?

Thermaltake Core P1 - this is a mini-ITX chassis, but I have seen at least 3
reports of people using this with a micro-ATX board. Only fits 1 3.5" drive
though. Would fit diagonally in suitcase as parts due to open air design (i.e.
you would have to disassemble when moving), but cooling is, as you'd expect,
pretty optimal. But it's super fucking heavy, I'm not sure you'd want to take
it in a carry-on.

Jonsbo RM3 - Possibly a good option? Case exterior is nice. 6mm too long
though. Airflow is limited to bottom intake.

Jonsbo U4 - 10mm too long, but a possibly good option that also fits full ATX.
Airflow seems pretty optimal compared to other Jonsbo.

Corsair Carbide 260 - 10mm too wide. Didn't look into it further since I'm not
a fan of the exterior.

Fractal Design Define Mini C - 59mm too long (or tall I guess, depending on
orientation). Didn't look into it further. It's unfortunate none of the Fractal
Design cases pass the geometry requirement, their cases have a really good rep
(and cable management is amazing in this case).

Silverstone Temjin TG08E - 44mm too tall. This case seems to have a pretty good
internal layout, airflow is great (it's the most touted at the SilentPC
community, I believe), and ticks every other box of mine. But I guess that's to
be expected with an extra available volume.

Silverstone Sugo SG09/SG10 - SG10 is the better looking version of the SG09.
Ticks all of my boxes. Need to be careful with PSU selection, Silverstone's
PSUs and EVGA's PSUs appear to be the only ones that are safe to use without
making it difficult to fit alongside the 140mm intake fan and without risking
the PSU extension cable from turning off the PSU because it's being routed over
the switch. Changing the top 180mm fan to exhaust should make this case very
optimal for cooling internal components **except** for the HDDs.

