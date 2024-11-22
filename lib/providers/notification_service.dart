import 'dart:async';
import 'package:latlong2/latlong.dart';
import '../models/notification.dart';


class NotificationManager {
  static final List<NotificationItem> _notifications = [];
  static final _notificationController = StreamController<List<NotificationItem>>.broadcast();

  static Stream<List<NotificationItem>> get notificationStream => _notificationController.stream;
  static List<NotificationItem> get notifications => List.unmodifiable(_notifications);

  static void addNotification(LatLng location) {
    final notification = NotificationItem(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: 'New Incident Report',
      message: 'An incident has been reported at ${location.latitude.toStringAsFixed(4)}, ${location.longitude.toStringAsFixed(4)}',
      timestamp: DateTime.now(),
      location: location,
    );

    _notifications.insert(0, notification); // Add to beginning of list
    _notificationController.add(_notifications);
  }

  static void markAsRead(String id) {
    final index = _notifications.indexWhere((notification) => notification.id == id);
    if (index != -1) {
      final updatedNotification = NotificationItem(
        id: _notifications[index].id,
        title: _notifications[index].title,
        message: _notifications[index].message,
        timestamp: _notifications[index].timestamp,
        location: _notifications[index].location,
        isRead: true,
      );
      _notifications[index] = updatedNotification;
      _notificationController.add(_notifications);
    }
  }

  static void dispose() {
    _notificationController.close();
  }
}