import 'package:flutter/material.dart';

class NotificationModel {
  final String id;
  final String title;
  final String message;
  final String type; // 'achievement', 'course', 'arena', 'reminder'
  final String? icon;
  final DateTime timestamp;
  final bool isRead;
  final VoidCallback? onTap;

  NotificationModel({
    required this.id,
    required this.title,
    required this.message,
    required this.type,
    this.icon,
    required this.timestamp,
    this.isRead = false,
    this.onTap,
  });
}
