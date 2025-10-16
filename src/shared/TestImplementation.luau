local ReplicatedStorage = game:GetService("ReplicatedStorage");
local shared = ReplicatedStorage.Shared
local GlassSignal = require(shared.signal);

return {
	DoSomething = GlassSignal.new(),
    DoSomethingElse = GlassSignal.new()
}