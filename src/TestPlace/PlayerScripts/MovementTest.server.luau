--!strict

-- Movement Test


---------- Services ----------

local ReplicatedStorage = game:GetService("ReplicatedStorage")


---------- Imports ----------

local _Modules = ReplicatedStorage:WaitForChild("Modules")
local ClientMovementDetector = require(_Modules:WaitForChild("ClientMovementDetector"))


---------- Local functions ----------

local onJumpPressed
local onJumpReleased

local logDetection


----- Jump -----

onJumpPressed = function()
    print("[Movement Test]: Jump start.")
end

onJumpReleased = function()
    print("[Movement Test]: Jump release.")
end


----- Detection -----

logDetection = function(prefix: string)
    local isJumping = ClientMovementDetector.getIsJumping()
    local moveDirection = ClientMovementDetector.getMoveDirection()
    local inputMoveDirection = ClientMovementDetector.getMoveDirection_input()
    print(prefix, "Is jumping:", isJumping)
    print(prefix, "Moving dir:", tostring(moveDirection))
    print(prefix, "Input moving dir:", tostring(inputMoveDirection))
end


----- Main -----

local function main()
    -- Pause
    print("[Movement Test]: Pause.")
    task.wait(1)

    -- Player jump connections
    ClientMovementDetector.jumpStateChanged:Connect(function(isJumping: boolean)
        if isJumping then
            onJumpPressed()
        else
            onJumpReleased()
        end
    end)

    -- Connect detector & read values
    ClientMovementDetector.connect(false, true)
    for i = 1, 10 do
        logDetection(`#{i}`)
        task.wait(0.2)
    end

    -- Stop detection & read values
    print("[Movement Test]: Stop detection.")
    ClientMovementDetector.disconnect()
    for i = 1, 10 do
        logDetection(`#{i}`)
        task.wait(0.2)
    end

    -- Resume detection & read values
    print("[Movement Test]: Resume detection.")
    ClientMovementDetector.connect(false, true)
    for i = 1, 10 do
        logDetection(`#{i}`)
        task.wait(0.2)
    end

    -- Repeated disconnection should function like just one disconnection
    for i = 1, 10 do
        print("Disconnect")
        ClientMovementDetector.disconnect()
        task.wait(0.2)
    end

    -- Repeated connection disconnects the previous one
    ClientMovementDetector.connect(false, false)
    task.wait(1)
    ClientMovementDetector.connect(true, false)
    task.wait(1)
    ClientMovementDetector.connect(false, true)
    task.wait(1)
    ClientMovementDetector.connect(true, true)
end


---------- Calling function ----------

main()
