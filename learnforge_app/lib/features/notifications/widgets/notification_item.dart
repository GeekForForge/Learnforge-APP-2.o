import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:learnforge_app/core/theme/app_colors.dart';

enum NotificationType {
  courseUpdate,
  challenge,
  achievement,
  system,
  message,
  reminder,
}

class NotificationItem extends StatefulWidget {
  final String title;
  final String message;
  final String time;
  final NotificationType type;
  final bool isRead;
  final VoidCallback? onTap;
  final VoidCallback? onDismiss;

  const NotificationItem({
    super.key,
    required this.title,
    required this.message,
    required this.time,
    required this.type,
    this.isRead = false,
    this.onTap,
    this.onDismiss,
  });

  @override
  State<NotificationItem> createState() => _NotificationItemState();
}

class _NotificationItemState extends State<NotificationItem> {
  bool _isDismissing = false;

  void _handleDismiss() {
    setState(() {
      _isDismissing = true;
    });
    Future.delayed(300.ms, () {
      widget.onDismiss?.call();
    });
  }

  IconData _getIconForType(NotificationType type) {
    switch (type) {
      case NotificationType.courseUpdate:
        return Icons.school_rounded;
      case NotificationType.challenge:
        return Icons.emoji_events_rounded;
      case NotificationType.achievement:
        return Icons.star_rounded;
      case NotificationType.system:
        return Icons.info_rounded;
      case NotificationType.message:
        return Icons.chat_rounded;
      case NotificationType.reminder:
        return Icons.notifications_active_rounded;
    }
  }

  Color _getColorForType(NotificationType type) {
    switch (type) {
      case NotificationType.courseUpdate:
        return AppColors.neonBlue;
      case NotificationType.challenge:
        return AppColors.neonPurple;
      case NotificationType.achievement:
        return AppColors.neonPink;
      case NotificationType.system:
        return AppColors.neonCyan;
      case NotificationType.message:
        return AppColors.neonGreen;
      case NotificationType.reminder:
        return AppColors.neonYellow;
    }
  }

  Gradient _getGradientForType(NotificationType type) {
    final color = _getColorForType(type);
    return LinearGradient(
      colors: [color.withValues(alpha: 0.8), color.withValues(alpha: 0.4)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: _isDismissing ? 0 : 1,
      duration: 300.ms,
      child: AnimatedScale(
        scale: _isDismissing ? 0.8 : 1,
        duration: 300.ms,
        child: Dismissible(
          key: Key(widget.title + widget.time),
          direction: DismissDirection.endToStart,
        background: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.neonPink.withValues(alpha: 0.3),
                  AppColors.neonPurple.withValues(alpha: 0.1),
                ],
                begin: Alignment.centerRight,
                end: Alignment.centerLeft,
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.only(right: 20),
                child: Icon(
                  Icons.delete_rounded,
                  color: AppColors.neonPink,
                  size: 30,
                ),
              ),
            ),
          ),
          onDismissed: (direction) => _handleDismiss(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Stack(
              children: [
                // Main notification card
                Container(
                  decoration: BoxDecoration(
                    gradient: widget.isRead
                        ? LinearGradient(
                            colors: [
                              AppColors.dark700.withValues(alpha: 0.6),
                              AppColors.dark600.withValues(alpha: 0.4),
                            ],
                          )
                        : _getGradientForType(widget.type),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      if (!widget.isRead)
                        BoxShadow(
                          color: _getColorForType(widget.type).withValues(alpha: 0.3),
                          blurRadius: 15,
                          spreadRadius: 2,
                          offset: const Offset(0, 4),
                        ),
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.2),
                        blurRadius: 10,
                        spreadRadius: 1,
                        offset: const Offset(0, 2),
                      ),
                    ],
                    border: widget.isRead
                        ? Border.all(color: AppColors.dark600, width: 1)
                        : Border.all(
                            color: _getColorForType(
                              widget.type,
                            ).withValues(alpha: 0.3),
                            width: 1,
                          ),
                  ),
                  child: Material(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(20),
                    child: InkWell(
                      onTap: widget.onTap,
                      borderRadius: BorderRadius.circular(20),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Icon with glow effect
                            Stack(
                              children: [
                                if (!widget.isRead)
                                  Container(
                                    width: 50,
                                    height: 50,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: _getColorForType(
                                        widget.type,
                                      ).withValues(alpha: 0.2),
                                      boxShadow: [
                                        BoxShadow(
                                          color: _getColorForType(
                                            widget.type,
                                          ).withValues(alpha: 0.4),
                                          blurRadius: 10,
                                          spreadRadius: 2,
                                        ),
                                      ],
                                    ),
                                  ),
                                Container(
                                  width: 50,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    gradient: LinearGradient(
                                      colors: [
                                        _getColorForType(widget.type),
                                        _getColorForType(
                                          widget.type,
                                        ).withValues(alpha: 0.7),
                                      ],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: _getColorForType(
                                          widget.type,
                                        ).withValues(alpha: 0.3),
                                        blurRadius: 8,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: Icon(
                                    _getIconForType(widget.type),
                                    color: AppColors.white,
                                    size: 24,
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(width: 16),

                            // Content
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          widget.title,
                                          style: TextStyle(
                                            color: widget.isRead
                                                ? AppColors.white.withValues(
                                                    alpha: 0.7,
                                                  )
                                                : AppColors.white,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                            fontFamily: 'Inter',
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      if (!widget.isRead)
                                        Container(
                                              width: 8,
                                              height: 8,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: _getColorForType(
                                                  widget.type,
                                                ),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: _getColorForType(
                                                      widget.type,
                                                    ),
                                                    blurRadius: 8,
                                                  ),
                                                ],
                                              ),
                                            )
                                            .animate(
                                              onPlay: (controller) =>
                                                  controller.repeat(),
                                            )
                                            .scale(
                                              duration: 1500.ms,
                                              begin: const Offset(1, 1),
                                              end: const Offset(1.3, 1.3),
                                              curve: Curves.easeInOut,
                                            ),
                                    ],
                                  ),

                                  const SizedBox(height: 4),

                                  Text(
                                    widget.message,
                                    style: TextStyle(
                                      color: AppColors.white.withValues(alpha: 0.8),
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                      fontFamily: 'Inter',
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),

                                  const SizedBox(height: 8),

                                  Text(
                                    widget.time,
                                    style: TextStyle(
                                      color: AppColors.white.withValues(alpha: 0.6),
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      fontFamily: 'Inter',
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ).animate().slideX(
                  begin: 0.5,
                  end: 0,
                  duration: 400.ms,
                  curve: Curves.easeOut,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
