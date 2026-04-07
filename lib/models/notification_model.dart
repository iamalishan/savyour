import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationModel {
  final String handle;
  final String brandId;
  final String title;
  final DateTime timestamp;
  final double oldPrice;
  final double newPrice;
  final String image;
  final String type;

  NotificationModel({
    required this.handle,
    required this.brandId,
    required this.title,
    required this.timestamp,
    required this.oldPrice,
    required this.newPrice,
    required this.image,
    this.type = 'product history'
  });

  factory NotificationModel.fromFireStore(Map<String, dynamic> data) {
    return NotificationModel(
      handle: data['handle'] ?? '',
      brandId: data['brandId'] ?? '',
      title: data['title'] ?? '',
      timestamp: (data['timestamp'] as Timestamp).toDate(),
      oldPrice: (data['oldPrice'] as num).toDouble(),
      newPrice: (data['newPrice'] as num).toDouble(),
      image: data['image'] ?? '',
      type: data['notificationType'] ?? 'product history',
    );
  }


  /// Convert to Firestore
  Map<String, dynamic> toFireStore() {
    return {
      'handle': handle,
      'brandId': brandId,
      'title': title,
      'timestamp': Timestamp.fromDate(timestamp),
      'oldPrice': oldPrice,
      'newPrice': newPrice,
      'image': image,
      'notificationType': type,
    };
  }
}
