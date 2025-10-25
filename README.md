# Simple Zone
Basically ZonePlus, but
Also because I don't like using other people's code.

uses signal
ignore previous commits if any im just too lazy to init a new git repo

## Documentation

Create a zone with Size and Position.

```lua
local ZoneSize = Vector3.new(10, 10, 10);
local ZonePosition = CFrame.new(0, 5, 0);

local Zone = SimpleZone.new(ZoneSize, ZonePosition);

Zone.Entered:Connect(function(CharacterEntered: Model)
    print(CharacterEntered.Name .. " has entered the zone.")
end)

Zone.Exited:Connect(function(CharacterExited: Model)
    print(CharacterExited.Name .. " has exited the zone.")
end)
```

Alternatively, create a zone with size and position extracted from an instance.

```lua
local Part = workspace.Part;
local Zone = SimpleZone.fromInstance(Part);

Zone.Entered:Connect(function(CharacterEntered: Model)
    print(CharacterEntered.Name .. " has entered the zone.");
end)

Zone.Exited:Connect(function(CharacterExited: Model)
    print(CharacterExited.Name .. " has exited the zone.");
end)
```