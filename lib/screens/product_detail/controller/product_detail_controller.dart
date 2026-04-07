import 'package:ecommerce_web/constants/app_imports.dart';
import 'package:ecommerce_web/firebase_services/get_coupons.dart';

import '../../../models/fb_product_model.dart';

class ProductDetailController extends GetxController {
  var currentPage = 0.obs;
  var numPages = 0.obs;
  var isLiked = false.obs;
  var isLikeLoading = false.obs;
  var isNotificationLoading = false.obs;
  var likesFound = false.obs;
  var isNotified = false.obs;
  var isLoading = true.obs;
  Product? product;
  Brand? brand;
  final RxList<Product> relatedProducts = RxList<Product>();
  final RxList<Coupon> brandCoupons = RxList<Coupon>();
  var textController1 = TextEditingController();
  var textController2 = TextEditingController();
  final fbRef = FirebaseFirestore.instance.collection("products");
  Rx<FBProductModel?> fbProduct = Rx<FBProductModel?>(null);
  DetailController controller = Get.put(DetailController());
  ProductsController productsController = Get.put(ProductsController());
  BrandsController brandsController = Get.put(BrandsController());
  CouponsController couponController = Get.put(CouponsController());
  var feedController = Get.put(FeedsController());

  // Methods

  void fetchData(
    String brandId,
    String productHandle,
    Product? mainProduct,
    Brand? mainBrand,
  ) async {
    isLoading.value = true;
    if (mainBrand != null) {
      brand = mainBrand;
    } else {
      brand = await brandsController.fetchBrand(brandId);
    }
    if (mainProduct != null) {
      product = mainProduct;
    } else {
      product = await productsController.fetchSingleProduct(
        brand!.url,
        productHandle,
      );
    }
    numPages.value = product?.images.length ?? 0;

    final String productId = "${brand!.id}_$productHandle";

    DocumentSnapshot docSnapshot = await fbRef.doc(productId).get();

    if (!docSnapshot.exists && product != null) {
      Map<String, dynamic> productData = {
        "brandId": brand!.id,
        "category": brand!.name,
        "images": product!.images.map((e) => e.src).toList(),
        "last_updated": DateTime.now(),
        "notification_user_list": [],
        "price": product!.variants.first.price,
        "price_history_date": [DateTime.now()],
        "price_history_price": [product!.variants.first.price],
        "productId": productId,
        "title": product!.title,
        "user_liked_list": [],
      };

      await fbRef.doc(productId).set(productData);
      fbProduct.value = FBProductModel.fromMap(productData);
    } else {
      fbProduct.value = FBProductModel.fromFirestore(docSnapshot);

      final newPrice = double.parse(product!.variants.first.price).round();
      final existingPrice = double.parse(fbProduct.value!.price.toString()).round();

      if (newPrice != existingPrice) {
        await fbRef.doc(productId).update({
          'price': newPrice,
          'last_updated': DateTime.now(),
          'price_history_price': FieldValue.arrayUnion([newPrice]),
          'price_history_date': FieldValue.arrayUnion([DateTime.now()]),
        });
        feedController.addFeed(
          brandId: brand!.id,
          type: 'price_changed',
          userId: Utils.userId!,
          brandLogo: brand!.imageUrl ?? '',
          url: "${brand!.url}/products/${product!.handle}",
          brandName: brand!.name,
          timestamp: DateTime.now(),
          title: product!.title,
          handle: product!.handle,
          image: product?.images.first.src ?? '',
          oldPrice: existingPrice.toString(),
          newPrice: newPrice.toString(),
        );
      }
    }

    if (fbProduct.value != null &&
        fbProduct.value!.userLikedList.contains(Utils.userId)) {
      isLiked.value = true;
    }

    if (fbProduct.value != null &&
        fbProduct.value!.notificationUserList.contains(Utils.userId)) {
      isNotified.value = true;
    }

    relatedProducts.value = await productsController.fetchRelatedProducts(
      brand!.url,
      product!.id.toString(),
    );

    FirebaseAnalyticsUtil.analyticLogEvent(
      name: 'product_view',
      parameters: {
        'product_id': productId,
        'brand_id': brand!.id,
        'brand_name': brand!.name,
        'product_title': product!.title,
      },
    );

    brandCoupons.assignAll(
      await couponController.fetchCouponsByBrandId(brandId),
    );

    isLoading.value = false;
  }

  void toggleLike() async {
    isLikeLoading.value = true;
    final productId = fbProduct.value?.productId;
    final userId = Utils.userId;
    final UserController userController = Get.find<UserController>();

    if (productId == null || userId == null) return;

    final docRef = fbRef.doc(productId);

    try {
      if (isLiked.value) {
        await docRef.update({
          "user_liked_list": FieldValue.arrayRemove([userId]),
        });
        fbProduct.value!.userLikedList.remove(userId);
      } else {
        await docRef.update({
          "user_liked_list": FieldValue.arrayUnion([userId]),
        });
        fbProduct.value!.userLikedList.add(userId);
      }

      isLiked.value = !isLiked.value;

      await userController.toggleLikeFromService(
        info: LikeModel(
          id: '${brand!.id}_${product!.handle}',
          handle: product!.handle,
          brandId: brand!.id,
          brandUrl: brand!.url,
        ),
        type: 'product',
        isLikedNow: isLiked.value,
      );

      feedController.addFeed(
        brandId: brand!.id,
        type: 'product_like',
        userId: userId,
        brandLogo: brand!.imageUrl ?? '',
        url: "${brand!.url}/products/${product!.handle}",
        brandName: brand!.name,
        timestamp: DateTime.now(),
        title: product!.title,
        handle: product!.handle,
        image: (product?.images != null && product!.images.isNotEmpty)
            ? product!.images.first.src
            : '',
      );
    } catch (e) {
      debugPrint("Error toggling like: $e");
    }
    isLikeLoading.value = false;
  }

  Future<void> toggleNotification() async {
    isNotificationLoading.value = true;

    final productId = fbProduct.value?.productId;
    final userId = Utils.userId;

    if (productId == null || userId == null) return;

    final docRef = fbRef.doc(productId);

    try {
      if (isNotified.value) {
        await docRef.update({
          "notification_user_list": FieldValue.arrayRemove([userId]),
        });
        fbProduct.value!.notificationUserList.remove(userId);
      } else {
        await docRef.update({
          "notification_user_list": FieldValue.arrayUnion([userId]),
        });
        fbProduct.value!.notificationUserList.add(userId);
      }

      Get.find<UserController>().toggleNotification(
        '${brand?.id}_${product?.handle}',
      );

      isNotified.value = !isNotified.value;
    } catch (e) {
      debugPrint("Error toggling notification: $e");
    }
    isNotificationLoading.value = false;
  }

  void initializeProductLikes(DetailController controller) async {
    // bool result = await controller.getProductLikes(
    //     "${brand!.id}_${widget.productHandle}");
    //
    // if (result && controller.productLikes.value != null) {
    //   isLiked = controller.productLikes.value!.userIds
    //       .contains("${Utils.userId}_${Utils.userToken}");
    //   likesFound = true;
    // } else {
    //   isLiked = false;
    //   likesFound = false;
    // }
    //
    // if (product != null && product!.variants.isNotEmpty) {
    //   await controller.comparePrice("${brand!.id}_${widget.productHandle}",
    //       double.parse(product!.variants.first.price));
    //   await controller.priceHistoryFunc("${brand!.id}_${widget.productHandle}",
    //       double.parse(product!.variants.first.price));
    // }
    //
    // if (controller.priceResponse.value != null) {
    //   this.isNotified = controller.priceResponse.value!.data.userTokens
    //       .contains("${Utils.userId}_${Utils.userToken}");
    // }
    //
    // setState(() {
    //   isLoading = false;
    // });
  }
}
