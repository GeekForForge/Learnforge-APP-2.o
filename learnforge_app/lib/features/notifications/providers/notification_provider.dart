import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/notification_model.dart';
import '../../../core/constants/dummy_data.dart';

final notificationsProvider = StateProvider<List<NotificationModel>>((ref) {
  return DummyData.getNotifications();
});

final unreadNotificationsProvider = Provider<int>((ref) {
  final notifications = ref.watch(notificationsProvider);
  return notifications.where((n) => !n.isRead).length;
});
