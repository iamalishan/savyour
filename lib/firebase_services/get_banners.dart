import 'package:ecommerce_web/constants/app_imports.dart';

class BannerController extends GetxController {
  var banners = <BannerModel>[].obs;
  var isLoading = true.obs;
  var isAddLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchBanners();
  }

  Future<void> fetchBanners() async {
    try {
      isLoading(true);
      QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collection('banners').get();

      banners.value = snapshot.docs.map((doc) {
        return BannerModel.fromFirestore(doc);
      }).toList();
    } catch (e) {
      print("Error fetching banners: $e");
    } finally {
      isLoading(false);
    }
  }

  String removeTrailingSlash(String url) {
    if (url.endsWith('/')) {
      return url.substring(0, url.length - 1);
    }
    return url;
  }

  Future<bool> addBanner(
      String? name, String? imageUrl, String? brandUrl, String? brandId) async {
    if (name == null ||
        imageUrl == null ||
        brandUrl == null ||
        brandId == null) {
      print("Error: All fields are required and cannot be null");
      return false;
    }

    try {
      isAddLoading(true);

      await fetchBanners();
      int priority = banners.length + 1;

      var url = removeTrailingSlash(brandUrl);
      print(url);

      await FirebaseFirestore.instance.collection('banners').add({
        'name': name,
        'image': imageUrl,
        'url': url,
        'priority': priority,
        'brandId': brandId,
      });

      return true;
    } catch (e) {
      print("Error adding sale: $e");
      return false;
    } finally {
      isAddLoading(false);
    }
  }
}

class BannerModel {
  final String image;
  final String name;
  final int priority;
  final String url;
  final String brandId;

  BannerModel({
    required this.image,
    required this.name,
    required this.priority,
    required this.url,
    required this.brandId,
  });

  factory BannerModel.fromFirestore(DocumentSnapshot doc) {
    return BannerModel(
        image: doc['image'],
        name: doc['name'],
        priority: doc['priority'],
        url: doc['url'],
        brandId: doc['brandId']);
  }
}
