import 'dart:math';

import 'package:ecommerce_web/constants/app_imports.dart';
import 'package:ecommerce_web/screens/product/controller/product_service_controller.dart';

import '../../utils/image_download_manager/web_image_downloader.dart';


class CollectionScreenShot extends StatefulWidget {
  const CollectionScreenShot({super.key});

  @override
  State<CollectionScreenShot> createState() => _CollectionScreenShotState();
}

class _CollectionScreenShotState extends State<CollectionScreenShot> {
  final ScreenshotController _screenshotController = ScreenshotController();
  Uint8List? uintImage;

  Future<void> _downloadImage() async {
    try {
      final capturedImage = await _screenshotController.capture(pixelRatio: 2.0);
      if (capturedImage != null) {
        await downloadImageWeb(
          capturedImage,
          'collection_story',
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
                  child: CollectionStory(),
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

class CollectionStory extends StatelessWidget {
  CollectionStory({super.key});

  final collectionCon = Get.put(ProductServiceController());

  /// Helper function to extract first 5 available images from all products
  List<String> _getFirstFiveImageUrls() {
    final allImages = <String>[];

    for (var product in collectionCon.fetchedProducts) {
      for (var img in product.images) {
        allImages.add(img.src);
        if (allImages.length == 5) return allImages;
      }
    }

    // Fill with placeholders if not enough images
    while (allImages.length < 5) {
      allImages.add('https://via.placeholder.com/300');
    }

    return allImages;
  }

  @override
  Widget build(BuildContext context) {
    // Get screen dimensions
    final screenSize = MediaQuery.of(context).size;

    // Calculate container size based on 9:16 aspect ratio
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

    final imageUrls = _getFirstFiveImageUrls();

    return Container(
      height: containerHeight,
      width: containerWidth,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            EcommerceTheme.mainColor,
            Colors.grey.shade200,
            Colors.grey.shade200,
            EcommerceTheme.mainColor,
          ],
        ),
      ),
      padding: EdgeInsets.all(containerWidth * 0.015), // Responsive padding
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Column(
              children: [
                // Big image (first from list)
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(containerWidth * 0.015),
                    child: CachedImage(
                      width: double.infinity,
                      imageUrl: imageUrls.isNotEmpty
                          ? imageUrls[0]
                          : 'https://via.placeholder.com/300',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.all(containerWidth * 0.014),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ClipOval(
                          child: Container(
                            height: containerWidth * 0.1,
                            width: containerWidth * 0.1,
                            child: CachedImage(
                              imageUrl: collectionCon.brand?.imageUrl ?? 'https://via.placeholder.com/70',
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        SizedBox(height: containerHeight * 0.03),
                        ReuseText(
                          title: collectionCon.brand?.name ?? '',
                          fontSize: containerWidth * 0.02,
                          fontFamily: GoogleFonts.michroma().fontFamily,
                        ),
                        SizedBox(height: containerHeight * 0.03),
                        SizedBox(
                          width: double.infinity,
                          child: Center(
                            child: ReuseText(
                              fontFamily: GoogleFonts.michroma().fontFamily,
                              title: collectionCon.collection?.title ?? '',
                              fontSize: containerWidth * 0.04,
                              fontWeight: FontWeight.bold,
                              maxLines: 2,
                            ),
                          ),
                        ),
                        SizedBox(height: containerHeight * 0.04),
                        ReuseText(
                          title: 'SAVYOUR.IO',
                          fontWeight: FontWeight.w900,
                          fontSize: containerWidth * 0.03,
                          fontFamily: GoogleFonts.michroma().fontFamily,
                          fontColor: EcommerceTheme.mainColor,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: containerWidth * 0.009),
          Expanded(
            flex: 2,
            child: Column(
              children: List.generate(
                min(4, imageUrls.length - 1), // Remaining 4 images
                    (index) => Expanded(
                  child: Container(
                    margin: EdgeInsets.only(bottom: containerHeight * 0.003),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(containerWidth * 0.01),
                      child: CachedImage(
                        imageUrl: imageUrls.length > (index + 1)
                            ? imageUrls[index + 1]
                            : 'https://via.placeholder.com/300',
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}