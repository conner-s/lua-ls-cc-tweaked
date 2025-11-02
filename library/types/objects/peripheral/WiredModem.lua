---@meta

------
---[Official Documentation](https://tweaked.cc/peripheral/wiredmodem.html)
---@class ccTweaked.peripheral.Wiredmodem
Wiredmodem = {}

---* Returns the network name of the current computer, if the modem is on. This * may be used by other computers on the network to wrap this computer as a * peripheral. *  * > [!NOTE] * > This function only appears on wired modems. Check {

---@return any The current computer's name.
---@since 1.80pr1.7
------
---[Official Documentation](https://tweaked.cc/peripheral/wiredmodem.html#v:attach)
function Wiredmodem.attach() end

---* Get the type of a peripheral is available on this wired network. *  * > [!NOTE] * > This function only appears on wired modems. Check {

---@param arguments any... The arguments
---@return any The peripheral's name.
------
---[Official Documentation](https://tweaked.cc/peripheral/wiredmodem.html#v:callRemote)
function Wiredmodem.callRemote(arguments) end

---* Close an open channel, meaning it will no longer receive messages. * *

---@param channel number The channel to close.
---@throws LuaException If the channel is out of range.
------
---[Official Documentation](https://tweaked.cc/peripheral/wiredmodem.html#v:close)
function Wiredmodem.close(channel) end

---* Close all open channels.

------
---[Official Documentation](https://tweaked.cc/peripheral/wiredmodem.html#v:closeAll)
function Wiredmodem.closeAll() end

---* List all remote peripherals on the wired network. *  * If this computer is attached to the network, it _will not_ be included in * this list. *  * > [!NOTE] * > This function only appears on wired modems. Check {

---@return any Remote peripheral names on the network.
------
---[Official Documentation](https://tweaked.cc/peripheral/wiredmodem.html#v:getNamesRemote)
function Wiredmodem.getNamesRemote() end

---* Check if a channel is open. * *

---@param channel number The channel to check.
---@return any Whether the channel is open.
---@throws LuaException If the channel is out of range.
------
---[Official Documentation](https://tweaked.cc/peripheral/wiredmodem.html#v:isOpen)
function Wiredmodem.isOpen(channel) end

---* Determine if a peripheral is available on this wired network. *  * > [!NOTE] * > This function only appears on wired modems. Check {

---@param name string The peripheral's name.
---@return boolean boolean If a peripheral is present with the given name.
------
---[Official Documentation](https://tweaked.cc/peripheral/wiredmodem.html#v:isPresentRemote)
function Wiredmodem.isPresentRemote(name) end

---* Determine if this is a wired or wireless modem. *  * Some methods (namely those dealing with wired networks and remote peripherals) are only available on wired * modems. * *

---@return any {
------
---[Official Documentation](https://tweaked.cc/peripheral/wiredmodem.html#v:isWireless)
function Wiredmodem.isWireless() end

---* Open a channel on a modem. A channel must be open in order to receive messages. Modems can have up to 128 * channels open at one time. * *

---@param channel number The channel to open. This must be a number between 0 and 65535.
---@throws LuaException If the channel is out of range.
---@throws LuaException If there are too many open channels.
------
---[Official Documentation](https://tweaked.cc/peripheral/wiredmodem.html#v:open)
function Wiredmodem.open(channel) end

---* Sends a modem message on a certain channel. Modems listening on the channel will queue a {

---@param channel number The channel to send messages on.
---@param replyChannel number The channel that responses to this message should be sent on. This can be the same as
---@param payload any The object to send. This can be any primitive type (boolean, number, string) as well as
---@throws LuaException If the channel is out of range.
------
---[Official Documentation](https://tweaked.cc/peripheral/wiredmodem.html#v:transmit)
function Wiredmodem.transmit(channel, replyChannel, payload) end
