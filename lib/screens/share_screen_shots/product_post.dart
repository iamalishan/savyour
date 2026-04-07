import 'dart:math';

import 'package:ecommerce_web/constants/app_imports.dart';
import 'package:ecommerce_web/screens/product_detail/controller/product_detail_controller.dart';

import '../../utils/image_download_manager/web_image_downloader.dart';

class ProductPostScreenShot extends StatefulWidget {
  const ProductPostScreenShot({super.key});

  @override
  State<ProductPostScreenShot> createState() =>
      _ProductPostScreenShotState();
}

class _ProductPostScreenShotState extends State<ProductPostScreenShot> {
  final ScreenshotController _screenshotController = ScreenshotController();
  Uint8List? uintImage;

  Future<void> _downloadImage() async {
    try {
      final capturedImage = await _screenshotController.capture(
          pixelRatio: 2.0);
      if (capturedImage != null) {
        await downloadImageWeb(
          capturedImage,
          'product_post',
        );
      } else {
        print('Screenshot capture returned null.');
      }
    } catch (e) {
      print('Error downloading image: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Post Preview")),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: SingleChildScrollView(
                child: Screenshot(
                  controller: _screenshotController,
                  child: ProductPost(),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: _downloadImage,
              child: const Text('Share Screenshot'),
            ),
          ),
        ],
      ),
    );
  }
}

class ProductPost extends StatelessWidget {
  ProductPost({super.key});

  final productCon = Get.put(ProductDetailController());

  @override
  Widget build(BuildContext context) {
    // Get screen dimensions
    final screenSize = MediaQuery
        .of(context)
        .size;

    // Calculate container size based on 1:1 aspect ratio (square)
    // Use the smaller dimension to ensure it fits on screen
    double containerSize = min(screenSize.width * 0.9, screenSize.height * 0.8);

    // Ensure minimum readable size
    if (containerSize < 300) {
      containerSize = 300;
    }

    return Container(
      height: containerSize,
      width: containerSize,
      color: EcommerceTheme.mainColor.withAlpha(20),
      child: Stack(
        fit: StackFit.expand,
        children: [
          Padding(
            padding: EdgeInsets.only(bottom: containerSize * 0.09),
            child: Row(
              children: [
                ...List.generate(3, (index) {
                  return Expanded(
                    child: Padding(
                      padding: EdgeInsets.all(containerSize * 0.014),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                              containerSize * 0.018),
                          color: EcommerceTheme.mainColor.withAlpha(30),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(
                              containerSize * 0.018),
                          child: CachedImage(
                            imageUrl: productCon.product!.images.isNotEmpty &&
                                productCon.product!.images.length > index
                                ? productCon.product!.images[index].src
                                : 'https://via.placeholder.com/300',
                            height: containerSize * 0.74,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),

          Positioned.fill(
            child: Image.asset(
              'assets/images/collectionPost.png',
              width: double.infinity,
              height: double.infinity,
              fit: BoxFit.cover,
            ),
          ),

          Align(
            alignment: Alignment.bottomLeft,
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.all(containerSize * 0.037),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          ClipOval(
                            child: CachedImage(
                              imageUrl: productCon.brand?.imageUrl,
                              height: containerSize * 0.065,
                              width: containerSize * 0.065,
                              fit: BoxFit.cover,
                            ),
                          ),
                          SizedBox(width: containerSize * 0.018),
                          ReuseText(
                            title: productCon.brand?.name ?? '',
                            fontSize: containerSize * 0.046,
                            fontWeight: FontWeight.w400,
                          ),
                        ],
                      ),
                      SizedBox(height: containerSize * 0.014),
                      SizedBox(
                        width: containerSize * 0.46,
                        child: ReuseText(
                          title: productCon.product?.title ?? '',
                          fontFamily: GoogleFonts
                              .michroma()
                              .fontFamily,
                          fontSize: containerSize * 0.037,
                          maxLines: 2,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: containerSize * 0.014),
                    ],
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ReuseText(
                        title: "Rs: ${productCon.product!.variants.first
                            .price}",
                        fontSize: containerSize * 0.035,
                        fontWeight: FontWeight.w900,
                        fontColor: Colors.red,
                      ),
                      if (productCon.product!.variants.first.compareAtPrice !=
                          null &&
                          productCon.product!
                              .variants.first.compareAtPrice!
                              .trim()
                              .toString()
                              .isNotEmpty)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            ReuseText(
                              title:
                              "Rs: ${productCon.product!.variants.first
                                  .compareAtPrice}",
                              fontSize: containerSize * 0.023,
                              decoration: TextDecoration.lineThrough,
                            ),
                            SizedBox(width: containerSize * 0.005),
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.red.withOpacity(0.3),
                                borderRadius: BorderRadius.circular(
                                    containerSize * 0.005),
                              ),
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: containerSize * 0.004,
                                  vertical: containerSize * 0.002,
                                ),
                                child: ReuseText(
                                  title:
                                  "-${productCon.product!.variants.first
                                      .discount}%",
                                  fontColor: Colors.red,
                                  fontSize: containerSize * 0.018,
                                ),
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                  ReuseText(
                    title: 'Savyour.io',
                    fontSize: containerSize * 0.037,
                    fontFamily: GoogleFonts
                        .michroma()
                        .fontFamily,
                    fontWeight: FontWeight.bold,
                    fontColor: EcommerceTheme.mainColor,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}