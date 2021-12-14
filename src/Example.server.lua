-- written by darmyn

math.randomseed(os.clock())

local ServerScriptService = game:GetService("ServerScriptService")

local ProtectedCallback = require(ServerScriptService.Server.ProtectedCallback)

local function range(lessThan, min, max)
    return math.random(min, max) < lessThan
end

local amountOfCallbackExecutions = 0

local callback = ProtectedCallback.new(function(player, id, spawnLocation)
    amountOfCallbackExecutions += 1
    local str = "My name is %s. My ID is %s and I"
    if spawnLocation then
        str = str.." spawn at ".. tostring(spawnLocation)
    else
        str = str.." do not have a spawn location."
    end
    print((str):format(player, tostring(id)))
end)

do                      -- union type -- -- union type --
    callback.argTypes = {"string|number", "Vector3|nil"}
    callback.rateLimit = .30 -- 1 request per .30 seconds

    local simulatedNetworkSpam = false
    local incorrectArgumentExecutions = 0
    local correctArgumentExectuions = 0
    local resultCode = nil

    if range(4, 1, 10) then
        simulatedNetworkSpam = true
        resultCode = 1
        for _ = 1, 1250 do
            -- depending on the rate limit, the callback
            -- will only execute a certain amount of
            -- times
            if range(2, 1, 10) then
                incorrectArgumentExecutions += 1
                callback:fire("Player1", "George", Color3.new(1, 1, 1))
            else
                correctArgumentExectuions += 1
                callback:fire("Player2", 242414, Vector3.new(1, 1, 1))
            end
            task.wait()
        end
    elseif range(3, 1, 10) then
        resultCode = 2
        incorrectArgumentExecutions += 1
        callback:fire("Player3", NumberSequence.new(0, 1), BrickColor.new(255, 255, 255))
    else
        resultCode = 3
        correctArgumentExectuions += 1
        callback:fire("Player4", "darmyn", Vector3.new(1, 1, 1))
    end

    print("ResultCode: ", resultCode)
    print("RateLimit: ", callback.rateLimit)
    print("SimulatedNetworkSpam: ", simulatedNetworkSpam)
    print("IncorrectArgumentsPassed: ", incorrectArgumentExecutions)
    print("CorrectArgumentsPassed: ", correctArgumentExectuions)
    print("TotalCallsAttempted: ", incorrectArgumentExecutions + correctArgumentExectuions)
    print("TotalCallbackExecutions: ", amountOfCallbackExecutions)
end