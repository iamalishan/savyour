import 'package:cloud_firestore/cloud_firestore.dart';

import '../constants/app_imports.dart';

class FBProductModel {
  final String productId;
  final String title;
  final String brandId;
  final String category;
  final List<String> images;
  final double price;
  final List<String> priceHistoryPrice;
  final List<DateTime> priceHistoryDate;
  final RxList<String> userLikedList;
  final List<String> notificationUserList;
  final DateTime lastUpdated;

  FBProductModel({
    required this.productId,
    required this.title,
    required this.brandId,
    required this.category,
    required this.images,
    required this.price,
    required this.priceHistoryPrice,
    required this.priceHistoryDate,
    required this.userLikedList,
    required this.notificationUserList,
    required this.lastUpdated,
  });

  /// From Firestore
  factory FBProductModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return FBProductModel(
      productId: data['productId'] ?? '',
      title: data['title'] ?? '',
      brandId: data['brandId'] ?? '',
      category: data['category'] ?? '',
      images: List<String>.from(data['images'] ?? []),

      // Handle dynamic type and null
      price: _toDouble(data['price']),

      // Convert to string regardless of type (and skip nulls safely)
      priceHistoryPrice: (data['price_history_price'] ?? [])
          .map<String>((e) => e?.toString() ?? '0')
          .toList(),

      priceHistoryDate: (data['price_history_date'] ?? []).map<DateTime>((e) {
        if (e is Timestamp) return e.toDate();
        if (e is String) return DateTime.tryParse(e) ?? DateTime.now();
        if (e is DateTime) return e;
        return DateTime.now();
      }).toList(),

      userLikedList: RxList(List<String>.from(data['user_liked_list'] ?? [])),
      notificationUserList: List<String>.from(data['notification_user_list'] ?? []),

      lastUpdated: (data['last_updated'] is Timestamp)
          ? (data['last_updated'] as Timestamp).toDate()
          : DateTime.now(),
    );
  }

  factory FBProductModel.fromMap(Map<String, dynamic> map) {
    return FBProductModel(
      brandId: map['brandId'] ?? '',
      category: map['category'] ?? '',
      images: List<String>.from(map['images'] ?? []),
      lastUpdated: map['last_updated'] ?? DateTime.now(),
      notificationUserList: List<String>.from(map['notification_user_list'] ?? []),

      price: _toDouble(map['price']),

      priceHistoryDate: (map['price_history_date'] ?? []).map<DateTime>((e) {
        if (e is Timestamp) return e.toDate();
        if (e is String) return DateTime.tryParse(e) ?? DateTime.now();
        if (e is DateTime) return e;
        return DateTime.now();
      }).toList(),

      priceHistoryPrice: (map['price_history_price'] ?? [])
          .map<String>((e) => e?.toString() ?? '0')
          .toList(),

      productId: map['productId'] ?? '',
      title: map['title'] ?? '',
      userLikedList: RxList(List<String>.from(map['user_liked_list'] ?? [])),
    );
  }

  static double _toDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }


}
