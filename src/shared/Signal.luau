--[[

	Yet another signal implementation.

	Just with more basic functions.

	blah blah credit: glasswindows

	but everyone does signals like this so who am i really crediting?

]]--

--- Types ---
type Connection = {
	Connected: boolean, 
	Disconnect: (self: Connection) -> (),
	TempDisconnect: (self: Connection) -> (),
	Reconnect: (self: Connection) -> ()
}

type Signal = {
	Fire: <T...>(self: Signal, T...) -> (),
	Connect: <T...>(self: Signal, fn: (T...) -> ()) -> (),
	Once: <T...>(self: Signal, fn: (T...) -> ()) -> (),
	DisconnectAll: (self: Signal) -> (),
	TempDisconnectAll: (self: Signal) -> (),
	ReconnectAll: (self: Signal) -> ()
}

--- Main ---
local Signal = {} :: Signal;
Signal.__index = Signal;

local Connection = {} :: Connection;
Connection.__index = Connection;

--- Creates a new signal which contains a head that connects to any connections.
function Signal.new(): Signal
	return setmetatable({
		head = false, 
	}, Signal);
end

--- Fires the signal with any number of parameters. Continues to fire the next connected heads.
--- @param ...
function Signal:Fire(...)
	local _head = self.head;

	while _head do
		if _head.Connected then
			task.spawn(_head.fn, ...);
		end

		_head = _head.head;
	end
end

-- Creates a new connection that takes a function as a parameter. Substitutes itself in place of the previous connection,
-- while keeping the previous connection connected.
--- @param fn(T...) -> ()
--- @return Connection
function Signal:Connect<T...>(fn: (T...) -> ()): Connection
	local _connection = setmetatable({
		Connected = true,
		_signal = self,
		head = self.head,
		fn = fn
	}, Connection);

	self.head = _connection;

	return _connection;
end

--- Fires the signal only once while taking a function as the parameter, then disconnects itself.
--- @param fn(T...) -> ()
--- @return Connection
function Signal:Once<T...>(fn: (T...) -> ()): Connection
	local _connection;

	_connection = self:Connect(function(...)
		_connection:Disconnect();
		fn(...);
	end)

	return _connection;
end

--- Fully disconnects the signal.
function Connection:Disconnect()
	self._signal.head = self.head;
	self = nil;
end

--- Permanently disconnects all signals.
function Signal:DisconnectAll()
	local _head = self;
	local _nexthead = _head.head;

	while _nexthead do
		_head.head = nil;
		_head = _nexthead;
		_nexthead = _head.head;
	end
end

--- Temporarily disconnects the signal.
function Connection:TempDisconnect()
	self.Connected = false;
end

--- Temporarily disconnects all signals.
function Signal:TempDisconnectAll()
	local _head = self.head;

	while _head do
		_head.Connected = false;
		_head = _head.head;
	end
end

--- Reconnects the signal.
function Connection:Reconnect()
	self.Connected = true;
end

--- Reconnects all temporarily disconnected signals.
function Signal:ReconnectAll()
	local _head = self.head;

	while _head do
		_head.Connected = true;
		_head = _head.head;
	end
end

return Signal;