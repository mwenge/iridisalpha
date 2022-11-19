
# Fun with the Wave Data

<!-- vim-markdown-toc GFM -->

* [Change the sprites](#change-the-sprites)
* [Change the stickiness behaviour](#change-the-stickiness-behaviour)

<!-- vim-markdown-toc -->
Let's play with the wave data in the first level to see what each parameter does. THere's a whole
bunch of stuff in there, some of it not used in the game at all. We'll fiddle with the parameters,
show a vide of what it looks like, and link to a playable version of the retuned game so you can
try it yourself.

Here are all the parameters defined for the first attack wave:

https://github.com/mwenge/iridisalpha/blob/bc427c57225294689d55bc8b93328812769ea6d2/src/level_data.asm#L5302-L5373

## Change the sprites
First something simple, we'll change the sprite used in the first level to a little eyeball:
```diff
diff --git a/src/level_data.asm b/src/level_data.asm
index b847bf1..60fd8cf 100644
--- a/src/level_data.asm
+++ b/src/level_data.asm
@@ -5306,7 +5306,7 @@ planet1Level1Data
         ; Byte 2 (Index $01): Sprite value for the attack ship for the upper planet.
         ; Byte 3 (Index $02): The 'end' sprite value for the attack ship's animation
         ; for the upper planet.
-        .BYTE FLYING_SAUCER,FLYING_SAUCER+$03
+        .BYTE LITTLE_EYEBALL,LITTLE_EYEBALL+$01
         ; Byte 4 (Index $03): The animation frame rate for the attack ship.
         .BYTE $03
         ; Byte 5 (Index $04): Sprite value for the attack ship for the lower planet.
@@ -5378,7 +5378,7 @@ planet1Level1Data2ndStage
         ; Byte 2 (Index $01): Sprite value for the attack ship for the upper planet.
         ; Byte 3 (Index $02): The 'end' sprite value for the attack ship's animation
         ; for the upper planet.
-        .BYTE FLYING_SAUCER,FLYING_SAUCER+$03
+        .BYTE LITTLE_EYEBALL,LITTLE_EYEBALL+$01
         ; Byte 4 (Index $03): The animation frame rate for the attack ship.
         .BYTE $01
         ; Byte 5 (Index $04): Sprite value for the attack ship for the lower planet.

```
Now recompile and run:
```
make runcustom
```
This is the result:

![balls](https://user-images.githubusercontent.com/58846/202854123-c2120aa0-7ad3-4d59-a0c9-16a58f0a5197.gif)

Try it yourself at: https://lvllvl.com/c64/?gid=b42a03c7c496e613b0dd72e16299fcfc

## Change the stickiness behaviour

Next, let's try enabling the stickness and graviation behaviour on the first level:
```diff
diff --git a/src/level_data.asm b/src/level_data.asm
index b847bf1..a11527a 100644
--- a/src/level_data.asm
+++ b/src/level_data.asm
@@ -5343,10 +5343,10 @@ planet1Level1Data
         .BYTE $01
         ; Byte 23 (Index $16): Stickiness factor, does the enemy stick to the player
         ; sapping their energy if they're near them?
-        .BYTE $00
+        .BYTE $01
         ; Byte 24 (Index $17): Does the enemy gravitate quickly toward the player when its
         ; been shot? (Typical lickership behaviour) 
-        .BYTE $00
+        .BYTE $01
         ; Byte 25 (Index $18): Lo Ptr for another set of wave data. 
         ; Byte 26 (Index $19): Hi Ptr for another set of wave data.
         .BYTE <nullPtr,>nullPtr

```
This is the result:
![gravity](https://user-images.githubusercontent.com/58846/202854235-ecd4ec98-87bb-4e09-ac3c-ff216f64a63c.gif)


Try it yourself at: https://lvllvl.com/c64/?gid=e5126d21b556c22c34fe0ddb3d22ac71

