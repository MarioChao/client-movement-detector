# Changelogs

## [v1.1.0] Input movement direction | 2026/06/26

Added new function for getting the input movement direction from the `PlayerModule`.
- Uses `:GetControls()` and `:GetMoveVector()`.
- Returns `Vector3.zero` if fails.

## [v1.0.0] Client movement detector | 2026/06/25

Created the `ClientMovementDetector` module that implements jumping and moving detection using `Humanoid`.
- Original scripts from [Trick Jump](https://www.roblox.com/games/92704291356507/Trick-Jump) and [a little cube's great journey](https://www.roblox.com/games/138429971129628/a-little-cubes-great-journey).

Tested & published the module to [wally](https://wally.run).
