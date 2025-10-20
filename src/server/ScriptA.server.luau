local ReplicatedStorage = game:GetService("ReplicatedStorage");
local shared = ReplicatedStorage.Shared
local StateMachine = require(shared.StateMachine);

type StateMachineType = StateMachine.StateMachine;

local CustomStates = {
    Test = {
        "Test",
    },
}

local States: StateMachineType = StateMachine.Create(CustomStates);

task.spawn(function()
    while task.wait() do
        States:Enter("Test"); -- Enter the state
    end
end)

-- State Entered --
States.OnStateEntered:Connect(function(StateEntered: string)
    print("New State: " .. StateEntered);
    
    task.delay(1, function()
        States:Exit("Test"); -- Exit the state
    end);
end)

-- State Exited --
States.OnStateExited:Connect(function(StateExited: string)
    print("State Exited: " .. StateExited);
end)
