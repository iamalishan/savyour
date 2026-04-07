import 'package:ecommerce_web/constants/app_imports.dart';

class LinksServices {
  static void init() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      DetailController controller = Get.put(DetailController());

      if (kIsWeb) {
        if (Get.width > 500) {
          controller.setIsWeb(true);
        }
        handleWebLinks();
      } else {
        handleMobileLinks();
      }
    });
  }

  // For Web:
  static void handleWebLinks() {
    Uri uri = Uri.base;
    _uniHandler(uri);
  }

  // For Mobile (uni_links):
  static Future<void> handleMobileLinks() async {
    // try {
    //   final Uri? uri = await getInitialUri();
    //   _uniHandler(uri);
    // } on PlatformException catch (e) {
    //   print("Failed to receive the code $e");
    // } on FormatException catch (e) {
    //   print("Wrong format code received $e");
    // }
    //
    // uriLinkStream.listen((Uri? uri) {
    //   _uniHandler(uri);
    // }, onError: (error) {
    //   print("OnUriLinking $error");
    // });
  }

  static void _uniHandler(Uri? uri) {
    if (uri == null) return;

    print('Received URI: $uri');

    List<String> pathSegments = uri.pathSegments;

    if (pathSegments.isEmpty) return;

    String firstSegment = pathSegments[0];
    if (firstSegment == "c" && pathSegments.length >= 3) {
      String collectionHandle = pathSegments[1];
      String brandId = pathSegments[2];

      Get.toNamed("/c/$collectionHandle/$brandId");
    } else if (firstSegment == "p" && pathSegments.length >= 3) {
      String productHandle = pathSegments[1];
      String brandId = pathSegments[2];

      if (kIsWeb && Get.width > 500) {
        print("App Linking Shakir");
        Get.toNamed("/p/$productHandle/$brandId", arguments: {'isWeb': true});
      } else {
        Get.toNamed("/p/$productHandle/$brandId");
      }
    } else if (firstSegment == "b" && pathSegments.length >= 2) {
      String brandId = pathSegments[1];
      Get.toNamed("/b/${brandId}");
    }
  }
}
