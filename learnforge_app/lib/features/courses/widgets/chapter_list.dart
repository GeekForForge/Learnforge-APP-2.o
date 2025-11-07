import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/glass_morphic_card.dart';
import '../models/course_model.dart';

class ChapterList extends StatelessWidget {
  final List<ChapterModel> chapters;

  const ChapterList({Key? key, required this.chapters}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: chapters.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final chapter = chapters[index];
        return GlassMorphicCard(
          onTap: () {
            // TODO: Navigate to video player
          },
          child: Row(
            children: [
              // Thumbnail or Icon
              Container(
                height: 80,
                width: 80,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: AppColors.dark700, // Fixed: darkBgSecondary → dark700
                ),
                child: Icon(
                  chapter.isCompleted ? Icons.check_circle : Icons.play_circle,
                  color: chapter.isCompleted
                      ? AppColors
                            .success // This should exist in your AppColors
                      : AppColors
                            .primary, // This should exist in your AppColors
                  size: 32,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      chapter.title,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: AppColors.white, // Fixed: textLight → white
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${chapter.durationMinutes} mins',
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.grey400, // Fixed: textMuted → grey400
                      ),
                    ),
                    const SizedBox(height: 8),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: chapter.videoProgress / 100,
                        minHeight: 4,
                        backgroundColor: AppColors
                            .dark700, // Fixed: darkBgSecondary → dark700
                        valueColor: const AlwaysStoppedAnimation<Color>(
                          AppColors.neonCyan, // Fixed: accent → neonCyan
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
