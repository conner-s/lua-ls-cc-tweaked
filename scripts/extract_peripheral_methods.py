#!/usr/bin/env python3
"""
Extract peripheral method definitions from CC-Tweaked Java source code
and generate Lua LSP type definitions.

This script scans Java peripheral classes for @LuaFunction annotated methods,
extracts their signatures and documentation, and generates .lua type definition files.
"""

import re
import sys
from pathlib import Path
from typing import Dict, List, Optional, Tuple
from dataclasses import dataclass


@dataclass
class MethodParam:
    """Represents a method parameter."""
    name: str
    java_type: str
    lua_type: str
    optional: bool = False
    doc: str = ""


@dataclass
class MethodDef:
    """Represents a Lua function method definition."""
    name: str
    aliases: List[str]
    params: List[MethodParam]
    return_type: str  # "void", "number", "number,number", etc.
    return_doc: str = ""
    doc: str = ""
    throws: Optional[List[str]] = None
    since: str = ""
    source_file: str = ""  # Path to the Java file where this method was defined


@dataclass
class PeripheralClass:
    """Represents a peripheral class with its methods."""
    name: str
    full_name: str
    type_name: str  # e.g., "monitor", "speaker"
    parent_classes: List[str]
    methods: List[MethodDef]
    class_doc: str = ""


# Java type to Lua type mappings
JAVA_TO_LUA_TYPES = {
    "void": "",
    "boolean": "boolean",
    "int": "number",
    "long": "number",
    "double": "number",
    "float": "number",
    "String": "string",
    "Map": "table",
    "LuaTable": "table",
    "Object[]": "any...",
    "ByteBuffer": "string",
    "Coerced<String>": "string",
    "Coerced<ByteBuffer>": "string",
    "IArguments": "any...",  # Variadic arguments
}

# Special parameter types that should be optional
OPTIONAL_TYPES = {
    "Optional<",
    "Nullable",
}

# Base classes to check for inherited methods
BASE_CLASSES = {
    "TermMethods": "projects/core/src/main/java/dan200/computercraft/core/apis/TermMethods.java",
    # Add other base classes as needed
}


def normalize_java_type(java_type: str) -> str:
    """Normalize Java type to handle generics and simplify."""
    # Remove generics
    java_type = re.sub(r'<.*?>', '', java_type)
    # Remove array brackets
    java_type = java_type.replace("[]", "Array")
    # Handle Optional
    if java_type.startswith("Optional<"):
        java_type = java_type[8:-1]
    # Strip whitespace
    return java_type.strip()


def java_type_to_lua(java_type: str) -> str:
    """Convert Java type to Lua type string."""
    normalized = normalize_java_type(java_type)
    
    # Check direct mappings
    if normalized in JAVA_TO_LUA_TYPES:
        return JAVA_TO_LUA_TYPES[normalized]
    
    # Check for Object[] (multiple returns)
    if java_type.endswith("[]") or "Object[]" in java_type:
        # Try to determine return count from Javadoc later
        return "any..."
    
    # Default to any for unknown types
    return "any"


def is_optional_type(java_type: str) -> bool:
    """Check if a Java type is optional."""
    return any(opt in java_type for opt in OPTIONAL_TYPES)


def extract_javadoc_params(javadoc: str) -> Dict[str, str]:
    """Extract @param documentation from Javadoc."""
    params = {}
    param_pattern = r'@param\s+(\w+)\s+(.+)'
    for match in re.finditer(param_pattern, javadoc, re.MULTILINE):
        param_name = match.group(1)
        param_doc = match.group(2).strip()
        # Remove until next tag or end
        param_doc = re.split(r'@|\n\s*\n', param_doc)[0].strip()
        params[param_name] = param_doc
    return params


def extract_javadoc_returns(javadoc: str) -> Tuple[str, str]:
    """Extract @return and @cc.treturn documentation."""
    return_type = ""
    return_doc = ""
    
    # Check for @cc.treturn (multiple returns)
    treturn_pattern = r'@cc\.treturn\s+(\w+)\s+(.+)'
    treturn_matches = list(re.finditer(treturn_pattern, javadoc))
    if treturn_matches:
        return_types = [m.group(1) for m in treturn_matches]
        return_docs = [m.group(2).strip().split('@')[0].strip() for m in treturn_matches]
        return_type = ",".join(return_types)
        return_doc = " ".join(f"{rt}: {rd}" for rt, rd in zip(return_types, return_docs))
    else:
        # Single @return
        return_pattern = r'@return\s+(.+)'
        match = re.search(return_pattern, javadoc)
        if match:
            return_doc = match.group(1).strip()
            return_doc = re.split(r'@|\n\s*\n', return_doc)[0].strip()
            # Try to infer type from doc
            if "boolean" in return_doc.lower():
                return_type = "boolean"
            elif "number" in return_doc.lower() or "int" in return_doc.lower():
                return_type = "number"
            elif "string" in return_doc.lower():
                return_type = "string"
            elif "table" in return_doc.lower():
                return_type = "table"
            else:
                return_type = "any"
    
    return return_type, return_doc


def extract_throws(javadoc: str) -> List[str]:
    """Extract @throws documentation."""
    throws = []
    throws_pattern = r'@throws\s+(.+?)(?=@|\n\n|$)'
    for match in re.finditer(throws_pattern, javadoc, re.MULTILINE | re.DOTALL):
        throw_doc = match.group(1).strip()
        throw_doc = re.split(r'@|\n\s*\n', throw_doc)[0].strip()
        throws.append(throw_doc)
    return throws


def extract_since(javadoc: str) -> str:
    """Extract @cc.since version."""
    since_pattern = r'@cc\.since\s+(\S+)'
    match = re.search(since_pattern, javadoc)
    return match.group(1) if match else ""


def extract_method_signature(method_code: str) -> Optional[Tuple[str, List[str], List[Tuple[str, str, str, bool]], str]]:
    """Extract method signature: return_type, aliases, params, javadoc.
    
    Returns:
        Tuple of (return_type, aliases, params, javadoc) where:
        - return_type: Java return type string
        - aliases: List of method names (aliases from @LuaFunction annotation)
        - params: List of tuples (param_name, param_type, lua_type, optional)
        - javadoc: Javadoc comment string
    """
    # Extract Javadoc
    javadoc_match = re.search(r'/\*\*(.*?)\*/', method_code, re.DOTALL)
    javadoc = javadoc_match.group(1) if javadoc_match else ""
    
    # Extract @LuaFunction annotation
    lua_func_match = re.search(r'@LuaFunction(?:\s*\([^)]*\))?', method_code)
    if not lua_func_match:
        return None
    
    # Extract method name(s) from annotation
    annotation_text = lua_func_match.group(0)
    has_explicit_aliases = False
    aliases = []
    if '(' in annotation_text:
        # Extract aliases: @LuaFunction({ "getTextColour", "getTextColor" })
        alias_match = re.search(r'\{[^}]+\}', annotation_text)
        if alias_match:
            aliases = [a.strip().strip('"\'') for a in alias_match.group(0)[1:-1].split(',')]
            has_explicit_aliases = True
    
    # Extract method signature
    # Pattern: [modifiers] return_type method_name(params) [throws]
    # Need to find the actual method declaration, not just any public thing
    # Look for: public (final)? returnType methodName(params) throws?
    # Handle Object[] and other array types, generics, etc.
    method_sig_pattern = r'public\s+(?:final\s+)?(?:static\s+)?((?:\w+(?:<[\w\s,<>]+>)?|\w+(?:\[\])?|Object\[\]))\s+(\w+)\s*\((.*?)\)(?:\s+throws\s+\w+)?'
    
    sig_match = re.search(method_sig_pattern, method_code, re.MULTILINE | re.DOTALL)
    if not sig_match:
        return None
    
    return_type = sig_match.group(1).strip()
    method_name = sig_match.group(2).strip()
    params_str = sig_match.group(3).strip()
    
    # Determine final aliases to use
    if has_explicit_aliases:
        # When @LuaFunction has explicit aliases, ONLY use those (don't include Java method name)
        # This is correct because the annotation tells us what names to expose to Lua
        pass  # aliases already contains the explicit names
    elif aliases:
        # If aliases exist but weren't explicit (shouldn't happen), use them plus method name
        if method_name not in aliases:
            aliases.insert(0, method_name)
    else:
        # No aliases, use the Java method name
        aliases = [method_name]
    
    # Parse parameters
    params = []
    if params_str:
        # Split parameters, handling generics
        param_parts = []
        current = ""
        depth = 0
        for char in params_str:
            if char == '<':
                depth += 1
            elif char == '>':
                depth -= 1
            elif char == ',' and depth == 0:
                if current.strip():
                    param_parts.append(current.strip())
                current = ""
                continue
            current += char
        if current.strip():
            param_parts.append(current.strip())
        
        for param in param_parts:
            # Pattern: [@Nullable] [final] Type paramName
            param_match = re.match(r'(?:@\w+\s+)?(?:final\s+)?(.+?)\s+(\w+)$', param.strip())
            if param_match:
                param_type = param_match.group(1).strip()
                param_name = param_match.group(2).strip()
                
                # Skip context parameters (ILuaContext, IComputerAccess, IArguments)
                if any(skip in param_type for skip in ['ILuaContext', 'IComputerAccess']):
                    continue
                
                optional = is_optional_type(param_type)
                lua_type = java_type_to_lua(param_type)
                params.append((param_name, param_type, lua_type, optional))
    
    return return_type, aliases, params, javadoc


def find_java_file_for_class(class_name: str, base_path: Path, package_hint: str = "") -> Optional[Path]:
    """Find the Java file for a given class name by searching the codebase."""
    # If we have a package hint, try that first
    if package_hint:
        package_path = package_hint.replace(".", "/")
        possible_path = base_path / "projects" / "common" / "src" / "main" / "java" / package_path / f"{class_name}.java"
        if possible_path.exists():
            return possible_path
        possible_path = base_path / "projects" / "core" / "src" / "main" / "java" / package_path / f"{class_name}.java"
        if possible_path.exists():
            return possible_path
    
    # Search in common and core
    for base_dir in ["common", "core"]:
        java_dir = base_path / "projects" / base_dir / "src" / "main" / "java"
        if java_dir.exists():
            for java_file in java_dir.rglob(f"{class_name}.java"):
                return java_file
    
    return None


def parse_java_file(file_path: Path, base_path: Path, parsed_classes: Optional[Dict[str, PeripheralClass]] = None) -> Optional[PeripheralClass]:
    """Parse a Java peripheral file and extract method definitions.
    
    Args:
        file_path: Path to the Java file
        base_path: Base path of the CC-Tweaked repository
        parsed_classes: Dictionary of already-parsed classes to avoid re-parsing
    """
    if parsed_classes is None:
        parsed_classes = {}
    
    try:
        content = file_path.read_text(encoding='utf-8')
    except Exception as e:
        print(f"Error reading {file_path}: {e}", file=sys.stderr)
        return None
    
    # Extract class name and package
    class_match = re.search(r'public\s+(?:abstract\s+)?class\s+(\w+)(?:\s+extends\s+([\w.]+))?(?:\s+implements\s+([\w\s,<>]+))?', content)
    if not class_match:
        return None
    
    class_name = class_match.group(1)
    extends = class_match.group(2) if class_match.group(2) else ""
    
    # Extract package declaration
    package_match = re.search(r'^package\s+([\w.]+);', content, re.MULTILINE)
    current_package = package_match.group(1) if package_match else ""
    
    # Extract import statements to resolve parent class names
    imports = {}
    for import_match in re.finditer(r'^import\s+(?:static\s+)?([\w.]+)\.(\w+);', content, re.MULTILINE):
        full_package = import_match.group(1)
        imported_class = import_match.group(2)
        imports[imported_class] = f"{full_package}.{imported_class}"
    
    # Resolve parent class full name
    parent_full_names = []
    if extends:
        if '.' in extends:
            # Fully qualified name
            parent_full_names.append(extends)
        elif extends in imports:
            # Resolve via import
            parent_full_names.append(imports[extends])
        elif current_package:
            # Try same package
            parent_full_names.append(f"{current_package}.{extends}")
        else:
            # Just class name, try to find
            parent_full_names.append(extends)
    
    # Check if already parsed (by class name, assuming unique in context)
    if class_name in parsed_classes:
        return parsed_classes[class_name]
    
    # Extract type from getType() method or class name
    type_match = re.search(r'public\s+String\s+getType\(\)\s*\{\s*return\s+"([^"]+)"', content)
    type_name = type_match.group(1) if type_match else class_name.replace("Peripheral", "").lower()
    
    # Extract class-level Javadoc
    class_doc_match = re.search(r'/\*\*(.*?)\*/.*?public\s+class', content, re.DOTALL)
    class_doc = class_doc_match.group(1).strip() if class_doc_match else ""
    
    # Extract parent classes - get full qualified name and class name
    parent_classes = [parent_full_names[0].split('.')[-1]] if parent_full_names else []
    
    # Extract all methods
    methods = []
    
    # Find all @LuaFunction annotations and extract the method that follows
    # This pattern finds @LuaFunction, then captures the method including Javadoc before it
    lua_func_positions = []
    for match in re.finditer(r'@LuaFunction', content):
        lua_func_positions.append(match.start())
    
    # For each @LuaFunction, extract the method
    for func_pos in lua_func_positions:
        # Find the Javadoc before this annotation
        before = content[:func_pos]
        javadoc_match = None
        
        # Look backwards for Javadoc comment
        for match in re.finditer(r'/\*\*(.*?)\*/', before, re.DOTALL):
            # Check if it's close enough (within reasonable distance)
            if func_pos - match.end() < 50:  # Javadoc usually close to annotation
                javadoc_match = match
        
        # Extract method signature after @LuaFunction
        after = content[func_pos:]
        # Find method signature - look for public final/static return_type methodName(
        # More precise pattern: public (final)? (static)? ReturnType methodName(params) throws? {
        method_sig_pattern = r'public\s+(?:final\s+)?(?:static\s+)?(?:\w+(?:<[\w\s,<>]+>)?|\w+(?:\[\])?)\s+\w+\s*\([^)]*\)\s*(?:throws\s+\w+)?\s*\{'
        method_sig_match = re.search(method_sig_pattern, after, re.MULTILINE)
        if not method_sig_match:
            continue
        
        # Extract from Javadoc start (or @LuaFunction) to just before the method body {
        method_sig_end = func_pos + method_sig_match.end()
        if javadoc_match:
            method_block = content[javadoc_match.start():method_sig_end]
        else:
            method_block = content[func_pos:method_sig_end]
        
        method_signature = extract_method_signature(method_block)
        if method_signature:
            return_type, aliases, params_list, javadoc = method_signature
            
            # Extract param docs
            param_docs = extract_javadoc_params(javadoc)
            return_type_lua, return_doc = extract_javadoc_returns(javadoc)
            throws = extract_throws(javadoc)
            since = extract_since(javadoc)
            
            # Build main doc from javadoc (first paragraph)
            main_doc = javadoc.split('@')[0].strip()
            main_doc = re.sub(r'\s+', ' ', main_doc)
            
            # Convert return type
            if return_type_lua:
                lua_return = return_type_lua
            else:
                lua_return = java_type_to_lua(return_type)
            
            # Build MethodDef for each alias
            for alias in aliases:
                method_params = []
                for param_name, param_java_type, param_lua_type, param_optional in params_list:
                    param_doc = param_docs.get(param_name, "")
                    method_params.append(MethodParam(
                        name=param_name,
                        java_type=param_java_type,
                        lua_type=param_lua_type,
                        optional=param_optional,
                        doc=param_doc
                    ))
                
                method_def = MethodDef(
                    name=alias,
                    aliases=aliases,
                    params=method_params,
                    return_type=lua_return,
                    return_doc=return_doc,
                    doc=main_doc if alias == aliases[0] else "",  # Only doc on primary
                    throws=throws,
                    since=since,
                    source_file=str(file_path.relative_to(base_path))
                )
                methods.append(method_def)
    
    peripheral = PeripheralClass(
        name=class_name,
        full_name=str(file_path.relative_to(base_path)),
        type_name=type_name,
        parent_classes=parent_classes,
        methods=methods,
        class_doc=class_doc
    )
    
    # Store in parsed_classes to avoid cycles
    parsed_classes[class_name] = peripheral
    
    # Recursively parse parent classes and merge their methods
    for parent_full_name in parent_full_names:
        parent_class_name = parent_full_name.split('.')[-1]
        parent = None
        
        # Check if parent is in base classes
        if parent_class_name in BASE_CLASSES:
            base_file = base_path / BASE_CLASSES[parent_class_name]
            if base_file.exists():
                parent = parse_java_file(base_file, base_path, parsed_classes)
        else:
            # Try to find parent class file
            parent_file = find_java_file_for_class(parent_class_name, base_path, parent_full_name)
            if parent_file:
                parent = parse_java_file(parent_file, base_path, parsed_classes)
        
        if parent:
            # Merge methods from parent (avoid duplicates)
            existing_method_names = {m.name for m in peripheral.methods}
            added_count = 0
            for parent_method in parent.methods:
                if parent_method.name not in existing_method_names:
                    peripheral.methods.append(parent_method)
                    existing_method_names.add(parent_method.name)
                    added_count += 1
                    print(f"  Merged method '{parent_method.name}' from {parent_method.source_file}")
            if added_count > 0:
                print(f"  Total: Merged {added_count} methods from parent {parent_class_name}")
    
    return peripheral


def generate_lua_file(peripheral: PeripheralClass, output_dir: Path):
    """Generate a Lua LSP type definition file for a peripheral."""
    output_file = output_dir / f"{peripheral.type_name.capitalize()}.lua"
    
    # Deduplicate methods by name (keep first occurrence)
    seen_names = set()
    unique_methods = []
    for method in peripheral.methods:
        if method.name not in seen_names:
            unique_methods.append(method)
            seen_names.add(method.name)
    
    # Sort methods by name
    unique_methods.sort(key=lambda m: m.name)
    
    lines = ["---@meta", ""]
    
    # Add class-level documentation
    if peripheral.class_doc:
        # Extract first paragraph
        first_para = peripheral.class_doc.split('\n\n')[0].strip()
        first_para = re.sub(r'\s+', ' ', first_para)
        # Remove HTML tags and formatting
        first_para = re.sub(r'<[^>]+>', '', first_para)
        lines.append(f"---{first_para}")
        lines.append("")
    
    lines.append("------")
    lines.append(f'---[Official Documentation](https://tweaked.cc/peripheral/{peripheral.type_name}.html)')
    
    # Determine parent class
    parent_class = None
    if "TermMethods" in peripheral.parent_classes:
        parent_class = "ccTweaked.term.Redirect"
    # Add more parent class mappings as needed
    
    if parent_class:
        lines.append(f"---@class ccTweaked.peripheral.{peripheral.type_name.capitalize()}: {parent_class}")
    else:
        lines.append(f"---@class ccTweaked.peripheral.{peripheral.type_name.capitalize()}")
    
    lines.append(f"{peripheral.type_name.capitalize()} = {{}}")
    lines.append("")
    
    # Generate method definitions
    for method in unique_methods:
        # Add source file comment for debugging (can be removed later if not needed)
        if method.source_file:
            lines.append(f"---@source {method.source_file}")
        
        if method.doc:
            # Clean up doc
            doc = method.doc
            doc = re.sub(r'\s+', ' ', doc)
            doc = re.sub(r'<[^>]+>', '', doc)
            lines.append(f"---{doc}")
            lines.append("")
        
        # Add parameter documentation
        for param in method.params:
            optional = "?" if param.optional else ""
            param_doc = param.doc if param.doc else f"The {param.name}"
            lines.append(f"---@param {param.name}{optional} {param.lua_type} {param_doc}")
        
        # Add return documentation
        if method.return_type and method.return_type != "":
            if method.return_doc:
                # Parse multiple returns
                if ',' in method.return_type:
                    return_types = method.return_type.split(',')
                    for i, ret_type in enumerate(return_types):
                        lines.append(f"---@return {ret_type} {method.return_doc}")
                else:
                    lines.append(f"---@return {method.return_type} {method.return_doc}")
            else:
                if ',' in method.return_type:
                    return_types = method.return_type.split(',')
                    for i, ret_type in enumerate(return_types):
                        lines.append(f"---@return {ret_type}")
                else:
                    lines.append(f"---@return {method.return_type}")
        
        # Add throws documentation
        if method.throws:
            for throw in method.throws:
                lines.append(f"---@throws {throw}")
        
        # Add since
        if method.since:
            lines.append(f"---@since {method.since}")
        
        lines.append("------")
        lines.append(f'---[Official Documentation](https://tweaked.cc/peripheral/{peripheral.type_name}.html#v:{method.name})')
        
        # Generate function signature
        param_list = ", ".join(f"{p.name}" for p in method.params)
        lines.append(f"function {peripheral.type_name.capitalize()}.{method.name}({param_list}) end")
        lines.append("")
    
    output_file.write_text("\n".join(lines), encoding='utf-8')
    print(f"Generated: {output_file}")


def main():
    """Main entry point."""
    if len(sys.argv) < 3:
        print("Usage: extract_peripheral_methods.py <cc-tweaked-path> <output-dir>", file=sys.stderr)
        sys.exit(1)
    
    cc_tweaked_path = Path(sys.argv[1])
    output_dir = Path(sys.argv[2])
    
    if not cc_tweaked_path.exists():
        print(f"Error: CC-Tweaked path does not exist: {cc_tweaked_path}", file=sys.stderr)
        sys.exit(1)
    
    output_dir.mkdir(parents=True, exist_ok=True)
    
    # Find all peripheral Java files
    common_java_dir = cc_tweaked_path / "projects/common/src/main/java"
    peripheral_files = list(common_java_dir.rglob("*Peripheral.java"))
    
    print(f"Found {len(peripheral_files)} peripheral files")
    
    # Parse all peripherals (with shared cache to avoid re-parsing)
    parsed_classes: Dict[str, PeripheralClass] = {}
    
    # Pre-parse base classes to populate cache
    for base_name, base_path in BASE_CLASSES.items():
        base_file = cc_tweaked_path / base_path
        if base_file.exists():
            parse_java_file(base_file, cc_tweaked_path, parsed_classes)
    
    peripherals = {}
    for java_file in peripheral_files:
        peripheral = parse_java_file(java_file, cc_tweaked_path, parsed_classes)
        if peripheral:
            peripherals[peripheral.type_name] = peripheral
            # Show source files for each method
            method_sources = {}
            for method in peripheral.methods:
                source = method.source_file
                if source not in method_sources:
                    method_sources[source] = []
                method_sources[source].append(method.name)
            print(f"Parsed: {peripheral.name} ({peripheral.type_name}) - {len(peripheral.methods)} methods")
            for source_file, method_names in sorted(method_sources.items()):
                print(f"  Methods from {source_file}: {', '.join(sorted(method_names))}")
    
    # Generate Lua files
    for peripheral in peripherals.values():
        generate_lua_file(peripheral, output_dir)
    
    print(f"\nGenerated {len(peripherals)} Lua type definition files in {output_dir}")


if __name__ == "__main__":
    main()

