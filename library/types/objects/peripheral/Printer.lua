---@meta

---* The printer peripheral allows printing text onto pages. These pages can then be crafted together into printed pages * or books. *  * Printers require ink (one of the coloured dyes) and paper in order to function. Once loaded, a new page can be * started with {@link #newPage()}. Then the printer can be used similarly to a normal terminal; {@linkplain * #write(Coerced) text can be written}, and {@linkplain #setCursorPos(int, int) the cursor moved}. Once all text has * been printed, {@link #endPage()} should be called to finally print the page. *  * ## Recipes *  *  *  *  *  * * @cc.usage Print a page titled "Hello" with a small message on it. * * {@code * local printer = peripheral.find("printer") * * -- Start a new page, or print an error. * if not printer.newPage() then * error("Cannot start a new page. Do you have ink and paper?") * end * * -- Write to the page * printer.setPageTitle("Hello") * printer.write("This is my first page") * printer.setCursorPos(1, 3) * printer.write("This is two lines below.") * * -- And finally print the page! * if not printer.endPage() then * error("Cannot end the page. Is there enough space?") * end * } * @cc.module printer * @cc.see cc.strings.wrap To wrap text before printing it.

------
---[Official Documentation](https://tweaked.cc/peripheral/printer.html)
---@class ccTweaked.peripheral.Printer
Printer = {}

---* Finalizes printing of the current page and outputs it to the tray. * *

---@return any Whether the page could be successfully finished.
---@throws LuaException If a page isn't being printed.
------
---[Official Documentation](https://tweaked.cc/peripheral/printer.html#v:endPage)
function Printer.endPage() end

---* Returns the current position of the cursor on the page. * *

---@return number number: The X position of the cursor. number: The Y position of the cursor.
---@return number number: The X position of the cursor. number: The Y position of the cursor.
---@throws LuaException If a page isn't being printed.
------
---[Official Documentation](https://tweaked.cc/peripheral/printer.html#v:getCursorPos)
function Printer.getCursorPos() end

---* Returns the amount of ink left in the printer. * *

---@return number The amount of ink available to print with.
------
---[Official Documentation](https://tweaked.cc/peripheral/printer.html#v:getInkLevel)
function Printer.getInkLevel() end

---* Returns the size of the current page. * *

---@return number number: The width of the page. number: The height of the page.
---@return number number: The width of the page. number: The height of the page.
---@throws LuaException If a page isn't being printed.
------
---[Official Documentation](https://tweaked.cc/peripheral/printer.html#v:getPageSize)
function Printer.getPageSize() end

---* Returns the amount of paper left in the printer. * *

---@return number The amount of paper available to print with.
------
---[Official Documentation](https://tweaked.cc/peripheral/printer.html#v:getPaperLevel)
function Printer.getPaperLevel() end

---* Starts printing a new page. * *

---@return any Whether a new page could be started.
------
---[Official Documentation](https://tweaked.cc/peripheral/printer.html#v:newPage)
function Printer.newPage() end

---* Sets the position of the cursor on the page. * *

---@param x number The X coordinate to set the cursor at.
---@param y number The Y coordinate to set the cursor at.
---@throws LuaException If a page isn't being printed.
------
---[Official Documentation](https://tweaked.cc/peripheral/printer.html#v:setCursorPos)
function Printer.setCursorPos(x, y) end

---* Sets the title of the current page. * *

---@param title? any The title to set for the page.
---@throws LuaException If a page isn't being printed.
------
---[Official Documentation](https://tweaked.cc/peripheral/printer.html#v:setPageTitle)
function Printer.setPageTitle(title) end

---* Writes text to the current page. * *

---@param textA any The value to write to the page.
---@throws LuaException If any values couldn't be converted to a string, or if no page is started.
------
---[Official Documentation](https://tweaked.cc/peripheral/printer.html#v:write)
function Printer.write(textA) end
