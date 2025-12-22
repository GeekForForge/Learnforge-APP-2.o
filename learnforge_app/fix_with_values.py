import re
import os
from pathlib import Path

base_dir = r'c:\Coding\APP_DEV\Learnforge-APP-2.o\learnforge_app\lib'

def fix_with_values(content):
    """
    Fix incorrect .withValues(alpha: value value) to .withValues(alpha: value)
    """
    # Pattern to match .withValues(alpha: value value) - the incorrect format
    pattern = r'\.withValues\(alpha:\s*([0-9.]+)\s+\1\)'
    replacement = r'.withValues(alpha: \1)'
    
    new_content = re.sub(pattern, replacement, content)
    return new_content

def process_dart_files(directory):
    """Process all .dart files in the directory recursively"""
    total_files = 0
    total_fixes = 0
    
    for root, dirs, files in os.walk(directory):
        for file in files:
            if file.endswith('.dart'):
                file_path = os.path.join(root, file)
                try:
                    with open(file_path, 'r', encoding='utf-8') as f:
                        content = f.read()
                    
                    # Count occurrences before fix
                    count_before = len(re.findall(r'\.withValues\(alpha:\s*[0-9.]+\s+[0-9.]+\)', content))
                    
                    if count_before > 0:
                        new_content = fix_with_values(content)
                        
                        with open(file_path, 'w', encoding='utf-8') as f:
                            f.write(new_content)
                        
                        total_files += 1
                        total_fixes += count_before
                        rel_path = os.path.relpath(file_path, base_dir)
                        print(f"  {rel_path}: {count_before} fixes")
                        
                except Exception as e:
                    print(f"Error processing {file_path}: {e}")
    
    return total_files, total_fixes

def main():
    print("Fixing malformed withValues() calls...\n")
    
    total_files, total_fixes = process_dart_files(base_dir)
    
    print(f"\nCompleted!")
    print(f"Files fixed: {total_files}")
    print(f"Total fixes: {total_fixes}")

if __name__ == '__main__':
    main()
