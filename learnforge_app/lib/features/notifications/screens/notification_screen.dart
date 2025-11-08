import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:learnforge_app/core/theme/app_colors.dart';
import '../widgets/notification_item.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final List<Map<String, dynamic>> _notifications = [
    {
      'title': 'New Challenge Available!',
      'message':
          'Test your skills in the weekly coding challenge and win exclusive rewards',
      'time': '5 min ago',
      'type': NotificationType.challenge,
      'isRead': false,
    },
    {
      'title': 'Course Updated',
      'message':
          'Advanced Flutter Patterns course has been updated with new content',
      'time': '1 hour ago',
      'type': NotificationType.courseUpdate,
      'isRead': false,
    },
    {
      'title': 'Achievement Unlocked!',
      'message':
          'You earned the "Code Master" badge for completing 50 challenges',
      'time': '3 hours ago',
      'type': NotificationType.achievement,
      'isRead': true,
    },
    {
      'title': 'Study Reminder',
      'message': 'Don\'t forget to complete your daily learning streak',
      'time': '5 hours ago',
      'type': NotificationType.reminder,
      'isRead': true,
    },
    {
      'title': 'New Message',
      'message': 'John sent you a message about the group project',
      'time': '1 day ago',
      'type': NotificationType.message,
      'isRead': true,
    },
    {
      'title': 'System Maintenance',
      'message':
          'Scheduled maintenance this weekend. App may be unavailable for 2 hours',
      'time': '2 days ago',
      'type': NotificationType.system,
      'isRead': true,
    },
  ];

  bool _showUnreadOnly = false;

  List<Map<String, dynamic>> get _filteredNotifications {
    if (_showUnreadOnly) {
      return _notifications.where((n) => !n['isRead']).toList();
    }
    return _notifications;
  }

  void _toggleNotificationRead(int index) {
    setState(() {
      _notifications[index]['isRead'] = !_notifications[index]['isRead'];
    });
  }

  void _dismissNotification(int index) {
    final notification = _notifications[index];
    setState(() {
      _notifications.removeAt(index);
    });

    // Show undo snackbar
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: AppColors.dark700,
        content: Text(
          'Notification dismissed',
          style: TextStyle(color: AppColors.white, fontFamily: 'Inter'),
        ),
        action: SnackBarAction(
          label: 'UNDO',
          textColor: AppColors.neonCyan,
          onPressed: () {
            setState(() {
              _notifications.insert(index, notification);
            });
          },
        ),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      ),
    );
  }

  void _markAllAsRead() {
    setState(() {
      for (var notification in _notifications) {
        notification['isRead'] = true;
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: AppColors.neonGreen ?? Colors.green,
        content: Text(
          'All notifications marked as read',
          style: TextStyle(color: AppColors.white, fontFamily: 'Inter'),
        ),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.dark900,
      body: Stack(
        children: [
          // Animated background
          Container(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: Alignment.topRight,
                radius: 1.5,
                colors: [
                  AppColors.neonPurple.withOpacity(0.1),
                  AppColors.neonCyan.withOpacity(0.05),
                  AppColors.dark900,
                ],
                stops: const [0.1, 0.3, 1.0],
              ),
            ),
          ),

          // Particle effect
          _NotificationParticles(),

          CustomScrollView(
            slivers: [
              // App Bar
              SliverAppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                pinned: true,
                floating: true,
                snap: true,
                expandedHeight: 180,
                flexibleSpace: FlexibleSpaceBar(
                  background: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppColors.dark900.withOpacity(0.9),
                          Colors.transparent,
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                  title: const Text(
                    'Notifications',
                    style: TextStyle(
                      color: AppColors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Inter',
                    ),
                  ),
                  centerTitle: false,
                  titlePadding: const EdgeInsets.only(left: 20, bottom: 16),
                ),
                actions: [
                  IconButton(
                    icon: Icon(Icons.checklist_rounded, color: AppColors.white),
                    onPressed: _markAllAsRead,
                    tooltip: 'Mark all as read',
                  ),
                  const SizedBox(width: 8),
                ],
              ),

              // Filter Section
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 8,
                  ),
                  child: Row(
                    children: [
                      // Filter Chip
                      FilterChip(
                        selected: _showUnreadOnly,
                        onSelected: (selected) {
                          setState(() {
                            _showUnreadOnly = selected;
                          });
                        },
                        label: Text(
                          'Unread Only',
                          style: TextStyle(
                            color: _showUnreadOnly
                                ? AppColors.white
                                : AppColors.white.withOpacity(0.7),
                            fontFamily: 'Inter',
                          ),
                        ),
                        selectedColor: AppColors.neonPurple,
                        backgroundColor: AppColors.dark700,
                        checkmarkColor: AppColors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),

                      const Spacer(),

                      // Clear All Button
                      if (_notifications.isNotEmpty)
                        TextButton(
                          onPressed: () {
                            setState(() {
                              _notifications.clear();
                            });
                          },
                          style: TextButton.styleFrom(
                            foregroundColor: AppColors.neonPink,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.clear_all_rounded, size: 18),
                              const SizedBox(width: 4),
                              Text(
                                'Clear All',
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              ),

              // Notifications List
              if (_filteredNotifications.isNotEmpty)
                SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    final notification = _filteredNotifications[index];
                    final originalIndex = _notifications.indexOf(notification);

                    return NotificationItem(
                      title: notification['title'],
                      message: notification['message'],
                      time: notification['time'],
                      type: notification['type'],
                      isRead: notification['isRead'],
                      onTap: () => _toggleNotificationRead(originalIndex),
                      onDismiss: () => _dismissNotification(originalIndex),
                    );
                  }, childCount: _filteredNotifications.length),
                )
              else
                // Empty State
                SliverFillRemaining(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            colors: [
                              AppColors.neonPurple.withOpacity(0.3),
                              AppColors.neonCyan.withOpacity(0.1),
                            ],
                          ),
                        ),
                        child: Icon(
                          Icons.notifications_off_rounded,
                          size: 50,
                          color: AppColors.white.withOpacity(0.5),
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'No Notifications',
                        style: TextStyle(
                          color: AppColors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Inter',
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        _showUnreadOnly
                            ? 'You\'re all caught up! No unread notifications.'
                            : 'Notifications will appear here',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: AppColors.white.withOpacity(0.7),
                          fontSize: 16,
                          fontFamily: 'Inter',
                        ),
                      ),
                      const SizedBox(height: 32),
                      if (_showUnreadOnly)
                        TextButton(
                          onPressed: () {
                            setState(() {
                              _showUnreadOnly = false;
                            });
                          },
                          style: TextButton.styleFrom(
                            foregroundColor: AppColors.neonCyan,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 12,
                            ),
                          ),
                          child: Text(
                            'Show All Notifications',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                    ],
                  ).animate().fadeIn(duration: 500.ms),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

// Enhanced Particle Background for Notifications
class _NotificationParticles extends StatelessWidget {
  final List<Color> particleColors = [
    AppColors.neonPurple,
    AppColors.neonCyan,
    AppColors.neonPink,
    AppColors.neonBlue,
  ];

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return IgnorePointer(
      child: SizedBox(
        width: screenSize.width,
        height: screenSize.height,
        child: Stack(
          children: List.generate(
            12,
            (index) => Positioned(
              left: _getParticlePosition(screenSize.width, index, true),
              top: _getParticlePosition(screenSize.height, index, false),
              child: _NotificationParticle(index: index),
            ),
          ),
        ),
      ),
    );
  }

  double _getParticlePosition(double max, int index, bool isWidth) {
    final basePosition = (index / 12) * max;
    final randomOffset = (index * 41) % (max * 0.2);
    return (basePosition + randomOffset) % max;
  }
}

class _NotificationParticle extends StatelessWidget {
  final int index;
  final List<Color> colors = [
    AppColors.neonPurple,
    AppColors.neonCyan,
    AppColors.neonPink,
    AppColors.neonBlue,
  ];

  _NotificationParticle({required this.index});

  @override
  Widget build(BuildContext context) {
    final color = colors[index % colors.length];
    final size = 1.0 + (index % 2).toDouble();

    return Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: color.withOpacity(0.4),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.3),
                blurRadius: 6,
                spreadRadius: 1,
              ),
            ],
          ),
        )
        .animate(onPlay: (controller) => controller.repeat(reverse: true))
        .fade(
          duration: (2000 + index * 300).ms,
          curve: Curves.easeInOut,
          begin: 0.2,
          end: 0.8,
        )
        .scale(
          begin: const Offset(0.8, 0.8),
          end: const Offset(1.5, 1.5),
          duration: (2500 + index * 400).ms,
          curve: Curves.easeInOut,
        );
  }
}
