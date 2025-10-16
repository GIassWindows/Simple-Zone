local ReplicatedStorage = game:GetService("ReplicatedStorage");
local shared = ReplicatedStorage.Shared
local GlassSignal = require(shared.TestImplementation);

local dog = GlassSignal.DoSomething:Connect(function(a)
    print(a);
    print(1);
end)

GlassSignal.DoSomething:Connect(function(a)
    print(a);
    print(2);
end)

dog:Disconnect();

local dog2 = GlassSignal.DoSomething:Connect(function(a)
    print(a);
    print(3);
end);

dog2:Disconnect();

GlassSignal.DoSomething:Connect(function(a)
    print(a);
    print(4);
end);

local dog3 = GlassSignal.DoSomething:Connect(function(a)
    print(a);
    print(5);
end);

dog3:Disconnect();

GlassSignal.DoSomething:Connect(function(a)
    print(a);
    print(6);
end);

-- expect output: {2, 4, 6}