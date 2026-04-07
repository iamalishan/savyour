import 'package:ecommerce_web/constants/app_imports.dart';
import 'package:ecommerce_web/screens/product_detail/controller/product_detail_controller.dart';

import '../../common_widgets/widgets/price_history_graph.dart';
import '../../utils/image_download_manager/web_image_downloader.dart';

class ProductStoryScreen extends StatefulWidget {
  const ProductStoryScreen({super.key});

  @override
  State<ProductStoryScreen> createState() => _ProductStoryScreenState();
}

class _ProductStoryScreenState extends State<ProductStoryScreen> {
  final ScreenshotController _screenshotController = ScreenshotController();
  Uint8List? uintImage;

  Future<void> _downloadImage() async {
    try {
      final capturedImage = await _screenshotController.capture(pixelRatio: 2.0);
      if (capturedImage != null) {
        await downloadImageWeb(
          capturedImage,
          'product_story',
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
      appBar: AppBar(title: const Text("Product Preview")),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: SingleChildScrollView(
                child: Screenshot(
                  controller: _screenshotController,
                  child: ProductStory(),
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

class ProductStory extends StatelessWidget {
  ProductStory({super.key});

  final productDetailCon = Get.put(ProductDetailController());

  @override
  Widget build(BuildContext context) {
    // Get screen dimensions
    final screenSize = MediaQuery.of(context).size;

    // Calculate container size based on 9:16 aspect ratio
    // Use screen width if it fits, otherwise scale down
    double containerWidth = screenSize.width * 0.9; // 90% of screen width for padding
    double containerHeight = containerWidth * (16 / 9); // 9:16 aspect ratio

    // If height is too big for screen, scale down based on height
    if (containerHeight > screenSize.height * 0.8) {
      containerHeight = screenSize.height * 0.8;
      containerWidth = containerHeight * (9 / 16);
    }

    // Ensure minimum readable size
    if (containerWidth < 300) {
      containerWidth = 300;
      containerHeight = containerWidth * (16 / 9);
    }

    return Container(
      width: containerWidth,
      height: containerHeight,
      decoration: BoxDecoration(
        color: Colors.white,
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            EcommerceTheme.mainColor.withAlpha(70),
            Colors.grey.shade200,
            Colors.grey.shade200,
            EcommerceTheme.mainColor.withAlpha(70),
          ],
        ),
      ),
      padding: EdgeInsets.all(containerWidth * 0.02), // Responsive padding
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ReuseText(
            title: productDetailCon.product?.title ?? '',
            fontSize: containerWidth * 0.055, // Responsive font size
            fontFamily: GoogleFonts.michroma().fontFamily,
            fontWeight: FontWeight.bold,
            maxLines: 2,
          ),
          SizedBox(height: containerHeight * 0.01),
          Expanded(
            flex: 5,
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      Row(
                        children: [
                          ClipOval(
                            child: SizedBox(
                              height: containerWidth * 0.18,
                              width: containerWidth * 0.18,
                              child: CachedImage(
                                imageUrl: productDetailCon.brand?.imageUrl ?? '',
                              ),
                            ),
                          ),
                          SizedBox(width: containerWidth * 0.03),
                          Expanded(
                            child: ReuseText(
                              title: productDetailCon.brand?.name ?? '',
                              fontSize: containerWidth * 0.037,
                              fontFamily: GoogleFonts.michroma().fontFamily,
                              fontWeight: FontWeight.bold,
                              maxLines: 1,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: containerHeight * 0.015),
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.only(
                            bottomRight: Radius.circular(containerWidth * 0.18),
                          ),
                          child: CachedImage(
                            imageUrl:
                            productDetailCon.product?.images
                                .where(
                                  (img) =>
                              img.src != null &&
                                  img.src.trim().isNotEmpty,
                            )
                                .toList()
                                .elementAtOrNull(0)
                                ?.src ??
                                '',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: containerWidth * 0.005),
                Expanded(
                  child: Column(
                    children: [
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(containerWidth * 0.18),
                          ),
                          child: CachedImage(
                            imageUrl:
                            productDetailCon.product?.images
                                .where(
                                  (img) =>
                              img.src != null &&
                                  img.src.trim().isNotEmpty,
                            )
                                .toList()
                                .elementAtOrNull(1)
                                ?.src ??
                                '',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      SizedBox(height: containerHeight * 0.015),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              if (productDetailCon
                                  .product!
                                  .variants
                                  .first
                                  .discount !=
                                  null)
                                ReuseText(
                                  title:
                                  "${productDetailCon.product!.variants.first.discount}% OFF",
                                  fontColor: Colors.red,
                                  fontSize: containerWidth * 0.028,
                                  fontFamily: GoogleFonts.michroma().fontFamily,
                                  fontWeight: FontWeight.bold,
                                ),
                              Column(
                                children: [
                                  ReuseText(
                                    title:
                                    "Rs: ${productDetailCon.product!.variants.first.price}",
                                    fontSize: containerWidth * 0.023,
                                    fontFamily: GoogleFonts.michroma().fontFamily,
                                    fontWeight: FontWeight.w900,
                                    fontColor: Colors.red,
                                  ),
                                  SizedBox(height: containerHeight * 0.002),
                                  if (productDetailCon
                                      .product!
                                      .variants
                                      .first
                                      .compareAtPrice
                                      .toString()
                                      .isNotEmpty)
                                    ReuseText(
                                      title:
                                      "Rs: ${productDetailCon.product!.variants.first.compareAtPrice}",
                                      fontSize: containerWidth * 0.026,
                                      decoration: TextDecoration.lineThrough,
                                    ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: containerHeight * 0.04),

          // Price History Graph
          if (productDetailCon.product!.variants.first.compareAtPrice != null)
            Expanded(
              flex: 2,
              child: LineChartPrice(
                product: productDetailCon.product!,
                fbProductModel: productDetailCon.fbProduct.value!,
                fontSize: containerWidth * 0.028,
              ),
            ),
        ],
      ),
    );
  }
}