---@meta

---* A computer or turtle wrapped as a peripheral. *  * This allows for basic interaction with adjacent computers. Computers wrapped as peripherals will have the type * {@code computer} while turtles will be {@code turtle}. * * @cc.module computer

------
---[Official Documentation](https://tweaked.cc/peripheral/computer.html)
---@class ccTweaked.peripheral.Computer
Computer = {}

---* Get the other computer's ID. * *

---@return any The computer's ID.
------
---[Official Documentation](https://tweaked.cc/peripheral/computer.html#v:getID)
function Computer.getID() end

---* Get the other computer's label. * *

---@return any The computer's label.
------
---[Official Documentation](https://tweaked.cc/peripheral/computer.html#v:getLabel)
function Computer.getLabel() end

---* Determine if the other computer is on. * *

---@return any If the computer is on.
------
---[Official Documentation](https://tweaked.cc/peripheral/computer.html#v:isOn)
function Computer.isOn() end

---* Reboot or turn on the other computer.

------
---[Official Documentation](https://tweaked.cc/peripheral/computer.html#v:reboot)
function Computer.reboot() end

---* Shutdown the other computer.

------
---[Official Documentation](https://tweaked.cc/peripheral/computer.html#v:shutdown)
function Computer.shutdown() end

---* Turn the other computer on.

------
---[Official Documentation](https://tweaked.cc/peripheral/computer.html#v:turnOn)
function Computer.turnOn() end
