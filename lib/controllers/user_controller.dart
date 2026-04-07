import '../constants/app_imports.dart';

class UserController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Rx<AppUser?> user = Rx<AppUser?>(null);

  Future<void> initUser() async {
    final currentUser = _auth.currentUser;
    if (currentUser == null) {
      await _auth.signInAnonymously();
    }

    final uid = _auth.currentUser!.uid;
    final docRef = _firestore.collection('users').doc(uid);
    final doc = await docRef.get();

    if (doc.exists) {
      final data = doc.data()!;

      final updatedData = {
        'likedBrands': data['likedBrands'] ?? [],
        'likedCollections': data['likedCollections'] ?? [],
        'likedProducts': data['likedProducts'] ?? [],
        'notified_products': data['notified_products'] ?? [],
      };

      // Set missing fields
      if (data['likedBrands'] == null ||
          data['likedCollections'] == null ||
          data['likedProducts'] == null ||
          data['notified_products'] == null) {
        await docRef.set(updatedData, SetOptions(merge: true));
      }

      // Fetch subcollections for liked data
      final collectionDocs = await docRef.collection('likedCollectionData').get();
      final productDocs = await docRef.collection('likedProductData').get();

      final likedCollectionData = collectionDocs.docs.map((e) => LikeModel.fromMap(e.data())).toList();
      final likedProductData = productDocs.docs.map((e) => LikeModel.fromMap(e.data())).toList();

      user.value = AppUser(
        id: doc.id,
        likedBrands: List<String>.from(updatedData['likedBrands']),
        likedCollections: List<String>.from(updatedData['likedCollections']),
        likedProducts: List<String>.from(updatedData['likedProducts']),
        notifiedProducts: List<String>.from(updatedData['notified_products']),
        likedCollectionData: likedCollectionData,
        likedProductData: likedProductData,
      );
    } else {
      final newUser = AppUser(
        id: uid,
        likedBrands: [],
        likedCollections: [],
        likedProducts: [],
        notifiedProducts: [],
        likedCollectionData: [],
        likedProductData: [],
      );
      await docRef.set(newUser.toMap());
      user.value = newUser;
    }
  }

  Future<void> toggleLikeFromService({
    LikeModel? info,
    required String type,
    required bool isLikedNow,
    String? brandId,
  }) async {
    final uid = _auth.currentUser?.uid;
    final currentUser = user.value;
    if (uid == null || currentUser == null) return;

    final docRef = _firestore.collection('users').doc(uid);
    final id = info?.id ?? brandId;
    if (id == null) return;

    // Update ID in base user document
    await docRef.set({
      if (type == 'brand')
        'likedBrands': isLikedNow
            ? FieldValue.arrayUnion([id])
            : FieldValue.arrayRemove([id]),
      if (type == 'collection')
        'likedCollections': isLikedNow
            ? FieldValue.arrayUnion([id])
            : FieldValue.arrayRemove([id]),
      if (type == 'product')
        'likedProducts': isLikedNow
            ? FieldValue.arrayUnion([id])
            : FieldValue.arrayRemove([id]),
    }, SetOptions(merge: true));

    // Update subcollection for full object
    if ((type == 'collection' || type == 'product') && info != null) {
      final subCollection = type == 'collection' ? 'likedCollectionData' : 'likedProductData';
      final subDoc = docRef.collection(subCollection).doc(info.id);

      if (isLikedNow) {
        await subDoc.set(info.toMap());
      } else {
        await subDoc.delete();
      }
    }

    // Update local user model
    List<String> updatedBrands = List.from(currentUser.likedBrands);
    List<String> updatedCollections = List.from(currentUser.likedCollections);
    List<String> updatedProducts = List.from(currentUser.likedProducts);

    List<LikeModel> updatedCollectionData = List.from(currentUser.likedCollectionData ?? []);
    List<LikeModel> updatedProductData = List.from(currentUser.likedProductData ?? []);

    if (type == 'brand' && brandId != null) {
      isLikedNow ? updatedBrands.add(brandId) : updatedBrands.remove(brandId);
    } else if (type == 'collection' && info != null) {
      if (isLikedNow) {
        updatedCollections.add(info.id);
        updatedCollectionData.add(info);
      } else {
        updatedCollections.remove(info.id);
        updatedCollectionData.removeWhere((e) => e.id == info.id);
      }
    } else if (type == 'product' && info != null) {
      if (isLikedNow) {
        updatedProducts.add(info.id);
        updatedProductData.add(info);
      } else {
        updatedProducts.remove(info.id);
        updatedProductData.removeWhere((e) => e.id == info.id);
      }
    }

    user.value = AppUser(
      id: currentUser.id,
      likedBrands: updatedBrands,
      likedCollections: updatedCollections,
      likedProducts: updatedProducts,
      notifiedProducts: currentUser.notifiedProducts,
      likedCollectionData: updatedCollectionData,
      likedProductData: updatedProductData,
    );
  }

  Future<void> toggleNotification(String productId) async {
    final uid = _auth.currentUser?.uid;
    final currentUser = user.value;
    if (uid == null || currentUser == null) return;

    final docRef = _firestore.collection('users').doc(uid);
    List<String> updatedNotifiedProducts = List.from(currentUser.notifiedProducts);
    final isNowNotified = !updatedNotifiedProducts.contains(productId);

    if (isNowNotified) {
      updatedNotifiedProducts.add(productId);
    } else {
      updatedNotifiedProducts.remove(productId);
    }

    await docRef.set({
      'notified_products': isNowNotified
          ? FieldValue.arrayUnion([productId])
          : FieldValue.arrayRemove([productId]),
    }, SetOptions(merge: true));

    user.value = AppUser(
      id: currentUser.id,
      likedBrands: currentUser.likedBrands,
      likedCollections: currentUser.likedCollections,
      likedProducts: currentUser.likedProducts,
      notifiedProducts: updatedNotifiedProducts,
      likedCollectionData: currentUser.likedCollectionData,
      likedProductData: currentUser.likedProductData,
    );
  }

  bool isNotified(String productId) {
    final currentUser = user.value;
    if (currentUser == null) return false;
    return currentUser.notifiedProducts.contains(productId);
  }

  bool isLiked(String id, String type) {
    final currentUser = user.value;
    if (currentUser == null) return false;

    if (type == 'brand') return currentUser.likedBrands.contains(id);
    if (type == 'collection') return currentUser.likedCollections.contains(id);
    return currentUser.likedProducts.contains(id);
  }
}
