import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/text_styles.dart';
import '../../../core/widgets/glass_morphic_card.dart';

class AvatarPickerModal extends StatefulWidget {
  final String currentAvatar;
  final Function(String) onAvatarSelected;

  const AvatarPickerModal({
    Key? key,
    required this.currentAvatar,
    required this.onAvatarSelected,
  }) : super(key: key);

  @override
  State<AvatarPickerModal> createState() => _AvatarPickerModalState();
}

class _AvatarPickerModalState extends State<AvatarPickerModal> {
  String? selectedAvatar;
  String selectedCategory = 'All'; // All, Boys, Girls

  // Avatar data structure - Mix of local assets and emoji placeholders
  static const List<Map<String, String>> avatarOptions = [
    // Boys avatars
    {'path': 'assets/images/avatar_default.png', 'category': 'Boys', 'name': 'Boy 1', 'type': 'asset'},
    {'path': '👦', 'category': 'Boys', 'name': 'Boy 2', 'type': 'emoji'},
    {'path': '🧒', 'category': 'Boys', 'name': 'Boy 3', 'type': 'emoji'},
    {'path': '👨', 'category': 'Boys', 'name': 'Boy 4', 'type': 'emoji'},
    {'path': '🧑', 'category': 'Boys', 'name': 'Boy 5', 'type': 'emoji'},
    {'path': '👨‍🎓', 'category': 'Boys', 'name': 'Boy 6', 'type': 'emoji'},
    {'path': '👨‍💻', 'category': 'Boys', 'name': 'Boy 7', 'type': 'emoji'},
    {'path': '🧑‍💻', 'category': 'Boys', 'name': 'Boy 8', 'type': 'emoji'},
    {'path': '👨‍🔬', 'category': 'Boys', 'name': 'Boy 9', 'type': 'emoji'},
    {'path': '🧑‍🎓', 'category': 'Boys', 'name': 'Boy 10', 'type': 'emoji'},
    
    // Girls avatars
    {'path': '👧', 'category': 'Girls', 'name': 'Girl 1', 'type': 'emoji'},
    {'path': '👩', 'category': 'Girls', 'name': 'Girl 2', 'type': 'emoji'},
    {'path': '🧒', 'category': 'Girls', 'name': 'Girl 3', 'type': 'emoji'},
    {'path': '👩‍🎓', 'category': 'Girls', 'name': 'Girl 4', 'type': 'emoji'},
    {'path': '👩‍💻', 'category': 'Girls', 'name': 'Girl 5', 'type': 'emoji'},
    {'path': '🧑‍💻', 'category': 'Girls', 'name': 'Girl 6', 'type': 'emoji'},
    {'path': '👩‍🔬', 'category': 'Girls', 'name': 'Girl 7', 'type': 'emoji'},
    {'path': '🧑‍🔬', 'category': 'Girls', 'name': 'Girl 8', 'type': 'emoji'},
    {'path': '👩‍🏫', 'category': 'Girls', 'name': 'Girl 9', 'type': 'emoji'},
    {'path': '🧑‍🏫', 'category': 'Girls', 'name': 'Girl 10', 'type': 'emoji'},
  ];

  List<Map<String, String>> get filteredAvatars {
    if (selectedCategory == 'All') {
      return avatarOptions;
    }
    return avatarOptions.where((avatar) => avatar['category'] == selectedCategory).toList();
  }

  @override
  void initState() {
    super.initState();
    selectedAvatar = widget.currentAvatar;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.75,
      decoration: BoxDecoration(
        color: AppColors.dark900,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: Column(
        children: [
          // Handle bar
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.grey400,
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Header
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Choose Avatar',
                      style: TextStyles.orbitron(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: AppColors.white,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: AppColors.grey400),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                // Category tabs
                Row(
                  children: ['All', 'Boys', 'Girls'].map((category) {
                    final isSelected = selectedCategory == category;
                    return Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedCategory = category;
                          });
                        },
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppColors.neonPurple
                                : AppColors.dark700,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: isSelected
                                  ? AppColors.neonPurple
                                  : AppColors.dark600,
                            ),
                          ),
                          child: Text(
                            category,
                            textAlign: TextAlign.center,
                            style: TextStyles.inter(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: isSelected
                                  ? AppColors.white
                                  : AppColors.grey400,
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),

          // Avatar Grid
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 1,
                ),
                itemCount: filteredAvatars.length,
                itemBuilder: (context, index) {
                  final avatar = filteredAvatars[index];
                  final avatarPath = avatar['path']!;
                  final isSelected = selectedAvatar == avatarPath;

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedAvatar = avatarPath;
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isSelected
                              ? AppColors.neonPurple
                              : AppColors.dark600,
                          width: isSelected ? 3 : 2,
                        ),
                        boxShadow: isSelected
                            ? [
                                BoxShadow(
                                  color: AppColors.neonPurple.withOpacity(0.5),
                                  blurRadius: 15,
                                  spreadRadius: 2,
                                ),
                              ]
                            : null,
                      ),
                      child: ClipOval(
                        child: avatar['type'] == 'asset'
                            ? Image.asset(
                                avatarPath,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    color: AppColors.dark700,
                                    child: const Icon(
                                      Icons.person,
                                      color: AppColors.grey400,
                                    ),
                                  );
                                },
                              )
                            : Container(
                                color: AppColors.dark700,
                                child: Center(
                                  child: Text(
                                    avatarPath,
                                    style: const TextStyle(fontSize: 40),
                                  ),
                                ),
                              ),
                      ),
                    ),
                  )
                      .animate()
                      .fadeIn(delay: (index * 30).ms)
                      .scale(delay: (index * 30).ms);
                },
              ),
            ),
          ),

          // Confirm Button
          Padding(
            padding: const EdgeInsets.all(20),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: selectedAvatar != null
                    ? () {
                        widget.onAvatarSelected(selectedAvatar!);
                        Navigator.pop(context);
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.neonPurple,
                  foregroundColor: AppColors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                  shadowColor: AppColors.neonPurple.withOpacity(0.5),
                ),
                child: Text(
                  'Confirm Selection',
                  style: TextStyles.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
