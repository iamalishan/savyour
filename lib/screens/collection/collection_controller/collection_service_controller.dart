import 'package:ecommerce_web/utils/insta_image_fetcher.dart';

import '../../../constants/app_imports.dart';
import '../../../firebase_services/get_coupons.dart';

class CollectionServiceController extends GetxController {
  Brand? brand;
  final RxList<Collection> fetchedCollections = RxList<Collection>();
  final RxList<Collection> featuredCollections = RxList<Collection>();
  final RxList<Coupon> coupons = RxList<Coupon>();
  final RxBool isLoading = true.obs;
  final RxBool isLoadingFeatured = true.obs;
  final RxBool isLoadingCoupons = true.obs;
  final RxBool isLoadingMore = false.obs;
  final RxBool isLiked = false.obs;
  final RxBool hasMoreData = true.obs;

  final RxString coverImage = ''.obs;

  final RxInt currentPage = 1.obs;
  final int limit = 20;

  GetCollectionsNew? collectionsController;
  var saleController = Get.put(SalesController());
  var couponController = Get.put(CouponsController());

  // =================== Fetch Coupons =================
  Future<void> fetchCoupons(String brandId) async {
    try {
      isLoadingCoupons(true);
      final couponsList = await couponController.fetchCouponsByBrandId(brandId);
      coupons.assignAll(couponsList);
    } catch (e) {
      print('Error fetching coupons: $e');
    }
    isLoadingCoupons(false);
  }

  // ================== Fetch Data ==================
  Future<void> fetchData(String brandId, Brand? mainBrand) async {
    isLoading.value = true;
    isLoadingFeatured(true);
    currentPage.value = 1;
    hasMoreData.value = true;
    featuredCollections.clear();

    try {
      final BrandsController brandsController = Get.find();
      collectionsController = Get.put(GetCollectionsNew());

      if (mainBrand != null) {
        brand = mainBrand;
      } else {
        final fetchedBrand = await brandsController.fetchBrand(brandId);
        brand = fetchedBrand;
      }

      if (brand != null) {
        final collections = await collectionsController!
            .fetchMultipleCollections(brand!.url, page: currentPage.value);

        fetchedCollections.assignAll(collections);

        final firstImage = collections.firstWhere(
              (c) => c.image != null && c.image!.isNotEmpty,
        );
        coverImage.value = firstImage.image!;

        if (collections.isEmpty) {
          hasMoreData.value = false;
        }

        FirebaseAnalyticsUtil.analyticLogEvent(
          name: 'brand_view',
          parameters: {"brand_id": brand!.id, "brand_name": brand!.name},
        );

        await initializeLikeStatus();

        isLoading.value = false;

        await fetchCoupons(brandId);

        await fetchFeaturedCollections();

      }
    } catch (e) {
      print('Error fetching collection data: $e');
      isLoading.value = false;
    } finally {
      isLoading.value = false;
      isLoadingFeatured(false);
    }
  }

  Future<void> fetchFeaturedCollections() async {
    try {
      List<String> collectionUrls = await extractCollectionUrls(brand!.url);

      List<String> saleUrls = [];
      List<String> nonSaleUrls = [];

      for (var url in collectionUrls) {
        final handle = Uri.parse(url).pathSegments.last;
        if (handle.contains('sale')) {
          saleUrls.add(url);
        } else {
          nonSaleUrls.add(url);
        }
      }

      featuredCollections.clear();

      if (saleUrls.isNotEmpty) {
        var saleCollections = await collectionsController!.fetchDifferentCollections(saleUrls);
        featuredCollections.assignAll(saleCollections);

        for (var sale in saleCollections) {
          await saleController.addSale(brand!, sale);
        }
      } else {
        final docRef = FirebaseFirestore.instance.collection('sale').doc(brand!.id);
        final docSnapshot = await docRef.get();

        if (docSnapshot.exists) {
          final sales = List.from(docSnapshot.data()?['sales'] ?? []);
          final updatedSales = sales.map((sale) => {
            ...sale,
            'ended': true,
            'endedDate': DateTime.now(),
          }).toList();

          await docRef.update({'sales': updatedSales});
          print("Marked ${updatedSales.length} sale(s) as ended.");
        }
      }

      final remaining = 10 - featuredCollections.length;
      if (remaining > 0) {
        final extraCollections = await collectionsController!
            .fetchDifferentCollections(nonSaleUrls.take(remaining).toList());
        featuredCollections.addAll(extraCollections);
      }

      final firstFeaturedImage = featuredCollections.firstWhere(
            (c) => c.image != null && c.image!.isNotEmpty,
      );

      if (firstFeaturedImage.image != null && firstFeaturedImage.image!.isNotEmpty) {
        coverImage.value = firstFeaturedImage.image!;
      }

    } catch (e) {
      print("Error processing collections: $e");
    } finally {
      isLoadingFeatured(false);
    }
  }

  // ================== Load More Collections ==================
  Future<void> loadMoreCollections() async {
    if (isLoadingMore.value || !hasMoreData.value || brand == null) return;

    isLoadingMore.value = true;
    currentPage.value += 1;

    try {
      final collections = await collectionsController!.fetchMultipleCollections(
        brand!.url,
        page: currentPage.value,
      );

      if (collections.isNotEmpty) {
        fetchedCollections.addAll(collections);

        if (collections.isEmpty) {
          hasMoreData.value = false;
        }
      } else {
        hasMoreData.value = false;
      }
    } catch (e) {
      print('Error loading more collections: $e');
      currentPage.value -= 1;
    } finally {
      isLoadingMore.value = false;
    }
  }

  // ================== Like Status ==================
  Future<void> initializeLikeStatus() async {
    final userId = Utils.userId;
    final brandId = brand?.id;

    if (userId == null || brandId == null) return;

    final docRef = FirebaseFirestore.instance.collection('brands').doc(brandId);

    try {
      final doc = await docRef.get();

      if (!doc.exists) {
        await docRef.set({'like_user_list': []}, SetOptions(merge: true));
        isLiked.value = false;
        return;
      }

      final data = doc.data();
      final likeList = data?['like_user_list'];

      if (likeList == null) {
        // Only add the empty list, not userId
        await docRef.update({'like_user_list': []});
        isLiked.value = false;
      } else {
        isLiked.value = likeList.contains(userId);
      }
    } catch (e) {
      print('Error checking like status: $e');
    }
  }

  var feedController = Get.put(FeedsController());

  Future<void> toggleLike() async {
    final userId = Utils.userId;
    final brandId = brand?.id;

    print('User Id: $userId');
    if (userId == null || brandId == null) return;

    final docRef = FirebaseFirestore.instance.collection('brands').doc(brandId);
    final UserController userController = Get.find<UserController>();

    try {
      isLiked.value = !isLiked.value;

      final doc = await docRef.get();
      final data = doc.data();
      final List<dynamic>? likeList = data?['like_user_list'];

      if (likeList == null) {
        await docRef.set({'like_user_list': []}, SetOptions(merge: true));
        isLiked.value = false;
        return;
      }

      if (likeList.contains(userId)) {
        await docRef.update({
          'like_user_list': FieldValue.arrayRemove([userId]),
        });
        isLiked.value = false;
      } else {
        await docRef.update({
          'like_user_list': FieldValue.arrayUnion([userId]),
        });
        isLiked.value = true;
      }

      await userController.toggleLikeFromService(
        brandId: brandId,
        type: 'brand',
        isLikedNow: isLiked.value,
      );

      feedController.addFeed(
          brandId: brandId,
          type: 'brand_like',
          userId: userId,
          brandLogo: brand?.imageUrl ?? '',
          url: brand?.url ?? '',
          brandName: brand!.name,
          timestamp: DateTime.now(),
          title: brand!.name,
          image: brand?.imageUrl ?? '',
      );
    } catch (e) {
      print('Error toggling like: $e');
    }
  }
}
