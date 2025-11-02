---@meta

------
---[Official Documentation](https://tweaked.cc/peripheral/pocketmodem.html)
---@class ccTweaked.peripheral.Pocketmodem
Pocketmodem = {}

---* Close an open channel, meaning it will no longer receive messages. * *

---@param channel number The channel to close.
---@throws LuaException If the channel is out of range.
------
---[Official Documentation](https://tweaked.cc/peripheral/pocketmodem.html#v:close)
function Pocketmodem.close(channel) end

---* Close all open channels.

------
---[Official Documentation](https://tweaked.cc/peripheral/pocketmodem.html#v:closeAll)
function Pocketmodem.closeAll() end

---* Check if a channel is open. * *

---@param channel number The channel to check.
---@return any Whether the channel is open.
---@throws LuaException If the channel is out of range.
------
---[Official Documentation](https://tweaked.cc/peripheral/pocketmodem.html#v:isOpen)
function Pocketmodem.isOpen(channel) end

---* Determine if this is a wired or wireless modem. *  * Some methods (namely those dealing with wired networks and remote peripherals) are only available on wired * modems. * *

---@return any {
------
---[Official Documentation](https://tweaked.cc/peripheral/pocketmodem.html#v:isWireless)
function Pocketmodem.isWireless() end

---* Open a channel on a modem. A channel must be open in order to receive messages. Modems can have up to 128 * channels open at one time. * *

---@param channel number The channel to open. This must be a number between 0 and 65535.
---@throws LuaException If the channel is out of range.
---@throws LuaException If there are too many open channels.
------
---[Official Documentation](https://tweaked.cc/peripheral/pocketmodem.html#v:open)
function Pocketmodem.open(channel) end

---* Sends a modem message on a certain channel. Modems listening on the channel will queue a {

---@param channel number The channel to send messages on.
---@param replyChannel number The channel that responses to this message should be sent on. This can be the same as
---@param payload any The object to send. This can be any primitive type (boolean, number, string) as well as
---@throws LuaException If the channel is out of range.
------
---[Official Documentation](https://tweaked.cc/peripheral/pocketmodem.html#v:transmit)
function Pocketmodem.transmit(channel, replyChannel, payload) end
