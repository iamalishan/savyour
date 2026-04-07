import 'dart:math';
import 'package:ecommerce_web/controllers/navbar_search_controller.dart';
import 'package:ecommerce_web/screens/product/controller/product_service_controller.dart';
import 'package:get/get.dart';

import '../constants/app_imports.dart';
import '../screens/collection/collection_controller/collection_service_controller.dart';
import '../screens/product_detail/controller/product_detail_controller.dart';
import '../screens/share_screen_shots/brand_post.dart';
import '../screens/share_screen_shots/collection_post.dart';
import '../screens/share_screen_shots/collection_story.dart';
import '../screens/share_screen_shots/product_post.dart';
import '../screens/share_screen_shots/product_story.dart';

class ShareImageController extends GetxController {

  final navbarSearchCon = Get.put(NavbarSearchController());

  RxString currentPage = ''.obs;

  void onShareTap() {
    currentPage.value = navbarSearchCon.currentPage.value;
    final isBrand = currentPage.value == 'brand';
    final isCollection = currentPage.value == 'collection';
    final isProduct = currentPage.value == 'product';

    if (isBrand) {
      _handleBrandShare();
    } else if (isCollection) {
      _handleCollectionShare();
    } else if (isProduct) {
      _handleProductShare();
    }
  }

  void _handleBrandShare() {
    final collections = Get.find<CollectionServiceController>().fetchedCollections;
    final validImages = collections
        .map((c) => c.image)
        .where((img) => img != null && img.isNotEmpty)
        .toList();

    if (validImages.length >= 6) {
      Get.to(() => const BrandPostScreenShot());
    } else {
      Get.snackbar(
        'Not enough images',
        'At least 6 collection images are required.',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  void _handleCollectionShare() {
    final controller = Get.find<ProductServiceController>();
    final fetchedProducts = controller.fetchedProducts;

    Get.defaultDialog(
      title: "Choose Share Type",
      content: Column(
        children: [
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              final images = _getCollectionPostImages(fetchedProducts);
              if (images.length < 3) {
                Get.snackbar(
                  'Not enough images',
                  'At least 3 product images are required for post.',
                  snackPosition: SnackPosition.BOTTOM,
                );
                return;
              }
              Get.back();
              Get.to(() => const CollectionPostScreenShot());
            },
            child: const Text("Post"),
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {
              final images = _getCollectionStoryImages(fetchedProducts);
              if (images.length < 5) {
                Get.snackbar(
                  'Not enough images',
                  'At least 5 product images are required for story.',
                  snackPosition: SnackPosition.BOTTOM,
                );
                return;
              }
              Get.back();
              Get.to(() => const CollectionScreenShot());
            },
            child: const Text("Story"),
          ),
        ],
      ),
    );
  }

  void _handleProductShare() {
    final product = Get.find<ProductDetailController>().product!;

    Get.defaultDialog(
      title: "Choose Share Type",
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 20),

          // Post button
          ElevatedButton(
            onPressed: () {
              if (product.images.length < 2) {
                Get.snackbar(
                  'Not enough images',
                  'This product must have at least 2 images for post.',
                  snackPosition: SnackPosition.BOTTOM,
                );
                return;
              }

              Get.back(); // Close dialog
              Get.to(() => const ProductPostScreenShot());
            },
            child: const Text("Post"),
          ),

          const SizedBox(height: 10),

          // Story button
          ElevatedButton(
            onPressed: () {
              if (product.images.length < 3) {
                Get.snackbar(
                  'Not enough images',
                  'This product must have at least 3 images for story.',
                  snackPosition: SnackPosition.BOTTOM,
                );
                return;
              }

              Get.back(); // Close dialog
              Get.to(() => const ProductStoryScreen());
            },
            child: const Text("Story"),
          ),
        ],
      ),
    );
  }

  List<String> _getCollectionPostImages(List fetchedProducts) {
    final images = <String>[];

    if (fetchedProducts.length >= 3) {
      for (int i = 0; i < 3; i++) {
        final product = fetchedProducts[i];
        if (product.images.isNotEmpty) {
          images.add(product.images.first.src);
        } else {
          images.add('https://via.placeholder.com/300');
        }
      }
    } else if (fetchedProducts.isNotEmpty) {
      final firstProductImages = fetchedProducts.first.images;
      for (int i = 0; i < min(3, firstProductImages.length); i++) {
        images.add(firstProductImages[i].src);
      }

      while (images.length < 3) {
        images.add('https://via.placeholder.com/300');
      }
    } else {
      images.addAll(List.generate(3, (_) => 'https://via.placeholder.com/300'));
    }

    return images;
  }

  List<String> _getCollectionStoryImages(List fetchedProducts) {
    final allImages = <String>[];

    for (var product in fetchedProducts) {
      for (var img in product.images) {
        allImages.add(img.src);
        if (allImages.length == 5) return allImages;
      }
    }

    return allImages;
  }
}
