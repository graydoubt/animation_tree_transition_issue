
## Data-driven AnimationTree State machine issue

This project sets up a minimal `AnimationTree` state machine that is entirely controlled by transitions' `advance_expression`.
The transitions' `advance_mode` is always set to "auto".

It's a firing mechanism for a gun, using `triggered` and `automatic` properties.

The state machine defaults to the "idle" state/animation, until the `triggered` property results in a transition to the "fire" state/animation.
If the trigger is released or `automatic` is `true`, the state will transition back to "idle".

As a result, holding down the "fire" button in the UI will repeatedly print "pew pew".

This works great but results in a `_transition_to_next_recursive` warning printed by Godot starting with 4.1.1-rc1.
A change in 4.2.2-rc3 results in a slightly altered but still incorrect behavior.


I've tested the following Godot version:

- 4.0 (works)
- 4.1 (Works)
- 4.1.1-rc1 (immediate warning)

The 4.1.1-rc1 changelog: https://godotengine.github.io/godot-interactive-changelog/#4.1.1-rc1

The "[Fix infinite loop state check in `AnimationStateMachine`](https://github.com/godotengine/godot/pull/79141)" results in:

```
W 0:00:02:0237   _transition_to_next_recursive: AnimationNodeStateMachinePlayback: parameters/playback aborts the transition by detecting one or more looped transitions in the same frame to prevent to infinity loop. You may need to check the transition settings.
  <C++ Source>   scene/animation/animation_node_state_machine.cpp:909 @ _transition_to_next_recursive()
```

In addition to the state machine switching between "idle" and "fire", I've also added a "trigger" animation, so see how the behavior is changed if it's not just toggling between two states.
Instead of an immediate warning, the warning only occurs if the button is held down (rather than briefly pressed).
This is present in a few versions:

- 4.1.1 (immediate warning)
- 4.2.1 (immediate warning)
- 4.2.2-rc1 (immediate warning)
- 4.2.2-rc2 (immediate warning)
- 4.2.2-rc3 (delayed warning)

The 4.2.2-rc3 changelog: https://godotengine.github.io/godot-interactive-changelog/#4.2.2-rc3

The "[Move the line of infinity loop checking in AnimationStateMachine](https://github.com/godotengine/godot/pull/89575)" update slightly changes the behavior.

If "idle" transitions to "trigger" before moving to "fire", the warning isn't printed.
If, however, the transition goes directly from "idle" to "fire", the warning is printed if the button is held down.

- Warning in 4.2.2 (delayed)
