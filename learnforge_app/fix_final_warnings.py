import re
import os

def fix_errors():
    error_file = 'remaining_errors_v4.txt'
    if not os.path.exists(error_file):
        print(f"Error file {error_file} not found.")
        return

    # specific map of file -> lines with errors
    # We will read the file and parse it.
    # Format: 
    # 5: warning - ... - lib\path\to\file.dart:line:col - error_code
    
    file_errors = {}
    
    with open(error_file, 'r', encoding='utf-8') as f:
        for line in f:
            parts = line.split(' - ')
            if len(parts) < 3:
                continue
            
            # parts[0]: "5: warning" (or just "   info")
            # parts[1]: description
            # parts[2]: "lib\...\file.dart:line:col"
            # parts[3]: error_code (maybe)

            # Let's parse strictly from the end for error code and path
            last_part = parts[-1].strip()
            path_part = parts[-2].strip()
            
            # Sometimes parts might be split differently if description has " - ".
            # Let's assume the last part is error code.
            error_code = last_part
            
            # The path part should contain the file path and line info
            # "lib\features\...\file.dart:50:49"
            
            if ':' not in path_part:
                continue
                
            path_components = path_part.split(':')
            if len(path_components) < 3:
                continue
                
            line_num = int(path_components[-2])
            file_path = ':'.join(path_components[:-2]) # Handle drive letter if absolute, but here likely relative
            
            # Fix path separators
            file_path = file_path.replace('\\', '/')
            if not os.path.exists(file_path):
                # Try relative to current dir
                if not os.path.exists(file_path):
                    continue

            if file_path not in file_errors:
                file_errors[file_path] = []
            
            file_errors[file_path].append({
                'line': line_num,
                'code': error_code,
                'original': line.strip()
            })

    # Process each file
    for file_path, errors in file_errors.items():
        print(f"Processing {file_path}...")
        try:
            with open(file_path, 'r', encoding='utf-8') as f:
                lines = f.readlines()
        except Exception as e:
            print(f"Could not read {file_path}: {e}")
            continue

        # Sort errors by line number descending
        errors.sort(key=lambda x: x['line'], reverse=True)
        
        modified = False
        
        for error in errors:
            line_idx = error['line'] - 1
            if line_idx < 0 or line_idx >= len(lines):
                continue
            
            original_line = lines[line_idx]
            current_line = original_line
            code = error['code']
            
            if code == 'dead_null_aware_expression':
                # Pattern: something ?? fallback
                # Remove " ?? fallback"
                # Regex matches " ?? " followed by anything NOT comma, semicolon, paren
                # We want to be careful not to match too much.
                # Common case: "AppColors.neonGreen ?? Colors.green," -> match " ?? Colors.green"
                
                # Regex logic:
                # 1. \s*\?\?\s* : match " ?? "
                # 2. [^,;)]+    : match characters that are NOT separators
                
                new_line = re.sub(r'\s*\?\?\s*[^,;)]+', '', current_line)
                if new_line != current_line:
                    print(f"  Fixed dead_null_aware at line {error['line']}")
                    current_line = new_line
                    modified = True

            elif code == 'avoid_print':
                # Comment out print
                if 'print(' in current_line and '//' not in current_line.split('print(')[0]:
                    new_line = current_line.replace('print(', '// print(')
                    print(f"  Fixed avoid_print at line {error['line']}")
                    current_line = new_line
                    modified = True

            elif code == 'deprecated_member_use':
                # Specifically withOpacity
                if 'withOpacity(' in current_line:
                    # Capture value inside withOpacity(...)
                    match = re.search(r'\.withOpacity\(([^)]+)\)', current_line)
                    if match:
                        val = match.group(1)
                        new_line = current_line.replace(f'.withOpacity({val})', f'.withValues(alpha: {val})')
                        print(f"  Fixed withOpacity at line {error['line']}")
                        current_line = new_line
                        modified = True

            elif code == 'unused_local_variable' or code == 'unused_field':
                 # Comment out definition if it's a simple line
                 # e.g. "final x = 1;" -> "// final x = 1;"
                 if '//' not in current_line:
                     new_line = '// ' + current_line
                     print(f"  Commented unused variable at line {error['line']}")
                     current_line = new_line
                     modified = True
            
            lines[line_idx] = current_line

        if modified:
            with open(file_path, 'w', encoding='utf-8') as f:
                f.writelines(lines)
            print(f"Saved changes to {file_path}")

if __name__ == '__main__':
    fix_errors()
