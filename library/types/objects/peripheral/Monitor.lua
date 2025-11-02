---@meta

---* Monitors are a block which act as a terminal, displaying information on one side. This allows them to be read and * interacted with in-world without opening a GUI. *  * Monitors act as [terminal redirects][`term.Redirect`] and so expose the same methods, as well as several additional * ones, which are documented below. *  * If the monitor is resized (by adding new blocks to the monitor, or by calling {@link setTextScale}), then a * [`monitor_resize`] event will be queued. *  * Like computers, monitors come in both normal (no colour) and advanced (colour) varieties. Advanced monitors be right * clicked, which will trigger a [`monitor_touch`] event. *  * ## Recipes *  *  *  *  * * @cc.module monitor * @cc.usage Write "Hello, world!" to an adjacent monitor: * * {@code * local monitor = peripheral.find("monitor") * monitor.setCursorPos(1, 1) * monitor.write("Hello, world!") * } * @cc.see monitor_resize Queued when a monitor is resized. * @cc.see monitor_touch Queued when an advanced monitor is clicked.

------
---[Official Documentation](https://tweaked.cc/peripheral/monitor.html)
---@class ccTweaked.peripheral.Monitor: ccTweaked.term.Redirect
Monitor = {}

---* Writes {

---@param text string The text to write.
---@param textColour string The corresponding text colours.
---@param backgroundColour string The corresponding background colours.
---@throws LuaException If the three inputs are not the same length.
---@since 1.74
------
---[Official Documentation](https://tweaked.cc/peripheral/monitor.html#v:blit)
function Monitor.blit(text, textColour, backgroundColour) end

---* Clears the terminal, filling it with the {

---@throws LuaException (hidden) If the terminal cannot be found.
------
---[Official Documentation](https://tweaked.cc/peripheral/monitor.html#v:clear)
function Monitor.clear() end

---* Clears the line the cursor is currently on, filling it with the {

---@throws LuaException (hidden) If the terminal cannot be found.
------
---[Official Documentation](https://tweaked.cc/peripheral/monitor.html#v:clearLine)
function Monitor.clearLine() end

---@return any The current background colour.
---@throws LuaException (hidden) If the terminal cannot be found.
---@since 1.74
------
---[Official Documentation](https://tweaked.cc/peripheral/monitor.html#v:getBackgroundColor)
function Monitor.getBackgroundColor() end

---* Return the current background colour. This is used when {

---@return any The current background colour.
---@throws LuaException (hidden) If the terminal cannot be found.
---@since 1.74
------
---[Official Documentation](https://tweaked.cc/peripheral/monitor.html#v:getBackgroundColour)
function Monitor.getBackgroundColour() end

---* Checks if the cursor is currently blinking. * *

---@return any If the cursor is blinking.
---@throws LuaException (hidden) If the terminal cannot be found.
---@since 1.80pr1.9
------
---[Official Documentation](https://tweaked.cc/peripheral/monitor.html#v:getCursorBlink)
function Monitor.getCursorBlink() end

---* Get the position of the cursor. * *

---@return number number: The x position of the cursor. number: The y position of the cursor.
---@return number number: The x position of the cursor. number: The y position of the cursor.
---@throws LuaException (hidden) If the terminal cannot be found.
------
---[Official Documentation](https://tweaked.cc/peripheral/monitor.html#v:getCursorPos)
function Monitor.getCursorPos() end

---* Determine if this terminal supports colour. *  * Terminals which do not support colour will still allow writing coloured text/backgrounds, but it will be * displayed in greyscale. * *

---@return any Whether this terminal supports colour.
---@throws LuaException (hidden) If the terminal cannot be found.
---@since 1.45
------
---[Official Documentation](https://tweaked.cc/peripheral/monitor.html#v:getIsColour)
function Monitor.getIsColour() end

---@param colourArg number The colour whose palette should be fetched.
---@return number number: The red channel, will be between 0 and 1. number: The green channel, will be between 0 and 1. number: The blue channel, will be between 0 and 1.
---@return number number: The red channel, will be between 0 and 1. number: The green channel, will be between 0 and 1. number: The blue channel, will be between 0 and 1.
---@return number number: The red channel, will be between 0 and 1. number: The green channel, will be between 0 and 1. number: The blue channel, will be between 0 and 1.
---@throws LuaException (hidden) If the terminal cannot be found.
---@since 1.80pr1
------
---[Official Documentation](https://tweaked.cc/peripheral/monitor.html#v:getPaletteColor)
function Monitor.getPaletteColor(colourArg) end

---* Get the current palette for a specific colour. * *

---@param colourArg number The colour whose palette should be fetched.
---@return number number: The red channel, will be between 0 and 1. number: The green channel, will be between 0 and 1. number: The blue channel, will be between 0 and 1.
---@return number number: The red channel, will be between 0 and 1. number: The green channel, will be between 0 and 1. number: The blue channel, will be between 0 and 1.
---@return number number: The red channel, will be between 0 and 1. number: The green channel, will be between 0 and 1. number: The blue channel, will be between 0 and 1.
---@throws LuaException (hidden) If the terminal cannot be found.
---@since 1.80pr1
------
---[Official Documentation](https://tweaked.cc/peripheral/monitor.html#v:getPaletteColour)
function Monitor.getPaletteColour(colourArg) end

---* Get the size of the terminal. * *

---@return number number: The terminal's width. number: The terminal's height.
---@return number number: The terminal's width. number: The terminal's height.
---@throws LuaException (hidden) If the terminal cannot be found.
------
---[Official Documentation](https://tweaked.cc/peripheral/monitor.html#v:getSize)
function Monitor.getSize() end

---@return any The current text colour.
---@throws LuaException (hidden) If the terminal cannot be found.
---@since 1.74
------
---[Official Documentation](https://tweaked.cc/peripheral/monitor.html#v:getTextColor)
function Monitor.getTextColor() end

---* Return the colour that new text will be written as. * *

---@return any The current text colour.
---@throws LuaException (hidden) If the terminal cannot be found.
---@since 1.74
------
---[Official Documentation](https://tweaked.cc/peripheral/monitor.html#v:getTextColour)
function Monitor.getTextColour() end

---* Get the monitor's current text scale. * *

---@return any The monitor's current scale.
---@throws LuaException If the monitor cannot be found.
---@since 1.81.0
------
---[Official Documentation](https://tweaked.cc/peripheral/monitor.html#v:getTextScale)
function Monitor.getTextScale() end

---@return any Whether this terminal supports colour.
---@throws LuaException (hidden) If the terminal cannot be found.
---@since 1.45
------
---[Official Documentation](https://tweaked.cc/peripheral/monitor.html#v:isColor)
function Monitor.isColor() end

---@return any Whether this terminal supports colour.
---@throws LuaException (hidden) If the terminal cannot be found.
---@since 1.45
------
---[Official Documentation](https://tweaked.cc/peripheral/monitor.html#v:isColour)
function Monitor.isColour() end

---* Move all positions up (or down) by {

---@param y number The number of lines to move up by. This may be a negative number.
---@throws LuaException (hidden) If the terminal cannot be found.
------
---[Official Documentation](https://tweaked.cc/peripheral/monitor.html#v:scroll)
function Monitor.scroll(y) end

---@param colourArg number The new background colour.
---@throws LuaException (hidden) If the terminal cannot be found.
---@since 1.45
------
---[Official Documentation](https://tweaked.cc/peripheral/monitor.html#v:setBackgroundColor)
function Monitor.setBackgroundColor(colourArg) end

---* Set the current background colour. This is used when {

---@param colourArg number The new background colour.
---@throws LuaException (hidden) If the terminal cannot be found.
---@since 1.45
------
---[Official Documentation](https://tweaked.cc/peripheral/monitor.html#v:setBackgroundColour)
function Monitor.setBackgroundColour(colourArg) end

---* Sets whether the cursor should be visible (and blinking) at the current {

---@param blink boolean Whether the cursor should blink.
---@throws LuaException (hidden) If the terminal cannot be found.
------
---[Official Documentation](https://tweaked.cc/peripheral/monitor.html#v:setCursorBlink)
function Monitor.setCursorBlink(blink) end

---* Set the position of the cursor. {

---@param x number The new x position of the cursor.
---@param y number The new y position of the cursor.
---@throws LuaException (hidden) If the terminal cannot be found.
------
---[Official Documentation](https://tweaked.cc/peripheral/monitor.html#v:setCursorPos)
function Monitor.setCursorPos(x, y) end

---@param args any... The new palette values.
---@throws LuaException (hidden) If the terminal cannot be found.
---@since 1.80pr1
------
---[Official Documentation](https://tweaked.cc/peripheral/monitor.html#v:setPaletteColor)
function Monitor.setPaletteColor(args) end

---* Set the palette for a specific colour. *  * ComputerCraft's palette system allows you to change how a specific colour should be displayed. For instance, you * can make [`colors.red`] more red by setting its palette to #FF0000. This does now allow you to draw more * colours - you are still limited to 16 on the screen at one time - but you can change which colours are * used. * *

---@param args any... The new palette values.
---@throws LuaException (hidden) If the terminal cannot be found.
---@since 1.80pr1
------
---[Official Documentation](https://tweaked.cc/peripheral/monitor.html#v:setPaletteColour)
function Monitor.setPaletteColour(args) end

---@param colourArg number The new text colour.
---@throws LuaException (hidden) If the terminal cannot be found.
---@since 1.45
------
---[Official Documentation](https://tweaked.cc/peripheral/monitor.html#v:setTextColor)
function Monitor.setTextColor(colourArg) end

---* Set the colour that new text will be written as. * *

---@param colourArg number The new text colour.
---@throws LuaException (hidden) If the terminal cannot be found.
---@since 1.45
------
---[Official Documentation](https://tweaked.cc/peripheral/monitor.html#v:setTextColour)
function Monitor.setTextColour(colourArg) end

---* Set the scale of this monitor. A larger scale will result in the monitor having a lower resolution, but display * text much larger. * *

---@param scaleArg number The monitor's scale. This must be a multiple of 0.5 between 0.5 and 5.
---@throws LuaException If the scale is out of range.
------
---[Official Documentation](https://tweaked.cc/peripheral/monitor.html#v:setTextScale)
function Monitor.setTextScale(scaleArg) end

---* Write {

---@param textA any The text to write.
---@throws LuaException (hidden) If the terminal cannot be found.
------
---[Official Documentation](https://tweaked.cc/peripheral/monitor.html#v:write)
function Monitor.write(textA) end
