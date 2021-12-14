# ProtectedCallback
Additional control over callbacks. Useful for networking.

```lua
local callback = ProtectedCallback.new(function(player, id, spawnLocation)
    local str = "My name is %s. My ID is %s and I"
    if spawnLocation then
        str = str.." spawn at ".. tostring(spawnLocation)
    else
        str = str.." do not have a spawn location."
    end
    print((str):format(player, tostring(id)))
end)

callback.argTypes = {"string|number", "Vector3|nil"}
callback.rateLimit = .30 -- Accept 1 call per .30 seconds
```

## Need a demonstration?

Download the baseplate file in the repository
and press play a few times. You have a chance
of getting a different result each time.

There are 3 different results.

Result 1: Network spamming

- In this example, the code will spam the callback
1250 times. It will randomly pass correct and incorrect
argument types. You will see lot's of calls getting dropped
plus the effects of having a rate limit.

Result 2: Incorrect argument passed

Result 3: Correct argument passed
    
Each result demonstrates the capabilities of this
tool.
