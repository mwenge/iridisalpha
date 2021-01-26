# Iridis Alpha by Jeff Minter
<img src="https://www.c64-wiki.com/images/a/a2/Iridisalphacover.jpg" height=300><img src="https://user-images.githubusercontent.com/58846/103442991-ae494a00-4c52-11eb-9432-0f6ed61d3a5a.gif" height=300>


This is the disassembled and [commented source code] for the 1986 Commodore 64 game Iridis Alpha by Jeff Minter. 

You can play Iridis Alpha in your browser at https://iridisalpha.xyz. (Ctrl key is 'Fire', Arrow Keys to move.)

## Current Status
The game compiles and plays. Character set and sprite data has been separated out and commented. Because there is so much character and sprite data, and because Iridis Alpha contains two sub games, it was necessary to use a compressor ([Exomizser]) to produce the final binary. 

Labelling the game logic is still in progress.

## Also Contains:
* [DNA], a demo by Jeff Minter containing some preparatory work for the main game.
* [Torus], another demo by Jeff Minter containing some preparatory work for the main game.
* [Torus2], another iteration on Torus.
* [Iridis Spaceship], a non-interactive demo of the spaceship sprites.
* [Made in France], Iridis Alpha's pause-mode mini game.

## Requirements
* [64tass][64tass], tested with v1.54, r1900
* [VICE][vice]
* [Exomizer][Exomizer]

[64tass]: http://tass64.sourceforge.net/
[vice]: http://vice-emu.sourceforge.net/
[https://gridrunner.xyz]: https://mwenge.github.io/gridrunner.xyz
[commented source code]:https://github.com/mwenge/gridrunner/blob/master/src/iridisalpha.asm
[DNA]:https://github.com/mwenge/iridisalpha/blob/master/demos/dna
[Torus]:https://github.com/mwenge/iridisalpha/blob/master/demos/torus
[Torus2]:https://github.com/mwenge/iridisalpha/blob/master/demos/torus2
[Iridis Spaceship]:https://github.com/mwenge/iridisalpha/blob/master/demos/iridis_spaceship
[Made in France]:https://github.com/mwenge/iridisalpha/blob/master/demos/mif
[Exomizer]:https://bitbucket.org/magli143/exomizer/wiki/Home

To compile and run it do:

```sh
$ make
```
The compiled game is written to the `bin` folder. 

To just compile the game and get a binary (`iridisalpha.prg`) do:

```sh
$ make iridisalpha.prg
```

# Original Game Manual

## SCREEN DISPLAY
After the initial screens your Gilby Robot Fighter warps into the first of five upper planets displayed in the top third of your screen. The middle third of the screen initially shows the design of the Warp Gate on the planet, the design of the Core Area and the design of the non-Core Area. This section of the screen is replaced by a display of a lower, mirror-image planet when you have destroyed three or more waves on the upper planet. The control panel occupies the lowest section of the screen (see illustration below).

![image](https://user-images.githubusercontent.com/58846/105919156-047c9380-602d-11eb-8b98-b734acf1b00d.png)


## ENERGY STATUS
Your energy grows when you destroy items and falls when you collide with items. If your energy climbs too high or falls too low your Gilby will explode. The length of the energy line on the control panel shows your current energy status and this is also indicated by the colour of your ship (white is dangerously high, black is dangerously low).

## CORE ENERGY
You can transfer energy to or recover energy from the Core Area by flying over the Core Area and stopping. Your Gilby will land. You can fire from the ground. To take off run to the edge of the Core Area and jump up. When the Core Area energy is full up you will transfer automatically to the bonus phase.

## TRANSFERRING TO THE LOWER PLANET
After you have destroyed three waves the lower planet will appear. To transfer to it you must find an alien which turns into a spinning ring for a few seconds when you destroy it. Stop firing and fly through the ring and you will transfer. to return to the upper planet find a similar spinning ring and fly through it.

## PLANET ENTROPY
Both upper and lower planets have an entropy which decays when they are not in use. The entropy status of each planet is shown at the far left of the control panel. If either entropy level falls too low your Gilby is destroyed.

## WARPING TO A NEW PLANET
When you have destroyed enough attacking waves you are able to warp to another planet. The Next Planet Pointers at the far right of the control panel indicate your current destination. To Warp to a new planet find the Warp Gate on either the upper or lower planet, stop firing and fly through the Gate.

## PROGRESS SCREEN
The Progress Screen appears every time you complete a group of attack waves. You may cancel it by pressing the fire button. The screen shows the twenty waves for each planet and illuminates each wave as it is completed. Your current wave is shown in red.

## SCORING
Points are earned for each enemy destroyed. The rate of scoring is shown as a points multiplier at the centre right of the control panel and varies from ×0 (times zero when stationary) to ×8 (times eight when at maximum speed).

## IRIDIS ALPHA
The Story Behind the Game
The story of Iridis Alpha begins with what was found on the planet of Zzyax-Prime after the activation of the legendary Iridis Base. Artefacts and documents relating to the long-departed race of Iridians were found at the base. Upon decoding, these documents revealed the location of the Iridian's homeworld, Iridis Alpha. Apparently, the Iridians evolved into transcendental forms devoid of the need for physical bodies, or, for that matter, planets to live on. So the Iridians prepared to leave their homeworld and depart for galaxies unknown in search of peace, enlightenment and a canned soft drink that tasted even better than Coke. (A futile quest, carried out with almost religious fervour by the Iridians; it has been widely accepted throughout the Galaxy that nothing could ever taste better than a good can of Coke. The Iridian quest transformed itself into an important ritual. They didn't really expect to succeed. Incidentally, the only known instance of a culture possessing a soft drink actually better than Coke is on Old Terra, where one of the less well developed countries spontaneously evolved a yellow drink known as Inca Kola. People were known to travel across half the globe in slow, uncomfortable air transporters at great expense, just to buy a few bottles and be at one with the indigenous ungulates. Inca Kola was not the solution to the Iridian's search, though: although it did indeed taste better than Coke, it wasn't available in cans).

The Iridians were nostalgic about their old homeworld, though, and fitted it out as a sort of museum and left it in stasis, so that they might, after millennia exploring everything, come back and assume physical forms once more and rest awhile on their ancient homeworld, sitting around in circles remembering old times and talking. Although a peaceful race, the Iridians didn't want any of these new, barbaric aliens currently struggling towards sentience in this neck of the Galaxy to go a-plundering on their lovely homeworld, so they defended it with lots of men and heavy weaponry.

Upon finding out these interesting facts about Iridis Alpha, the Humans at Iridis Base decided that they could use some of this amazingly advanced technology that these Iridians had developed: they reasoned that sure, being ultimately evolved and really peaceful was all well and good, but in their Universe there were Zzyaxians waiting to be biffed, and that Iridian technology would make a fine big stick to do the biffing with. They leaped into their sleek FTL cruisers and, thumbing their noses at Einstein, appeared in orbit around Alpha a mere two warp-seconds later. (Don't ask me about warp-seconds, coz I don't know that much about them. Apparently there is a multi-dimensional time construct that relates subjective and objective time. If you apply a localised 90-degree dimension shift, then one subjective and one objective second become equivalent. Well sort of. So although the ships 'really' took millennia to reach Alpha, the time perceived by the crew - and the rest of the Universe - is only a couple of weird seconds. Warp-seconds).

However, once within Alpha's orbit the troubles really began. You see, the Iridians had rigged a multiple phase reality field around the whole planet, allowing it to exist in two realities simultaneously, very confusing to the observer. Furthermore, there were five distinct reality modes possible, each in two orientations, and each defended by startling weaponry. The Humans were unfazed, though. What they did was take a single mind at birth, and using fast memory devices based upon molecular storage systems, they transferred the mind to a compact droid CPU. They devised ways of interpreting the strange sensory input that you tend to get if you try and exist in two realities at once. (The unaided Human brain becomes overloaded by the extra information that it receives. The overload results in distortion of perceived images, intensification of colour and visual effects, hallucinations, and a certain amount of euphoria. Human troopers in that state would be unable to fight the sophisticated Iridian defences).

The mind within the droid was subjected to dual-reality stimuli right from the moment of its incept, so naturally it evolved its own reality-model to cope with its situation. Thus, the Human forces had an intelligent being that could cope with Iridis Alpha without freaking out. And while the psychocyberneticists were working on the Al bit, the weapons technicians worked on the heavy-metal-thunder blam blam kerpow bit. They developed a neat rapid-firing laser/destabiliser, a reality-locus generator, and even a reality-shifter allowing the user to jump at will between any of Iridis' 5 reality modes.

All this weaponry and fancy stuff was bolted onto the brain-module containing the carefully-conditioned consciousness. The result was a small spherical droid with long, spindly legs and a little pointy hat. It called itself Gilby. Some of Mankind's greatest brains are still trying to figure out why.

The modest task of this insignificant-seeming droid was to go to Iridis Alpha, visit each of the five alternative realities thereon, and deactivate all the defences assigned to each reality. Gilby's laser/destabiliser could only work in one reality at a time, so by using the reality-locus shifter, Gilby could pop back and forth across both currently active realities blazing away merrily. However, Gilby could not remain in one reality for too long: all the while he's at the reality locus, the 'unused' Gilby, which mathematicians refer to as Gilby' (Gilby Prime) undergoes spontaneous and rapid molecular destabilisation. Frequent shifting of the reality locus was the solution to this particular problem. There was also the problem of energy; every time Gilby destablished an enemy he gained energy. OK, but if he got too much, BLAMMO! no more Gilby... so it was arranged that Gilby be able to transfer excess energy to the Iridian Core. Should Gilby fill the core he then had to run the gauntlet of a long and difficult obstacle course hotly pursued by a bunch of weirdo flying eyeballs known only to the Iridians in their infinite wisdom. Gilby hated this bit. It was like being a ball on a giant pinball table. Most undignified.

So now you know the story... can you take control of Gilby and deactivate all the attack levels? Can you understand what I've been waffling on about? Can you fry them creepies? Are you a megablasting psychedelic ultrahero fit to rid the Galaxy of Zzyaxian scum or are you just the sort of wimp who has to play Ancipital with the strobo FX turned off?

Wield your joystick, ram down that FIRE button, accelerate to Mach 8, and FIND OUT...

## Game Tactics
1. The first three levels are all single-planet. Practise flying Gilby about, landing on the Core, jumping around and taking off, and of course, shooting. It's important that you grasp the idea of Gilby LOSING energy each time he's hit and GAINING an equivalent amount of energy each time he kills an enemy. Be aware that you can have too much energy, as well as the more obvious situation of having too little. Keep an eye on Gilby's colour as you play. If the colour is dark - black, blue or red - then Gilby is low on energy. If the colour is bright, for example yellow or white, then Gilby is getting very full and you had better be looking to offload some.

2. You get rid of excess energy in either of two ways: by deliberate collisions with enemy ships, or better still by dropping it off in the Core. To land on the Core and transfer your energy, just fly to the Core, stop overhead, and release the FIRE button, whereupon Gilby will drop to the deck and the energy will be dumped. To leave the Core, you must walk Gilby off the Core surface and then leap into the air and fly. If you leap while you're on the Core, you just perform graceful lunar-type leaps. You may still fire at the enemy when you're on the Core, but you get different types of shots to those of an airborne Gilby.

3. Use the first three levels to get used to all this. Press Q to quit if the going gets tough or confusing, and just keep running those three simple levels until you've mastered the controls and are ready for the second planet.

4. After you finish Level Three the progress chart comes up with your completed waves on it, and highlighted icons representing your possible destinations amongst the planets of Iridis. This chart makes a regular appearance as you progress through the game; each time a new planet becomes available the chart pops up. You can also call it up anytime during play by pressing SPACE. Just press FIRE to leave the chart display and return to gameplay.

5. With the lower planet activated, your next priority is to learn how to transfer control from top to bottom and vice versa. Although both Gilbies are displayed, only one at a time is active. The non-active Gilby is rendered in neutral grey, so don't try to control a grey Gilby!

6. To make a transfer, you have to do three things: firstly, shoot any alien that produces a spinning ring when shot. You see these rings when you shoot most things; they look a little like flashy Polo mints. Shoot your alien to get the ring, then release the FIRE button, and fly through the ring. You'll then have transferred control to the opposing Gilby. (Learning to transfer is the most essential manoeuvre in Iridis gameplay. Take time to learn it well).

7. During 95% of the time you're playing Iridis, you should hold down the FIRE button. Fire is automatic and rapid. You only release the button if you've too much energy and don't want to shoot anything for fear of blowing up, or if you are wanting to transfer or land on the Core. You see, you have to make a conscious effort to let go of the button to make a transfer or landing. When you get used to the idea that you can NEVER transfer or land while you've got that button pressed, you'll find that you rarely, if ever, make unwanted transfers or landings.

8. The unused Gilby of the pair will decay if unused, and eventually blow up. By transferring regularly, you 'recharge' both Gilbies thus avoiding an untimely demise. Keep an eye on the Entropy Gauge in the lower left of the screen. Both Gilbies are represented there; the unused Gilby in the gauge gets darkest as it decays. If you look there and one of the Gilby-icons is blue or black, better transfer quickly. To remind you if you forget, the last four seconds before death due to not transferring are indicated by a violently-strobing screen. If you get these heavy strobes, transfer promptly and you'll be safe.

9. The Warp Gate, as well as being another means of avoiding Gilby decay, is your means of transport between the planets of Iridis Alpha. Over on the right hand edge of the control panel are five icons representing the planets. You'll notice little pointers over some of the icons. Each time you shoot something the pointer will switch between the icons representing the available warp destinations. In the early stages, that'll be only a couple of icons; as you open up more of the game, more destinations become available. To go to a destination, fly to near the Warp Gate, shoot until the pointer is aligned on the icon representing your chosen planet, then fly into the Warp Gate.

Iridis shows a way for the shoot-em-up to evolve, gaining depth and a degree of complexity, but still remaining playable and very 'blastable'. Whereas many blasting games become boring very quickly, lacking any objective beyond mere destruction of alien ships, Iridis gives the player plenty to think about. We're just trying to show that shoot-em-ups don't by any means have to be 'mindless'...

So give 'em hell - but think about it...

 

© Llamasoft Ltd 1986 and © Hewson Consultants Ltd 1986.
The game and name of Iridis Alpha and all associated software, code, listings, audio effects, graphics, illustrations and text are the exclusive copyright of Llamasoft Ltd and may not be copied, transmitted, transferred, reproduced, hired, lent, stored or modified in any form without express written permission. Llamasoft Ltd, 49 Mount Pleasant, Tadley, Hants.

Certain additional software is copyright of Hewson Consultants Ltd, 56B Milton Trading Estate, Milton, Abingdon, Oxon.
Marketed and distributed by Hewson Consultants Ltd.

