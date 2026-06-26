--!strict

-- Client Movement Detector


---------- Validate environment ----------

local RunService = game:GetService("RunService")

if not RunService:IsClient() then
    warn(`[Client Movement Detector]: Module should only be called from the Client!`)
end


---------- Services ----------

local Players = game:GetService("Players")


---------- Constants ----------

local Constants = {}

Constants.localPlayer = Players.LocalPlayer
Constants.playerScripts = Constants.localPlayer:WaitForChild("PlayerScripts")

Constants.jumpStateChangedBindableEvent = Instance.new("BindableEvent")

do
    local _PlayerModule = Constants.playerScripts:WaitForChild("PlayerModule", 10)
    pcall(function()
        Constants.playerModule = require(_PlayerModule) :: any
        Constants.playerModuleControls = Constants.playerModule:GetControls() :: any
    end)
    if not Constants.playerModuleControls then
        warn(`[Client Movement Detector]: No player module found.`)
    end
end

table.freeze(Constants)


---------- Globals ----------

local Globals = {}

Globals.isJumpingEnabled = false
Globals.isJumping = false
Globals.isFirstIteration = false

Globals.isMovingEnabled = false
Globals.moveDirection = Vector3.zero


---------- Local functions ----------

local setIsJumping
local getIsJumping
local jumpDetectIteration

local setMoveDirection
local getMoveDirection
local getMoveDirection_input
local moveDetectIteration

local connect
local disconnect


----- Jump -----

setIsJumping = function(state: boolean)
    local oldState = Globals.isJumping
    Globals.isJumping = state

    -- Check state change
    if Globals.isFirstIteration or oldState ~= state then
        Constants.jumpStateChangedBindableEvent:Fire(state)
    end
end

--[[
Gets whether the local player is holding the jump button.
@return (boolean) Whether the jump button is held.
]]
getIsJumping = function()
    return Globals.isJumping
end

jumpDetectIteration = function(humanoid: Humanoid)
    setIsJumping(humanoid.Jump)

    -- Disable jump
    if not Globals.isJumpingEnabled then
        humanoid.Jump = false
    end
end


----- Move -----

setMoveDirection = function(direction: Vector3)
    Globals.moveDirection = direction
end

--[[
Gets the direction the local player is moving to.
@return (Vector3) The movement direction in world space; either a unit vector or a zero length vector.
]]
getMoveDirection = function()
    return Globals.moveDirection
end

--[[
Gets the input movement direction of the local player.
@return (Vector3) The input movement direction in the format (right, 0, down); can be vector of any length.
]]
getMoveDirection_input = function()
    local success, result = pcall(function()
        return Constants.playerModuleControls:GetMoveVector()
    end)
    if not success then
        warn(`[Client Movement Detector]: getMoveDirection_input() is unable to run due to a different PlayerModule.`)
        return Vector3.zero
    end
    return result
end

moveDetectIteration = function(humanoid: Humanoid)
    setMoveDirection(humanoid.MoveDirection)

    -- Disable movement
    if not Globals.isMovingEnabled then
        Constants.localPlayer:Move(Vector3.zero)
    end
end


----- Connections -----

--[[
Starts the detection for jump requests and moving direction.
@param isJumpingEnabled Whether the player character actually jumps or not.
@param isMovingEnabled Whether the player character actually moves or not.
]]
connect = function(isJumpingEnabled: boolean, isMovingEnabled: boolean)
    disconnect()

    -- Initialize values
    Globals.isJumpingEnabled = (isJumpingEnabled == true)
    Globals.isMovingEnabled = (isMovingEnabled == true)
    Globals.isFirstIteration = true

    -- Bind detector
    RunService:BindToRenderStep("DetectLocalPlayerMovement", Enum.RenderPriority.Input.Value + 1, function()
        -- Get player humanoid
        local character = Constants.localPlayer.Character
        local humanoid = character and character:FindFirstChildWhichIsA("Humanoid")
        if not humanoid then
            return
        end

        -- Detect
        jumpDetectIteration(humanoid)
        moveDetectIteration(humanoid)

        -- Flags
        if Globals.isFirstIteration then
            Globals.isFirstIteration = false
        end
    end)
end

--[[
Stops the detection for jump requests and moving direction.
]]
disconnect = function(): ()
    -- Unbind detector
    RunService:UnbindFromRenderStep("DetectLocalPlayerMovement")

    -- Reset values
    Globals.isJumping = false
    Globals.moveDirection = Vector3.zero
end


---------- Module ----------

local Module = {}


----- Module fields -----

Module.getIsJumping = getIsJumping
Module.getMoveDirection = getMoveDirection
Module.getMoveDirection_input = getMoveDirection_input

Module.connect = connect
Module.disconnect = disconnect

--[[
Fires when the player presses or releases the jump button.
@param isJumping The current jumping state.
]]
Module.jumpStateChanged = Constants.jumpStateChangedBindableEvent.Event

--[[
Sets whether the player character actually jumps or not.
@param isJumpingEnabled Whether the player character actually jumps or not.
]]
function Module.setJumpingEnabled(isJumpingEnabled: boolean)
    Globals.isJumpingEnabled = isJumpingEnabled
end

--[[
Sets whether the player character actually moves or not.
@param isMovingEnabled Whether the player character actually moves or not.
]]
function Module.setMovingEnabled(isMovingEnabled: boolean)
    Globals.isMovingEnabled = isMovingEnabled
end


---------- Return module ----------

table.freeze(Module)
return Module
