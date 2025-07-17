import 'package:flutter/foundation.dart';
import '../services/notification_service.dart';

class NotificationProvider with ChangeNotifier {
  final NotificationService _notificationService = NotificationService();
  
  // Initialize notifications
  Future<void> initNotifications() async {
    await _notificationService.initNotification();
  }
  
  // Check for permissions
  Future<bool> checkPermissions() async {
    // You can add permission checking here if needed
    return true;
  }
  
  // Show a test notification
  Future<void> showTestNotification() async {
    await _notificationService.showNotification(
      id: 0,
      title: 'Test Notification',
      body: 'This is a test notification from KP GYM app.',
    );
  }
  
  // Cancel all notifications
  Future<void> cancelAllNotifications() async {
    await _notificationService.cancelAllNotifications();
  }
}