import '../../../constants/app_imports.dart';

class FavoriteController extends GetxController {
  var likedBrands = <Brand>[].obs;
  var likedCollections = <Collection>[].obs;
  var likedProducts = <Product>[].obs;

  var isBrandsLoading = false.obs;
  var isCollectionsLoading = false.obs;
  var isProductsLoading = false.obs;

  final BrandsController _brandsController = Get.put(BrandsController());
  final UserController userController = Get.put(UserController());
  final GetCollectionsNew _collectionsController = Get.put(GetCollectionsNew());
  final ProductsController _productsController = Get.put(ProductsController());

  void initiate() async{
    await fetchLikedBrands();
    await fetchLikedCollections();
    fetchLikedProducts();
  }

  Future<void> fetchLikedBrands() async {
    final user = userController.user.value;
    if (user == null || user.likedBrands.isEmpty) {
      likedBrands.clear();
      return;
    }

    isBrandsLoading(true);

    likedBrands.clear();

    for (String brandId in user.likedBrands) {
      try {
        Brand? brand = await _brandsController.fetchBrand(brandId);
        if (brand != null) {
          likedBrands.add(brand);
        }
      } catch (e) {
        print("Error fetching brand for ID $brandId: $e");
      }
    }

    isBrandsLoading(false);

    print("Fetched liked brands: ${likedBrands.map((b) => b.name).toList()}");
  }

  Future<void> fetchLikedCollections() async {
    final user = userController.user.value;
    if (user == null || user.likedCollectionData == null) {
      likedCollections.clear();
      return;
    }

    isCollectionsLoading(true);

    likedCollections.clear();

    for (LikeModel like in user.likedCollectionData!) {
      try {
        final collection = await _collectionsController.fetchSingleCollection(
          like.brandUrl ?? '', like.handle ?? '',
        );
        likedCollections.add(collection);
      } catch (e) {
        print("Error fetching collection: $e");
      }
    }

    isCollectionsLoading(false);

    print("Fetched liked collections: ${likedCollections.map((c) => c.title).toList()}");
  }

  Future<void> fetchLikedProducts() async {
    final user = userController.user.value;
    if (user == null || user.likedProductData == null) {
      likedProducts.clear();
      return;
    }

    isProductsLoading(true);

    likedProducts.clear();

    for (LikeModel like in user.likedProductData!) {
      try {
        final product = await _productsController.fetchSingleProduct(
          like.brandUrl ?? '', like.handle ?? '',
        );
        likedProducts.add(product);
      } catch (e) {
        print("Error fetching product: $e");
      }
    }

    isProductsLoading(false);

    print("Fetched liked products: ${likedProducts.map((c) => c.title).toList()}");
  }

}
