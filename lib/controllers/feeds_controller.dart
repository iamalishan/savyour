import '../constants/app_imports.dart';

class FeedsController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void addFeed({
    required String type,
    String? handle,
    required String brandId,
    required String brandLogo,
    required String url,
    required String brandName,
    required String title,
    required DateTime timestamp,
    required String image,
    String? oldPrice,
    String? newPrice,
    required String userId,
    String? checkOutUrl,
  }) async {
    try {
      final docRef = _firestore.collection('feed').doc();

      final feed = FeedModel(
        id: docRef.id,
        type: type,
        handle: handle,
        brandId: brandId,
        brandLogo: brandLogo,
        url: url,
        brandName: brandName,
        timestamp: DateTime.now(),
        title: title,
        image: image,
        oldPrice: oldPrice,
        newPrice: newPrice,
        userId: userId,
      );

      await docRef.set(feed.toFireStore());

      debugPrint('Feed added with ID: ${docRef.id}');
    } catch (e) {
      debugPrint('Error adding feed: $e');
    }
  }
}
