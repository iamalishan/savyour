import '../../../constants/app_imports.dart';

class ProductServiceController extends GetxController {
  final collectionCon = Get.put(GetCollectionsNew());
  final DetailController controller = Get.put(DetailController());
  final BrandsController brandsCon = Get.put(BrandsController());
  final ProductsController productCon = Get.put(ProductsController());

  var scrollController = ScrollController();

  Brand? brand;
  Collection? collection;
  final RxList<Product> fetchedProducts = RxList<Product>();
  final RxBool isLoading = true.obs;
  final RxBool isLoadingMore = false.obs;
  final RxBool isLiked = false.obs;
  final RxBool hasMoreData = true.obs;
  final RxString selectedSortOption = 'Most Popular'.obs;

  final RxInt currentPage = 1.obs;
  final int limit = 20;

  // ================= Sort Options ==================
  void onSortOptionChanged(String? newValue) {
    selectedSortOption.value = newValue!;
  }

  // ================== Fetch Data ==================
  Future<void> fetchData(
    String brandId,
    String collectionHandle,
    Brand? mainBrand,
    Collection? mainCollection,
  ) async {
    isLoading(true);

    try {

      fetchedProducts.clear();
      currentPage.value = 1;
      hasMoreData.value = true;

      if (mainBrand != null) {
        brand = mainBrand;
      } else {
        brand = await brandsCon.fetchBrand(brandId);
      }
      if (brand?.url != null) {
        if (mainCollection != null) {
          collection = mainCollection;
        } else {
          collection = await collectionCon.fetchSingleCollection(
            brand!.url,
            collectionHandle,
          );
        }
      } else {
        print("Error: brand URL or collection handle is null.");
      }

      final products = await productCon.fetchMultipleProducts(
        brand!.url,
        collection!.handle,
        page: currentPage.value,
      );

      if (products.isNotEmpty) {
        fetchedProducts.addAll(products);

        if (products.isEmpty) {
          hasMoreData.value = false;
        }
      } else {
        hasMoreData.value = false;
      }

      if (collection != null) {
        FirebaseAnalyticsUtil.analyticLogEvent(
          name: 'collection_view',
          parameters: {
            "collection_id": collection!.id,
            "collection_title": collection!.title,
            "brand_id": brand!.id,
            "brand_name": brand!.name,
          },
        );

        await initializeLikes();
      }
    } catch (e) {
      print("Error fetching data: $e");
    } finally {
      isLoading(false);
    }
  }

  // ================== Load More Products ==================
  Future<void> loadMoreProducts() async {
    if (isLoadingMore.value || !hasMoreData.value || brand == null) return;

    isLoadingMore.value = true;
    currentPage.value += 1;

    try {
      final products = await productCon.fetchMultipleProducts(
        brand!.url,
        collection!.handle,
        page: currentPage.value,
      );

      if (products.isNotEmpty) {
        fetchedProducts.addAll(products);

        if (products.isEmpty) {
          hasMoreData.value = false;
        }
      } else {
        hasMoreData.value = false;
      }
    } catch (e) {
      print('Error loading more products: $e');
      currentPage.value -= 1;
    } finally {
      isLoadingMore.value = false;
    }
  }

  // ================== Like Status ==================
  Future<void> initializeLikes() async {
    final userId = Utils.userId;
    final collectionId = collection?.handle;

    if (userId == null || collectionId == null) return;

    final docRef = FirebaseFirestore.instance
        .collection('collections')
        .doc(collectionId);

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
        await docRef.update({'like_user_list': []});
        isLiked.value = false;
      } else {
        isLiked.value = likeList.contains(userId);
      }
    } catch (e) {
      print('Error initializing collection likes: $e');
    }
  }

  var feedController = Get.put(FeedsController());

  Future<void> toggleLike() async {
    final userId = Utils.userId;
    final collectionId = collection?.handle;
    final UserController userController = Get.find<UserController>();

    if (userId == null || collectionId == null) return;

    final docRef = FirebaseFirestore.instance
        .collection('collections')
        .doc(collectionId);

    try {
      isLiked.value = !isLiked.value;
      final doc = await docRef.get();
      final data = doc.data();
      final List<dynamic>? likeList = data?['like_user_list'];

      if (likeList == null) {
        // If field doesn't exist, create it but don't add user yet
        await docRef.update({'like_user_list': []});
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
        info: LikeModel(
          id: '${brand!.id}_${collection!.handle}',
          handle: collection!.handle,
          brandId: brand!.id,
          brandUrl: brand!.url,
        ),
        type: 'collection',
        isLikedNow: isLiked.value,
      );

      feedController.addFeed(
          brandId: brand!.id,
          type: 'collection_like',
          userId: userId,
          brandLogo: brand!.imageUrl ?? '',
          url: "${brand!.url}/collections/${collection!.handle}",
          brandName: brand!.name,
          timestamp: DateTime.now(),
          title: collection!.title,
          handle: collection!.handle,
          image: collection?.image ?? '',
      );
    } catch (e) {
      print('Error toggling collection like: $e');
    }
  }
}
