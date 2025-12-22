import re
import os
from pathlib import Path

# Base directory
base_dir = r'c:\Coding\APP_DEV\Learnforge-APP-2.o\learnforge_app\lib'

# Unused imports to remove (exact lines from error report)
unused_imports = {
    r"import 'package:flutter_animate/flutter_animate.dart';": [
        'features/courses/screens/courses_screen.dart',
        'features/courses/widgets/course_card_horizontal.dart',
        'features/courses/widgets/youtube_playlist_card.dart',
        'features/dashboard/screens/main_layout.dart',
    ],
    r"import '../../features/arena/models/leaderboard_model.dart';": [
        'core/constants/dummy_data.dart',
    ],
    r"import '../widgets/leaderboard_list.dart';": [
        'features/arena/screens/arena_screen.dart',
    ],
    r"import 'package:intl/intl.dart';": [
        'features/arena/widgets/challenge_card.dart',
    ],
    r"import '../models/leaderboard_model.dart';": [
        'features/arena/widgets/leaderboard_entry.dart',
    ],
    r"import 'package:flutter_riverpod/flutter_riverpod.dart';": [
        'features/auth/providers/auth_provider.dart',
        'features/chat/providers/chat_provider.dart',
        'features/todo/providers/todo_provider.dart',
    ],
    r"import '../../../core/widgets/glass_morphic_card.dart';": [
        'features/chat/screens/chat_screen.dart',
        'features/profile/widgets/avatar_picker_modal.dart',
    ],
    r"import 'package:learnforge_app/features/courses/models/course_model.dart';": [
        'features/courses/models/course_model.dart',
        'features/courses/screens/course_detail_screen.dart',
    ],
    r"import 'package:learnforge_app/core/utils/neon_animations.dart';": [
        'features/courses/screens/course_detail_screen.dart',
    ],
    r"import 'package:learnforge_app/features/courses/widgets/youtube_playlist_card.dart';": [
        'features/courses/screens/course_detail_screen.dart',
    ],
    r"import 'package:go_router/go_router.dart';": [
        'features/notifications/screens/notification_screen.dart',
    ],
    r"import 'package:flutter/foundation.dart';": [
        'features/profile/providers/profile_provider.dart',
    ],
    r"import '../../../core/widgets/gradient_button.dart';": [
        'features/todo/screens/todo_screen.dart',
    ],
    r"import '../../../core/widgets/progress_indicator_circular.dart';": [
        'features/todo/screens/todo_screen.dart',
    ],
}

def remove_unused_import(file_path, import_line):
    """Remove an unused import from a file"""
    try:
        with open(file_path, 'r', encoding='utf-8') as f:
            lines = f.readlines()
        
        # Find and remove the import line
        new_lines = []
        removed = False
        for line in lines:
            if import_line.strip() not in line:
                new_lines.append(line)
            else:
                removed = True
                print(f"  Removed: {import_line.strip()}")
        
        if removed:
            with open(file_path, 'w', encoding='utf-8') as f:
                f.writelines(new_lines)
            return True
        return False
    except Exception as e:
        print(f"  Error processing {file_path}: {e}")
        return False

def main():
    print("Starting unused import removal...")
    total_removed = 0
    
    for import_line, file_list in unused_imports.items():
        for file_rel_path in file_list:
            file_path = os.path.join(base_dir, file_rel_path)
            if os.path.exists(file_path):
                print(f"Processing: {file_rel_path}")
                if remove_unused_import(file_path, import_line):
                    total_removed += 1
            else:
                print(f"  File not found: {file_path}")
    
    print(f"\nTotal imports removed: {total_removed}")

if __name__ == '__main__':
    main()
