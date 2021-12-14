-- written by darmyn

local ProtectedCallback = {}
ProtectedCallback.__index = ProtectedCallback

function ProtectedCallback.new(callback)
    local self = setmetatable({}, ProtectedCallback)
    
    self.callback = callback
    self.lastCall = {}
    self.rateLimit = 1

    return self
end

function ProtectedCallback:fire(entity, ...)
    local rateLimit = self.rateLimit
    if rateLimit and entity then
        local lastCall = self.lastCall[entity]
        if lastCall then
			if os.clock() - lastCall < rateLimit then
                return
            end
        end
    end
    local argTypes = self.argTypes
    if argTypes then
        local args = table.pack(...)
        args["n"] = nil
        for argumentPosition, argumentValue in ipairs(args) do
            local expectedType = argTypes[argumentPosition]
            if expectedType then
                if argumentValue then
                    if expectedType == typeof(argumentValue) then
                        continue
                    else
                        if (expectedType):find("|") then
                            local seperatedTypes = (expectedType):split("|")
                            local correctType = false
                            for _, seperatedType in ipairs(seperatedTypes) do
                                if argumentValue then
                                    if seperatedType == typeof(argumentValue) then
                                        correctType = true
                                        break
                                    else
                                        continue
                                    end
                                elseif seperatedType == "nil" then
                                    correctType = true
                                    break
                                else 
                                    continue
                                end
							end
                            if not correctType then
                                return
                            end
                        end
                    end
                elseif expectedType == "nil" then
                    continue
                end
            end
        end
    end
    self.lastCall[entity] = os.clock()
    return self.callback(entity, ...)
end

function ProtectedCallback:releaseEntity(entity)
    if self.lastCall[entity] then
        self.lastCall[entity] = nil
    end
end

return ProtectedCallback