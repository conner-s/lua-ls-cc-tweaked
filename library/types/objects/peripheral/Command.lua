---@meta

---* This peripheral allows you to interact with command blocks. *  * Command blocks are only wrapped as peripherals if the {@code enable_command_block} option is true within the * config. *  * This API is not the same as the {@link CommandAPI} API, which is exposed on command computers. * * @cc.module command

------
---[Official Documentation](https://tweaked.cc/peripheral/command.html)
---@class ccTweaked.peripheral.Command
Command = {}

---* Get the command this command block will run. * *

---@return any The current command.
------
---[Official Documentation](https://tweaked.cc/peripheral/command.html#v:getCommand)
function Command.getCommand() end

---* Execute the command block once. * *

---@return boolean boolean: If the command completed successfully.
------
---[Official Documentation](https://tweaked.cc/peripheral/command.html#v:runCommand)
function Command.runCommand() end

---* Set the command block's command. * *

---@param command string The new command.
------
---[Official Documentation](https://tweaked.cc/peripheral/command.html#v:setCommand)
function Command.setCommand(command) end
