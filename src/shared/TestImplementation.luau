local ReplicatedStorage = game:GetService("ReplicatedStorage");
local shared = ReplicatedStorage.Shared
local GlassSignal = require(shared.GlassSignal);

return {
	DoSomething = GlassSignal.new(),
    DoSomethingElse = GlassSignal.new()
}