// import 'package:ecommerce_web/constants/app_imports.dart';
// import 'package:ecommerce_web/screens/product_detail/web_detail_widgets/web_product_description.dart';
//
// import '../mob_detail_widgets/image_indicators.dart';
// import '../mob_detail_widgets/material_buttons.dart';
// import '../mob_detail_widgets/notification_alert_dialogs.dart';
// import '../mob_detail_widgets/product_description.dart';
// import '../mob_detail_widgets/shop_bottom_button.dart';
// import '../mob_detail_widgets/images_scroller.dart';
// import '../web_detail_widgets/web_image_indicators.dart';
// import '../web_detail_widgets/web_images_scroller.dart';
// import '../web_detail_widgets/web_material_buttons.dart';
// import '../web_detail_widgets/web_notification_alerts.dart';
// import '../web_detail_widgets/web_shop_button.dart';
//
// class ProductDetailScreen extends StatefulWidget {
//   ProductDetailScreen({
//     super.key,
//   });
//
//   String productHandle = Get.parameters["productHandle"]!;
//   String brandId = Get.parameters['brandId']!;
//
//   @override
//   ProductDetailScreenState createState() => ProductDetailScreenState();
// }
//
// class ProductDetailScreenState extends State<ProductDetailScreen> {
//   final PageController _pageController = PageController();
//   int _currentPage = 0;
//   bool isLiked = false;
//   bool likesFound = false;
//   bool isNotified = false;
//   bool isLoading = true;
//   Product? product;
//   Brand? brand;
//   var textController1 = TextEditingController();
//   var textController2 = TextEditingController();
//   DetailController controller = Get.put(DetailController());
//   ProductsController productsController = Get.put(ProductsController());
//   BrandsController brandsController = Get.put(BrandsController());
//
//   @override
//   void initState() {
//     super.initState();
//     fetchData();
//   }
//
//   void fetchData() async {
//     setState(() {
//       isLoading = true;
//     });
//     brand = await brandsController.fetchBrand(widget.brandId);
//     final String url = "${brand!.url}/products/${widget.productHandle}";
//     product = await productsController.fetchSingleProduct(url);
//
//     if (product != null) {
//       initializeProductLikes(controller);
//     } else {
//       setState(() {
//         isLoading = false;
//       });
//     }
//   }
//
//   void initializeProductLikes(DetailController controller) async {
//     // bool result = await controller.getProductLikes(
//     //     "${brand!.id}_${widget.productHandle}");
//     //
//     // if (result && controller.productLikes.value != null) {
//     //   isLiked = controller.productLikes.value!.userIds
//     //       .contains("${Utils.userId}_${Utils.userToken}");
//     //   likesFound = true;
//     // } else {
//     //   isLiked = false;
//     //   likesFound = false;
//     // }
//     //
//     // if (product != null && product!.variants.isNotEmpty) {
//     //   await controller.comparePrice("${brand!.id}_${widget.productHandle}",
//     //       double.parse(product!.variants.first.price));
//     //   await controller.priceHistoryFunc("${brand!.id}_${widget.productHandle}",
//     //       double.parse(product!.variants.first.price));
//     // }
//     //
//     // if (controller.priceResponse.value != null) {
//     //   this.isNotified = controller.priceResponse.value!.data.userTokens
//     //       .contains("${Utils.userId}_${Utils.userToken}");
//     // }
//     //
//     // setState(() {
//     //   isLoading = false;
//     // });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: controller.isMobWeb ? MobileNavbar() : null,
//       drawer: CustomDrawer(selectedIndex: controller.mobNavbarIndex),
//       body: SafeArea(
//         child: Column(
//           children: [
//             if (kIsWeb && Get.width > 500)
//               NavBar(
//                 selectedIndex: controller.navbarIndex,
//               ),
//             isLoading
//                 ? kIsWeb && Get.width > 500
//                     ? Expanded(
//                         child: Center(
//                         child: CircularProgressIndicator(),
//                       ))
//                     : Expanded(child: ProductDetailShimmer())
//                 : kIsWeb && Get.width > 500
//                     ? _buildProductDetailScreen()
//                     : Expanded(child: _buildProductDetailContent()),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildProductDetailContent() {
//     final int _numPages = product!.images.length;
//     return Stack(
//       children: [
//         Container(
//           color: AppColors.bgColor,
//         ),
//         SingleChildScrollView(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Container(
//                 height: controller.isWeb ? 500 : 400,
//                 child: Stack(
//                   children: [
//                     // Image Carousel
//                     ImagesScroller(
//                     ),
//                     MaterialButtons(isLiked: isLiked),
//                   ],
//                 ),
//               ),
//               SizedBox(
//                 height: 20,
//               ),
//               // Page indicators
//               ProductDescription(brand: brand!, product: product!),
//               SizedBox(
//                 height: 60,
//               )
//             ],
//           ),
//         ),
//         NotificationAlertDialogs(isNotified: isNotified, context: context, textController1: textController1, controller: controller, textController2: textController2),
//         ShopBottomButton(context: context),
//         ImagesIndicators(),
//       ],
//     );
//   }
//
//   Widget _buildProductDetailScreen() {
//     final int _numPages = product!.images.length;
//     return Expanded(
//       child: Row(
//         children: [
//           Expanded(
//             flex: 4,
//             child: Column(
//               children: [
//                 Container(
//                   height: controller.isWeb ? Get.height - 100 : 400,
//                   child: Stack(
//                     children: [
//                       // Image Carousel
//                       WebImagesScroller(),
//                       WebMaterialButtons(isLiked: isLiked),
//                       WebImageIndicators(),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           Expanded(
//             flex: 5,
//             child: Stack(
//               children: [
//                 Container(
//                   color: AppColors.bgColor,
//                 ),
//                 WebProductDescription(brand: brand, product: product),
//                 WebNotificationAlerts(isNotified: isNotified, context: context, controller: controller),
//                 WebShopButton(),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   void _updateNotificationState() {
//     // controller.comparePrice("${widget.brandId}_${widget.productHandle}",
//     //         double.parse(product!.variants.first.price))
//     //     .then((_) {
//     //   setState(() {
//     //     isNotified = controller.priceResponse.value?.data.userTokens
//     //             .contains("${Utils.userId}_${Utils.userToken}") ??
//     //         false;
//     //   });
//     // });
//   }
//
//   @override
//   void dispose() {
//     _pageController.dispose();
//     super.dispose();
//   }
// }
//
//
