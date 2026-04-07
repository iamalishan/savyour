import 'package:ecommerce_web/constants/app_imports.dart';

class HomeController extends GetxController {
  var isBannerLoading = false.obs;
  var isProductLoading = false.obs;

  final DetailController detailController = Get.find<DetailController>();

  @override
  void onInit() {
    super.onInit();
    detailController.setMobNavbarIndex(0);
    detailController.setNavbarIndex(0);
  }

  Future<List<Product>> fetchData(String brandId, String url) async {
    List<Product> fetchedProducts = [];

    String brandUrl = Utils.extractCollectionInfo(url);
    String collectionHandle = Utils.getCollectionHandle(url);
    fetchedProducts = await ProductsController().fetchMultipleProducts(
      brandUrl,
      collectionHandle,
    );
    return fetchedProducts;
  }

  Future<void> handleOnTap(Function navigationFunction) async {
    try {
      await navigationFunction();
    } finally {}
  }

  Future<bool> addHomePageEntry({
    required String type,
    required String name,
    required String url,
    required String brandId,
    String? imageUrl,
  }) async {
    final CollectionReference homePageCollection = FirebaseFirestore.instance
        .collection('home_page');

    try {
      // Set the loading state based on type
      if (type == 'banner') {
        isBannerLoading.value = true;
      } else if (type == 'products') {
        isProductLoading.value = true;
      }

      String removeTrailingSlash(String url) {
        if (url.endsWith('/')) {
          return url.substring(0, url.length - 1);
        }
        return url;
      }

      url = removeTrailingSlash(url);

      final QuerySnapshot querySnapshot = await homePageCollection.get();
      int newPriority = querySnapshot.docs.length + 1;

      Map<String, dynamic> data = {
        'type': type,
        'brandName': name,
        'url': url,
        'priority': newPriority,
        'brandId': brandId,
      };

      if (type == 'banner' && imageUrl != null) {
        data['image'] = imageUrl;
      }

      await homePageCollection.add(data);
      print("Document added successfully with priority $newPriority!");
      return true;
    } catch (e) {
      print("Failed to add document: $e");
      return false;
    } finally {
      // Reset the loading state
      if (type == 'banner') {
        isBannerLoading.value = false;
      } else if (type == 'products') {
        isProductLoading.value = false;
      }
    }
  }
}
