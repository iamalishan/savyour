import 'dart:math';

import 'package:ecommerce_web/constants/app_imports.dart';
import 'package:ecommerce_web/screens/product/controller/product_service_controller.dart';

import '../../utils/image_download_manager/web_image_downloader.dart';


class CollectionPostScreenShot extends StatefulWidget {
  const CollectionPostScreenShot({super.key});

  @override
  State<CollectionPostScreenShot> createState() =>
      _CollectionPostScreenShotState();
}

class _CollectionPostScreenShotState extends State<CollectionPostScreenShot> {
  final ScreenshotController _screenshotController = ScreenshotController();
  Uint8List? uintImage;

  Future<void> _downloadImage() async {
    try {
      final capturedImage = await _screenshotController.capture(pixelRatio: 2.0);
      if (capturedImage != null) {
        await downloadImageWeb(
          capturedImage,
          'collection_post',
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
      appBar: AppBar(title: const Text("Collection Preview")),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: SingleChildScrollView(
                child: Screenshot(
                  controller: _screenshotController,
                  child: CollectionPost(),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: _downloadImage,
              child: const Text('Download Screenshot'),
            ),
          ),
        ],
      ),
    );
  }
}

class CollectionPost extends StatelessWidget {
  CollectionPost({super.key});

  final collectionCon = Get.put(ProductServiceController());

  List<String> _getFirstThreeImageUrls() {
    final images = <String>[];

    if (collectionCon.fetchedProducts.length >= 3) {
      for (int i = 0; i < 3; i++) {
        final product = collectionCon.fetchedProducts[i];
        if (product.images.isNotEmpty) {
          images.add(product.images.first.src);
        } else {
          images.add('https://via.placeholder.com/300'); // fallback
        }
      }
    } else if (collectionCon.fetchedProducts.isNotEmpty) {
      final firstProductImages = collectionCon.fetchedProducts.first.images;
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

  @override
  Widget build(BuildContext context) {
    final imageUrls = _getFirstThreeImageUrls();

    // Get screen dimensions
    final screenSize = MediaQuery.of(context).size;

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
          // === IMAGES LAYOUT ===
          Padding(
            padding: EdgeInsets.only(bottom: containerSize * 0.09), // Responsive bottom padding
            child: Row(
              children: [
                ...List.generate(3, (index) {
                  return Expanded(
                    child: Padding(
                      padding: EdgeInsets.all(containerSize * 0.014), // Responsive padding
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(containerSize * 0.018), // Responsive border radius
                          color: EcommerceTheme.mainColor.withAlpha(30),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(containerSize * 0.018),
                          child: CachedImage(
                            imageUrl: imageUrls.isNotEmpty
                                ? imageUrls[index]
                                : 'https://via.placeholder.com/300',
                            height: containerSize * 0.74, // Responsive height
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

          // === SCALED IMAGE OVERLAY ===
          Positioned.fill(
            child: Image.asset(
              'assets/images/collectionPost.png',
              width: double.infinity,
              height: double.infinity,
              fit: BoxFit.cover,
            ),
          ),

          // === BOTTOM CONTENT SECTION ===
          Align(
            alignment: Alignment.bottomLeft,
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.all(containerSize * 0.037), // Responsive padding
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
                              imageUrl: collectionCon.brand?.imageUrl,
                              height: containerSize * 0.092, // Responsive size (slightly larger for collection)
                              width: containerSize * 0.092,
                              fit: BoxFit.cover,
                            ),
                          ),
                          SizedBox(width: containerSize * 0.018),
                          ReuseText(
                            title: collectionCon.brand?.name ?? '',
                            fontSize: containerSize * 0.046, // Responsive font size
                            fontWeight: FontWeight.w400,
                          ),
                        ],
                      ),
                      SizedBox(height: containerSize * 0.014),
                      SizedBox(
                        width: containerSize * 0.46, // Responsive width
                        child: ReuseText(
                          title: collectionCon.collection?.title ?? '',
                          fontFamily: GoogleFonts.michroma().fontFamily,
                          fontSize: containerSize * 0.046, // Responsive font size
                          maxLines: 2,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: containerSize * 0.014),
                    ],
                  ),
                  ReuseText(
                    title: 'Savyour.io',
                    fontSize: containerSize * 0.037, // Responsive font size
                    fontFamily: GoogleFonts.michroma().fontFamily,
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