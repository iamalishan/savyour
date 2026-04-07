import 'dart:math';
import 'package:ecommerce_web/constants/app_imports.dart';
import 'package:ecommerce_web/screens/collection/collection_controller/collection_service_controller.dart';

import '../../utils/image_download_manager/web_image_downloader.dart';
class BrandPostScreenShot extends StatefulWidget {
  const BrandPostScreenShot({super.key});

  @override
  State<BrandPostScreenShot> createState() => _BrandPostScreenShotState();
}

class _BrandPostScreenShotState extends State<BrandPostScreenShot> {
  final ScreenshotController _screenshotController = ScreenshotController();
  Uint8List? uintImage;

  Future<void> _downloadImage() async {
    try {
      final capturedImage = await _screenshotController.capture(pixelRatio: 2.0);
      if (capturedImage != null) {
        await downloadImageWeb(
          capturedImage,
          'brand_post',
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
      appBar: AppBar(title: const Text("Brand Post Preview")),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: SingleChildScrollView(
                child: Screenshot(
                  controller: _screenshotController,
                  child: BrandPost(),
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

class BrandPost extends StatelessWidget {
  BrandPost({super.key});

  final collectionCon = Get.put(CollectionServiceController());

  List<String> _getValidCollectionImages(int count) {
    final validImages = collectionCon.fetchedCollections
        .map((c) => c.image)
        .where((img) => img != null && img!.isNotEmpty)
        .cast<String>()
        .toList();

    return validImages.take(count).toList();
  }

  @override
  Widget build(BuildContext context) {
    final validImages = _getValidCollectionImages(6);

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
          GridView.builder(
            itemCount: 6,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 0.75
            ),
            itemBuilder: (context, index) {
              final imageUrl = index < validImages.length
                  ? validImages[index]
                  : 'https://via.placeholder.com/300';

              return CachedImage(imageUrl: imageUrl);
            },
          ),
          Container(
            height: containerSize,
            width: containerSize,
            decoration: BoxDecoration(
              gradient: RadialGradient(
                colors: [Colors.black45, Colors.white54],
                center: Alignment(0, -0.38),
                radius: 0.2,
              ),
            ),
          ),

          Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: containerSize * 0.23, // Responsive height (250/1080)
                  width: containerSize * 0.23, // Responsive width (250/1080)
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(containerSize * 0.018) // Responsive border radius (20/1080)
                  ),
                  child: CachedImage(imageUrl: collectionCon.brand?.imageUrl),
                ),
                SizedBox(height: containerSize * 0.028), // Responsive spacing (30/1080)
                ReuseText(
                  title: collectionCon.brand?.name ?? '',
                  fontSize: containerSize * 0.065, // Responsive font size (70/1080)
                  fontFamily: GoogleFonts.michroma().fontFamily,
                  fontWeight: FontWeight.bold,
                  fontColor: Colors.black,
                ),
                SizedBox(height: containerSize * 0.185), // Responsive spacing (200/1080)
                ReuseText(
                  title: 'Savyour.io',
                  fontSize: containerSize * 0.037, // Responsive font size (40/1080)
                  fontFamily: GoogleFonts.michroma().fontFamily,
                  fontWeight: FontWeight.bold,
                  fontColor: EcommerceTheme.mainColor,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}