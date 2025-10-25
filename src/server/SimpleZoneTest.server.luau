local ReplicatedStorage = game:GetService("ReplicatedStorage");
local shared = ReplicatedStorage.Shared;
local SimpleZone = require(shared.SimpleZone);
local PartFolder = workspace.Zones:GetChildren();

--[[
local ZonePosition = CFrame.new(-49.64, 0.5, 23.1);
local ZoneSize = Vector3.new(10, 10, 10);

local Zone = SimpleZone.new(ZoneSize, ZonePosition);
type Zone = SimpleZone.SimpleZone;

Zone.Entered:Connect(function(CharacterEntered: Model)
    print(CharacterEntered.Name .. " has entered the zone.")
end)

Zone.Exited:Connect(function(CharacterExited: Model)
    print(CharacterExited.Name .. " has exited the zone.")
end)
]]

for ZoneNumber, Part in PartFolder do
    local Zone = SimpleZone.fromInstance(Part);

    Zone.Entered:Connect(function(CharacterEntered: Model)
        print(CharacterEntered.Name .. " has entered zone " .. ZoneNumber .. ".");
    end)

    Zone.Exited:Connect(function(CharacterExited: Model)
        print(CharacterExited.Name .. " has exited zone " .. ZoneNumber .. ".");
    end)
end