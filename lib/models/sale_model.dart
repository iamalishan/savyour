import 'package:cloud_firestore/cloud_firestore.dart';

class Sale {
  final String name;
  final String? imageUrl;
  final String? brandLogo;
  final String brandName;
  final int priority;
  final String url;
  final String brandId;
  final bool ended;
  final DateTime? addedDate;
  final DateTime? endedDate;

  Sale({
    required this.name,
    required this.imageUrl,
    required this.brandLogo,
    required this.brandName,
    required this.priority,
    required this.url,
    required this.brandId,
    required this.ended,
    this.addedDate,
    this.endedDate,
  });

  /// From Firestore Document
  factory Sale.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return Sale(
      name: data['name'] ?? '',
      imageUrl: data['image'],
      brandLogo: data['brandLogo'],
      brandName: data['brandName'] ?? '',
      priority: data['priority'] ?? 0,
      url: data['url'] ?? '',
      brandId: data['brandId'] ?? '',
      ended: data['ended'] ?? false,
      addedDate: (data['addedDate'] as Timestamp?)?.toDate(),
      endedDate: (data['endedDate'] as Timestamp?)?.toDate(),
    );
  }

  /// From nested Firestore structure
  factory Sale.fromNestedSale({
    required String brandId,
    required String brandName,
    required String brandLogo,
    required Map<String, dynamic> data,
  }) {
    return Sale(
      name: data['name'] ?? '',
      imageUrl: data['image'],
      brandLogo: brandLogo,
      brandName: brandName,
      priority: data['priority'] ?? 0,
      url: data['url'] ?? '',
      brandId: brandId,
      ended: data['ended'] ?? false,
      addedDate: (data['addedDate'] as Timestamp?)?.toDate(),
      endedDate: (data['endedDate'] as Timestamp?)?.toDate(),
    );
  }

  /// To Firestore Map
  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'image': imageUrl,
      'brandLogo': brandLogo,
      'brandName': brandName,
      'priority': priority,
      'url': url,
      'brandId': brandId,
      'ended': ended,
      'addedDate': addedDate != null ? Timestamp.fromDate(addedDate!) : null,
      'endedDate': endedDate != null ? Timestamp.fromDate(endedDate!) : null,
    };
  }
}
