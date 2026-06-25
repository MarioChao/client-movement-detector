# client-movement-detector

Simple module for detecting jump requests and moving direction of the local player, with support for disabling jumping and moving.

## About

ClientMovementDetector helps detect two things:
- Is the local player trying to jump? (`Humanoid.Jump`)
- Which direction is the local player moving to? (`Humanoid.MoveDirection`)

By accessing `Humanoid` properties, this module works on all Roblox devices.

This module also allows developers to disable jumping and moving.

> [!IMPORTANT]
> The detector only works when the local player's `Humanoid` exists. If it doesn't exist, then the detected values will remain in the previous state.

## Usage

Starting detection:

```luau
ClientMovementDetector.connect(false, true)
```

- The parameters for `.connect(...)` are `isJumpingEnabled` and `isMovingEnabled`.
    - In the example above, `isJumpingEnabled` is `false` and `isMovingEnabled` is `true`, which means that the player can move but cannot jump.
    - You can also modify these values later on by calling `.setJumpingEnabled(...)` and `.setMovingEnabled(...)`.
- Calling this also fires a `jumpStateChanged` event.

Reading local player's jumping state and moving direction:

```luau
local isJumping = ClientMovementDetector.getIsJumping()
local moveDirection = ClientMovementDetector.getMoveDirection()
```

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

## Credits

Similar modules:
- funwolf7's [JumpButton](https://github.com/funwolf7/jumpbutton).
