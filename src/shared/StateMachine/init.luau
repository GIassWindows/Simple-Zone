--[[

	State Machine Implementation.

	Example of transition table:

	State = {
		"State you can't transition to 1",
		"State you can't transition to 2"
	}

	Documentation:

	```lua
	local CustomStates = {
		Test = {
			"Test1"
		},
		Test1 = {
			""
		}
	}

	local StateMachine = require("../Path/To/StateMachine.luau");
	local States = StateMachine.Create(CustomStates);

	States:Enter("Test"); -- Enters the state "Test".
	States:Enter("Test1"); -- Does nothing, Test1 is a state that's untransitionable.

	States:Exit("Test"); -- Exits the state "Test".

	-- Callback parameter is the state you entered to.
	States.OnStateEntered:Connect(function(StateEntered: string)
		print(StateEntered); -- output: "Test";
	end)

	-- Callback parameter is the state you exited from.
	States.OnStateExited:Connect(function(OnStateExited: string)
		print(OnStateExited); -- output: "Test";

		States:Enter("Test1"); -- Enters the state "Test1" because it is no longer in state Test.
	end)
	```

	Enjoy!
		- GlassWindows

]]

local Signal = require(script.signal);
local Transitions = require(script.Transitions);

-- Types --
type Signal = {
	Fire                    : <T...>(self: Signal, T...) -> (),
	Connect                 : <T...>(self: Signal, callback: (T...) -> ()) -> (),
	Once                    : <T...>(self: Signal, callback: (T...) -> ()) -> (),
	DisconnectAll           : (self: Signal) -> (),
	TempDisconnectAll       : (self: Signal) -> (),
	ReconnectAll            : (self: Signal) -> ()
}

type OnStateEntered = {
	Connect                 : <T...>(self: Signal, callback: (StateEntered: string) -> ()) -> (),
}

type OnStateExited = {
	Connect                 : <T...>(self: Signal, callback: (StateExited: string) -> ()) -> (),
}

type States = {    
    AddState                : <string>(self: States, state: string) -> (),
    RemoveState             : <string>(self: States, state: string) -> (),
    RemoveAllStates         : (self: States) -> (),
    CheckStates             : <string>(self: States, state: { string } | string) -> (),
    ShowStates              : (self: States) -> (),
    CanTransitionToState    : <string>(self: States, state: string, Transition: { [string]: { string } }) -> ()
}

export type StateMachine = {
	Transitions 			: { [string]: { string } },
	States					: States,
    OnStateEntered          : OnStateEntered,
    OnStateExited           : OnStateExited,
    Enter                   : (self: StateMachine, state: string) -> boolean,
    Exit                    : (self: StateMachine, state: string) -> (),
    CheckState              : (self: StateMachine, state: string) -> boolean
}

-- Main (States) --
local States = {} :: States;
States.__index = States;

--- Creates a new States object.
--- @return States
function States.new(): States
	local self = setmetatable({
		CurrentStates = {} :: { string }
	}, States);

	return self;
end

--- Adds a State to the CurrentStates table.
--- @param state: string
--- @return boolean
function States:AddState(state: string): boolean
	if table.find(self.CurrentStates, state) then return false end
	table.insert(self.CurrentStates, state);
	return true;
end

--- Removes a State from the CurrentStates table.
--- @param state: string
function States:RemoveState(state: string)
	local index = table.find(self.CurrentStates, state);
	if index then
		table.remove(self.CurrentStates, index);
	end
end

--- Checks if a State is in the CurrentStates table.
--- @param state: {string} | string
--- @return boolean
function States:CheckStates(states: { string } | string): boolean
	local current = self.CurrentStates;

	if type(states) == "string" then
		return table.find(current, states) ~= nil;
	end

	for _, state: string in states do
		if table.find(current, state) then
			return false; 
		end
	end

	return true;
end

--- Checks if a State can be transitioned to.
--- @param state: string
--- @return boolean
function States:CanTransitionToState(state: string, Transitions: { string: { string } }): boolean
	return self:CheckStates(Transitions[state]);
end

-- Main (StateMachine) --
local StateMachine = {} :: StateMachine;
StateMachine.__index = StateMachine;

--- Creates a new State Machine.
--- @return StateMachine
function StateMachine.Create(CustomTransitionTable: { string: { string } } | nil ): StateMachine
	local self = setmetatable({
		Transitions = Transitions :: { [string]: { string } },
		OnStateEntered = Signal.new() :: OnStateEntered,
		OnStateExited = Signal.new() :: OnStateExited,
		States = States.new() :: States
	}, StateMachine);
	
	if CustomTransitionTable then
		self.Transitions = CustomTransitionTable :: {string: { string }};
	end

	return self;
end

--- Transitions to a state provided that it's legal.
--- @param state: string
--- @return boolean
function StateMachine:Enter(state: string): boolean
	local CanTransition: boolean = self.States:CanTransitionToState(state, self.Transitions);
	if not CanTransition then return CanTransition end;
	
	self.OnStateEntered:Fire(state);
	self.States:AddState(state);
	
	return CanTransition;
end

--- Exits the state.
--- @param state: string
--- @return nil
function StateMachine:Exit(state: string)
	self.OnStateExited:Fire(state);
	self.States:RemoveState(state);
end

--- Returns the existence of a state.
--- @param state: string
--- @return boolean
function StateMachine:CheckStates(state: string): boolean
	return self.States:CheckStates(state);
end

return StateMachine;