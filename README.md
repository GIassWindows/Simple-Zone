# Yet Another Signal Implementation
Just another signal implementation with slightly more methods.
Also because I don't like using other people's code.

## Documentation

```lua
local signal = require("..PATH/..TO/..SIGNAL")

local newSignal = signal.new(); -- Instantiate a new signal.

-- Connect method which takes a function that contains the same number of parameters as the :Fire method.
newSignal:Connect(function(...)
    print(...);
end)

newSignal:Fire(...); -- Fire method which passes any number of parameters with any type.
```

You can disconnect connections using the traditional :Disconnect() method.
You can fire a connection once using the traditional :Once() method.