import re
import os

base_dir = r'c:\Coding\APP_DEV\Learnforge-APP-2.o\learnforge_app\lib'

def fix_deprecations(file_path):
    """Fix other deprecated method calls"""
    try:
        with open(file_path, 'r', encoding='utf-8') as f:
            content = f.read()
        
        original_content = content
        changes = []
        
        # Fix ColorScheme deprecations
        if 'background:' in content:
            content = content.replace('background:', 'surface:')
            changes.append("background -> surface")
        
        if 'onBackground:' in content:
            content = content.replace('onBackground:', 'onSurface:')
            changes.append("onBackground -> onSurface")
        
        # Fix VideoPlayerController.network -> VideoPlayerController.networkUrl
        if 'VideoPlayerController.network(' in content:
            content = re.sub(
                r'VideoPlayerController\.network\(',
                'VideoPlayerController.networkUrl(Uri.parse(',
                content
            )
            # Add closing parenthesis for Uri.parse
            content = re.sub(
                r'VideoPlayerController\.networkUrl\(Uri\.parse\(([^)]+)\)\)',
                r'VideoPlayerController.networkUrl(Uri.parse(\1))',
                content
            )
            changes.append("VideoPlayerController.network -> networkUrl")
        
        # Fix activeColor -> activeThumbColor (Switch widget)
        if 'activeColor:' in content and 'Switch(' in content:
            content = content.replace('activeColor:', 'activeThumbColor:')
            changes.append("activeColor -> activeThumbColor")
        
        # Fix dialogBackgroundColor -> use DialogThemeData
        if 'dialogBackgroundColor:' in content:
            content = content.replace('dialogBackgroundColor:', 'backgroundColor:')
            changes.append("dialogBackgroundColor -> backgroundColor")
        
        # Fix textScaleFactor -> textScaler
        if 'textScaleFactor:' in content:
            # This is more complex, need to use TextScaler.linear()
            content = re.sub(
                r'textScaleFactor:\s*MediaQuery\.of\([^)]+\)\.textScaleFactor\.clamp\(([^,]+),\s*([^)]+)\)',
                r'textScaler: TextScaler.linear(MediaQuery.of(context).textScaler.scale(1.0).clamp(\1, \2))',
                content
            )
            changes.append("textScaleFactor -> textScaler")
        
        if content != original_content:
            with open(file_path, 'w', encoding='utf-8') as f:
                f.write(content)
            return True, changes
        
        return False, []
    except Exception as e:
        print(f"Error processing {file_path}: {e}")
        return False, []

def main():
    print("Fixing other deprecations...\n")
    total_files = 0
    
    for root, dirs, files in os.walk(base_dir):
        for file in files:
            if file.endswith('.dart'):
                file_path = os.path.join(root, file)
                modified, changes = fix_deprecations(file_path)
                
                if modified:
                    total_files += 1
                    rel_path = os.path.relpath(file_path, base_dir)
                    print(f"  {rel_path}: {', '.join(changes)}")
    
    print(f"\nFiles modified: {total_files}")

if __name__ == '__main__':
    main()
