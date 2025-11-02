# Peripheral Method Extraction Scripts

## extract_peripheral_methods.py

This script extracts peripheral method definitions from CC-Tweaked Java source code and generates Lua LSP type definition files.

### Purpose

When CC-Tweaked adds new peripheral methods or updates existing ones, this script can automatically extract:

- Method signatures (names, parameters, return types)
- Javadoc documentation
- Parameter types and descriptions
- Return value documentation
- Exception/error information

And generate corresponding `.lua` type definition files for the Lua Language Server.

### Usage

```bash
python3 scripts/extract_peripheral_methods.py <cc-tweaked-path> <output-dir>
```

**Arguments:**

- `<cc-tweaked-path>`: Path to the CC-Tweaked repository root
- `<output-dir>`: Directory where generated `.lua` files should be written (typically `library/types/objects/peripheral/`)

**Example:**

```bash
python3 scripts/extract_peripheral_methods.py \
    ../CC-Tweaked \
    library/types/objects/peripheral/
```

### How It Works

1. **Scans Java Files**: Finds all `*Peripheral.java` files in the CC-Tweaked source tree
2. **Parses Methods**: Extracts methods annotated with `@LuaFunction`
3. **Extracts Documentation**: Parses Javadoc comments for:
   - Method descriptions
   - `@param` tags (parameter documentation)
   - `@return` / `@cc.treturn` tags (return value documentation)
   - `@throws` tags (error documentation)
   - `@cc.since` tags (version information)
4. **Type Mapping**: Converts Java types to Lua types:
   - `int`, `long`, `double` → `number`
   - `String` → `string`
   - `boolean` → `boolean`
   - `Map`, `LuaTable` → `table`
   - `Object[]` → multiple returns
   - etc.
5. **Handles Inheritance**: Merges methods from parent classes (e.g., `TermMethods` for monitors)
6. **Generates Lua Files**: Creates `.lua` type definition files in the correct format

### Generated File Format

The script generates files like:

```lua
---@meta

---Monitors are a block that can display...
------
---[Official Documentation](https://tweaked.cc/peripheral/monitor.html)
---@class ccTweaked.peripheral.Monitor: ccTweaked.term.Redirect
Monitor = {}

---Set the scale of text on this monitor
---@param scale number The scale of the monitor. Must be a multiple of 0.5 between 0.5 and 5
---@throws If the `scale` is out of range
------
---[Official Documentation](https://tweaked.cc/peripheral/monitor.html#v:setTextScale)
function Monitor.setTextScale(scale) end
```

### Limitations

- **Regex-based parsing**: The script uses regex to parse Java source, which may miss edge cases
- **Method bodies**: Only extracts signatures, not implementation details
- **Complex generics**: Some complex generic types may not map perfectly
- **Method aliases**: Handles `@LuaFunction({ "name1", "name2" })` but may need manual verification

### Manual Review Required

After running the script, you should:

1. **Review generated files** for accuracy
2. **Check method names** match actual usage
3. **Verify type mappings** are correct
4. **Add missing documentation** if Javadoc is incomplete
5. **Handle special cases** like variadic arguments (`IArguments`)
6. **Update parent class references** if inheritance structure changes

### Integration with Workflow

This script is intended to be run:

- When CC-Tweaked updates are pulled
- Before committing updated type definitions
- As a starting point for manual refinement

The generated files should be committed to the repository after review.
