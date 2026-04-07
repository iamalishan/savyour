import 'like_model.dart';

class AppUser {
  final String id;
  final List<String> likedBrands;
  final List<String> likedCollections;
  final List<String> likedProducts;
  final List<String> notifiedProducts;
  final List<LikeModel>? likedCollectionData;
  final List<LikeModel>? likedProductData;

  AppUser({
    required this.id,
    required this.likedBrands,
    required this.likedCollections,
    required this.likedProducts,
    this.notifiedProducts = const [],
    this.likedCollectionData,
    this.likedProductData,
  });

  factory AppUser.fromMap(String id, Map<String, dynamic> data) {
    return AppUser(
      id: id,
      likedBrands: List<String>.from(data['likedBrands'] ?? []),
      likedCollections: List<String>.from(data['likedCollections'] ?? []),
      likedProducts: List<String>.from(data['likedProducts'] ?? []),
      notifiedProducts: List<String>.from(data['notified_products'] ?? []),
      likedCollectionData: data['likedCollectionData'] != null
          ? List<LikeModel>.from(
        (data['likedCollectionData'] as List)
            .map((x) => LikeModel.fromMap(x)),
      )
          : null,
      likedProductData: data['likedProductData'] != null
          ? List<LikeModel>.from(
        (data['likedProductData'] as List)
            .map((x) => LikeModel.fromMap(x)),
      )
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'likedBrands': likedBrands,
      'likedCollections': likedCollections,
      'likedProducts': likedProducts,
      'notified_products': notifiedProducts,
      'likedCollectionData': likedCollectionData?.map((e) => e.toMap()).toList(),
      'likedProductData': likedProductData?.map((e) => e.toMap()).toList(),
    };
  }
}