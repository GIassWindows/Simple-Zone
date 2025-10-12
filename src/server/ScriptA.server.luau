local ReplicatedStorage = game:GetService("ReplicatedStorage");
local shared = ReplicatedStorage.Shared
local GlassSignal = require(shared.TestImplementation);

task.wait(1)

GlassSignal.DoSomething:Fire("hello");

task.wait(1)

GlassSignal.DoSomethingElse:Fire("hello again");