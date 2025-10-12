local ReplicatedStorage = game:GetService("ReplicatedStorage");
local shared = ReplicatedStorage.Shared
local GlassSignal = require(shared.TestImplementation);

GlassSignal.DoSomething:Connect(function(a)
    print(a);
    print(1);
end)

local dog = GlassSignal.DoSomething:Connect(function(a)
    print(a);
    print(2);
end)

dog:Disconnect();

GlassSignal.DoSomething:Connect(function(a)
    print(a);
    print(3);
end);

GlassSignal.DoSomethingElse:Connect(function(a)
    print(a);
    print(4);
end)