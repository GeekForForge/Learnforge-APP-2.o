import re
import os
from pathlib import Path

# Base directory
base_dir = r'c:\Coding\APP_DEV\Learnforge-APP-2.o\learnforge_app\lib'

def replace_with_opacity(content):
    """
    Replace .withOpacity(value) with .withValues(alpha: value)
    This preserves the exact same visual appearance
    """
    # Pattern to match .withOpacity(numeric_value)
    pattern = r'\.withOpacity\(([0-9.]+)\)'
    replacement = r'.withValues(alpha:\1 \1)'
    
    new_content = re.sub(pattern, replacement, content)
    return new_content

def process_dart_files(directory):
    """Process all .dart files in the directory recursively"""
    total_files = 0
    total_replacements = 0
    
    for root, dirs, files in os.walk(directory):
        for file in files:
            if file.endswith('.dart'):
                file_path = os.path.join(root, file)
                try:
                    with open(file_path, 'r', encoding='utf-8') as f:
                        content = f.read()
                    
                    # Count occurrences before replacement
                    count_before = len(re.findall(r'\.withOpacity\(', content))
                    
                    if count_before > 0:
                        new_content = replace_with_opacity(content)
                        
                        with open(file_path, 'w', encoding='utf-8') as f:
                            f.write(new_content)
                        
                        total_files += 1
                        total_replacements += count_before
                        rel_path = os.path.relpath(file_path, base_dir)
                        print(f"  {rel_path}: {count_before} replacements")
                        
                except Exception as e:
                    print(f"Error processing {file_path}: {e}")
    
    return total_files, total_replacements

def main():
    print("Starting withOpacity -> withValues replacement...")
    print("This preserves the exact same visual appearance\n")
    
    total_files, total_replacements = process_dart_files(base_dir)
    
    print(f"\nCompleted!")
    print(f"Files modified: {total_files}")
    print(f"Total replacements: {total_replacements}")

if __name__ == '__main__':
    main()
