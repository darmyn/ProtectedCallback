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

Download the test file in the repository
and drag it into ServerScriptService inside of any studio session.

Press play a couple times to get all the different results.

### There are 3 different results:

Result 1: Network spamming

- The code will spam the callback
1250 times. It will randomly pass correct and incorrect
argument types. You will see lot's of calls getting dropped
plus the effects of having a rate limit.

Result 2: Incorrect argument passed

- Incorrect argument types will be passed to the callback
    and so it will be rejected.

Result 3: Correct argument passed

- Correct argument types will be passed to the callback
    and so it will be called.
