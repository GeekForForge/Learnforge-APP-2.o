import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/theme/app_colors.dart';
import '../models/message_model.dart';

class MessageBubble extends StatelessWidget {
  final MessageModel message;

  const MessageBubble({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: message.isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        margin: EdgeInsets.only(
          left: message.isUser ? 32 : 0,
          right: message.isUser ? 0 : 32,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: message.isUser
              ? AppColors
                    .neonPurple // Fixed: primary → neonPurple
              : AppColors.dark700, // Fixed: darkBgSecondary → dark700
          borderRadius: BorderRadius.circular(16),
          border: !message.isUser
              ? Border.all(
                  color: AppColors.neonCyan.withValues(
                    alpha: 0.3,
                  ), // Fixed: accent → neonCyan
                  width: 1,
                )
              : null,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!message.isUser)
              Text(
                message.senderName,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: AppColors.neonCyan, // Fixed: accent → neonCyan
                ),
              ),
            if (!message.isUser) const SizedBox(height: 4),
            Text(
              message.content,
              style: TextStyle(
                fontSize: 14,
                color: message.isUser
                    ? AppColors.white
                    : AppColors.white, // Fixed: textLight → white
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '${message.timestamp.hour}:${message.timestamp.minute.toString().padLeft(2, '0')}',
              style: TextStyle(
                fontSize: 10,
                color: message.isUser
                    ? AppColors.white.withValues(alpha: 0.6)
                    : AppColors.grey400, // Fixed: textMuted → grey400
              ),
            ),
          ],
        ),
      ),
    ).animate().slideY(duration: 300.ms, curve: Curves.easeOut).fadeIn();
  }
}
