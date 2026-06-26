# client-movement-detector

Simple module for detecting jump requests and moving direction of the local player, with support for disabling jumping and moving.

## About

ClientMovementDetector helps detect three things:
- Is the local player trying to jump? (`Humanoid.Jump`)
- Which direction is the local player moving to? (`Humanoid.MoveDirection`)
- Which direction is inputted by the local player? (`Controls:GetMoveVector()`)

By accessing `Humanoid` properties and `PlayerModule`, this module works on all Roblox devices.

This module also allows developers to disable jumping and moving.

> [!IMPORTANT]
> Most detections only work when the local player's `Humanoid` exists. If it doesn't exist, then the detected values will remain in the previous state.<br>
> Input movement detection works without `Humanoid`, but it requires `PlayerModule` to be unmodified.

## Usage

Starting detection:

```luau
ClientMovementDetector.connect(false, true)
```

- The parameters for `.connect(...)` are `isJumpingEnabled` and `isMovingEnabled`.
    - In the example above, `isJumpingEnabled` is `false` and `isMovingEnabled` is `true`, which means that the player can move but cannot jump.
    - You can also modify these values later on by calling `.setJumpingEnabled(...)` and `.setMovingEnabled(...)`.
- Calling this also fires a `jumpStateChanged` event.
- By default, requiring the module for the first time calls `.connect(true, true)`.

Reading local player's jumping state and moving direction:

```luau
local isJumping = ClientMovementDetector.getIsJumping()
local moveDirection = ClientMovementDetector.getMoveDirection()
local inputMoveDirection = ClientMovementDetector.getMoveDirection_input()
```

- Move direction is in world space.
- Input move direction is in the format (right, 0, down).

Listening for jump button pressed and released:

```luau
ClientMovementDetector.jumpStateChanged:Connect(function(isJumping: boolean)
    -- Jump pressed / released logic here
end)
```

Stopping detection:

```luau
ClientMovementDetector.disconnect()
```

- Calling this also makes it so `.getIsJumping()` returns `false` and `.getMoveDirection()` returns `Vector3.zero`.
    - `.getMoveDirection_input()` will still return normal results.

## Credits

Similar modules:
- funwolf7's [JumpButton](https://github.com/funwolf7/jumpbutton).
