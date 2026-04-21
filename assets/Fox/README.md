# Fox Rive Starter Pack

This is a **starter** asset pack extracted from the supplied fox PNG.

Important:
- These assets are **not perfect production rig assets**.
- They are good for **blocking in animation** and building the first Rive file.
- Because the source was a single flattened image, some hidden overlap areas are missing.
- For final polish, redraw a few parts as vector or clean PNGs.

## Included assets
- full_character.png
- head.png
- left_ear.png
- right_ear.png
- left_eye.png
- right_eye.png
- nose.png
- mouth_smile.png
- collar_left.png
- collar_right.png
- tie.png
- body_base.png
- tail.png
- shadow.png

## What to redraw later
- eyelids (closed / half closed)
- pupil-only layers
- mouth neutral
- mouth open 1
- mouth open 2
- mouth sad
- left paw separate
- right paw separate

## Recommended Rive hierarchy
Fox_Root
  Shadow
  Tail
  Body
    Body_Base
    Collar_Left
    Collar_Right
    Tie
  Head_Group
    Head
    Left_Ear
    Right_Ear
    Left_Eye
    Right_Eye
    Nose
    Mouth

## Suggested animations
- idle
- blink
- look_left
- look_right
- happy_bounce
- sad
- talk
- wave_hi

## Suggested state machine inputs
- isIdle (bool)
- triggerBlink (trigger)
- lookX (number)
- isHappy (bool)
- isSad (bool)
- isTalking (bool)
- triggerWave (trigger)
