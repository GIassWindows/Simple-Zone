--[[

	Example: StateName = { States you can't transition to }

	Player has state State1, he cannot transition to State2, State3, State4.

	State1 = {
		"State2",
		"State3",
		"State4"
	},
	State2 = {
		"State3",
		"State4"
	}

]]

return {
	Attack = {
		"Attack",
		"Block",
		"Stun",
		"Aerial"
	},
	Block = {
		"Attack",
		"Block",
		"Stun",
		"Dash"
	},
	Running = {
		"Block",
		"Dash"
	},
	Aerial = {
		"Aerial",
		"Block",
		"Dash",
		"Stun"
	},
	Stun = {
		"Hyperarmour"
	}
} :: { string: { string } }