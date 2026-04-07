import 'package:cloud_firestore/cloud_firestore.dart';

class FeedModel {
  final String id;
  final String type;
  final String? handle;
  final String brandId;
  final String brandLogo;
  final String url;
  final String brandName;
  final DateTime timestamp;
  final String title;
  final String image;
  final String? oldPrice;
  final String? newPrice;
  final String userId;
  final String? checkOutUrl;

  FeedModel({
    required this.id,
    required this.type,
    this.handle,
    required this.brandId,
    required this.brandLogo,
    required this.url,
    required this.brandName,
    required this.timestamp,
    required this.title,
    required this.image,
    this.oldPrice,
    this.newPrice,
    required this.userId,
    this.checkOutUrl
  });

  factory FeedModel.fromFireStore(DocumentSnapshot doc) {
    final json = doc.data() as Map<String, dynamic>;
    return FeedModel(
      id: doc.id,
      type: json['type'],
      handle: json['handle'],
      brandId: json['brandId'],
      brandLogo: json['brandLogo'] ?? '',
      url: json['url'] ?? '',
      brandName: json['brandName'],
      timestamp: (json['timestamp'] as Timestamp).toDate(),
      title: json['title'],
      image: json['image'],
      oldPrice: json['oldPrice'],
      newPrice: json['newPrice'],
      userId: json['userId'],
      checkOutUrl: json['checkOutUrl'] ?? '',
    );
  }

  Map<String, dynamic> toFireStore() {
    return {
      'type': type,
      'handle': handle,
      'brandId': brandId,
      'brandLogo': brandLogo,
      'url': url,
      'brandName': brandName,
      'timestamp': timestamp,
      'title': title,
      'image': image,
      'oldPrice': oldPrice,
      'newPrice': newPrice,
      'userId': userId,
      'checkOutUrl': checkOutUrl ?? '',
    };
  }
}
