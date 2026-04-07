import 'package:cloud_firestore/cloud_firestore.dart';

class Coupon {
  final String id;
  final String brandId;
  final String brandLogo;
  final String brandName;
  final String coupon;
  final bool disabled;
  final bool expired;
  final String? money;
  final String percentage;
  final DateTime addedDate;

  Coupon({
    required this.id,
    required this.brandId,
    required this.brandLogo,
    required this.brandName,
    required this.coupon,
    required this.disabled,
    required this.expired,
    this.money,
    required this.percentage,
    required this.addedDate,
  });


  factory Coupon.fromFireStore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return Coupon(
      id: doc.id,
      brandId: data['brandId'] ?? '',
      brandLogo: data['brandLogo'] ?? '',
      brandName: data['brandName'] ?? '',
      coupon: data['coupon'] ?? '',
      disabled: data['disabled'] ?? false,
      expired: data['expired'] ?? false,
      money: data['money'],
      percentage: data['percentage'] ?? '',
      addedDate: (data['addedDate'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toFireStore() {
    return {
      'brandId': brandId,
      'brandLogo': brandLogo,
      'brandName': brandName,
      'coupon': coupon,
      'disabled': disabled,
      'expired': expired,
      'money': money,
      'percentage': percentage,
      'addedDate': addedDate, // ✅ stored as Timestamp in Firestore
    };
  }
}
