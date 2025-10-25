-- Setup --
local RunService = game:GetService("RunService");

-- Modules --
local Signal = require(script.signal);

-- Types --
type Signal = {
	Fire                    : <T...>(self: Signal, T...) -> (),
	Connect                 : <T...>(self: Signal, callback: (T...) -> ()) -> (),
	Once                    : <T...>(self: Signal, callback: (T...) -> ()) -> (),
	DisconnectAll           : (self: Signal) -> (),
	TempDisconnectAll       : (self: Signal) -> (),
	ReconnectAll            : (self: Signal) -> ()
}

export type SimpleZone = {
    ZoneSize                : Vector3,
    ZonePosition            : CFrame,
    OverlapParams           : OverlapParams,
    Entered                 : 
    {
        Connect             : (self: Signal, callback: (CharacterEntered: Model) -> ()) -> (),
	    Once                : (self: Signal, callback: (CharacterEntered: Model) -> ()) -> (),
    },
    Exited                  : 
    {
        Connect             : (self: Signal, callback: (CharacterExited: Model) -> ()) -> (),
	    Once                : (self: Signal, callback: (CharacterExited: Model) -> ()) -> (),

    },
    QueryMethod             : (self: SimpleZone) -> RBXScriptConnection,
    PlayersInZone           : {[ string ]: Model}
}

-- Private Functions --
local function CreateQueryWithBoundingBox(overlapParams: OverlapParams, cframe: CFrame, size: Vector3)
    local ModelsWithHumanoids = {};
    local AlreadyIdentified = {};
    local result = workspace:GetPartBoundsInBox(cframe, size, overlapParams);

    for _, v in result do
        if v:IsA("BasePart") then
            local IdentifiedPlayer: Model = v:FindFirstAncestorOfClass("Model");
            if not IdentifiedPlayer or AlreadyIdentified[IdentifiedPlayer] then continue end;
            if not ModelsWithHumanoids[IdentifiedPlayer] and IdentifiedPlayer:FindFirstChild("Humanoid") then
                AlreadyIdentified[IdentifiedPlayer] = true;
                ModelsWithHumanoids[IdentifiedPlayer.Name] = IdentifiedPlayer;
            end
        end
        continue;
    end

    return ModelsWithHumanoids;
end

-- Object --
local SimpleZone = {};
SimpleZone.__index = SimpleZone;

--- Create a zone with Vector3, CFrame, and a custom OverlapParams.
--- @param ZoneSize Vector3 - The size of the spatial query.
--- @param ZonePosition CFrame - The location of the spatial query.
--- @param CustomOverlapParams OverlapParams - An optional custom OverlapParams.
--- @return SimpleZone
function SimpleZone.new(ZoneSize: Vector3, ZonePosition: CFrame, CustomOverlapParams: OverlapParams): SimpleZone
    local self = setmetatable({
        ZoneSize = ZoneSize or Vector3.zero,
        ZonePosition = ZonePosition or CFrame.new(0, 0, 0),
        OverlapParams = CustomOverlapParams or OverlapParams.new(),
        Entered = Signal.new(),
        Exited = Signal.new(),
        PlayersInZone = {}
    }, SimpleZone);

    self.QueryMethod = self:Query();

    return self;
end

--- Create a zone from an instance.
--- @param fromInstance Instance - The instance to extract size and CFrame from.
--- @return SimpleZone
function SimpleZone.fromInstance(fromInstance: Instance, CustomOverlapParams: OverlapParams): SimpleZone
    local size: Vector3 = Vector3.zero;
    local cframe: CFrame = CFrame.new(0, 0, 0);
    local instance;

    if fromInstance:IsA("Model") then
        instance = fromInstance.PrimaryPart or fromInstance:FindFirstChildOfClass("BasePart");
    else
        instance = fromInstance;
    end

    size = instance.Size;
    cframe = instance.CFrame;

    return SimpleZone.new(size, cframe, CustomOverlapParams);
end

--- Creates Spatial Queries to check if a player is in the box.
--- @return RBXScriptConnection
function SimpleZone:Query(): RBXScriptConnection
    local Connection = RunService.Heartbeat:Connect(function()
        local QueryResult = CreateQueryWithBoundingBox(self.OverlapParams, self.ZonePosition, self.ZoneSize);

        for _, Character in QueryResult do
            if not self.PlayersInZone[Character.Name] then
                self.PlayersInZone[Character.Name] = Character;
                self.Entered:Fire(Character);
            end
        end

        for _, Character in self.PlayersInZone do
            if not QueryResult[Character.Name] then
                self.PlayersInZone[Character.Name] = nil;
                self.Exited:Fire(Character);
            end
        end
    end)

    return Connection;
end

--- Stops the zone from listening.
function SimpleZone:Disconnect()
    self.QueryMethod:Disconnect();
    self.Entered:Disconnect();
    self.Exited:Disconnect();
end

return SimpleZone;