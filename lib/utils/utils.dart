import 'dart:io';

import 'package:ecommerce_web/constants/app_imports.dart';
import 'package:http/http.dart' as http;

import '../screens/product_detail/mob_detail_widgets/webview_screen.dart';


class Utils {
  // App Utils
  static DetailController detailController = Get.put(DetailController());

  static String replaceHyphensWithSpaces(String input) {
    return input.replaceAll('-', ' ');
  }

  static void navigateBasedOnUrl(String brandId, String url, Product? mainProduct) async {
    detailController.setIsHomeLoading(true);

    ProductsController controller = Get.put(ProductsController());

    try {
      if (brandId.isEmpty || url.isEmpty) {
        Get.snackbar('Error', 'Brand ID and URL are required!');
        return;
      }

      DocumentSnapshot brandSnapshot = await FirebaseFirestore.instance
          .collection('brands')
          .doc(brandId)
          .get();

      if (!brandSnapshot.exists) {
        Get.snackbar('Error', 'Brand not found!');
        return;
      }

      Brand brand = Brand.fromFireStore(brandSnapshot);

      if (url.contains('/products/')) {
        await Get.toNamed("/p/${getProductHandle(url)}/${brand.id}",
            arguments: {
              'product': mainProduct,
              'brand': brand,
            }
        );
      }

      if (url.contains('/collections/')) {
        final route = Get.toNamed("/c/${getCollectionHandle(url)}/${brand.id}",
        arguments: {
          'brand': brand,
        }
        );

        // await Get.to(() => ProductsScreen(
        //   brandId: brand.id,
        //   collectionHandle: getCollectionHandle(url),
        // ));
      }
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      detailController.setIsHomeLoading(false);
    }
  }

  static Map<String, String> getBrandIdAndHandle(String id) {
    // Split the id by the underscore
    List<String> parts = id.split('_');

    // Check if the id is properly formatted
    if (parts.length == 2) {
      String brandId = parts[0]; // First part before '_'
      String handle = parts[1]; // Second part after '_'

      // Return both values in a map
      return {
        'brandId': brandId,
        'handle': handle,
      };
    } else if (parts.length == 1) {
      String brandId = id;

      return {'brandId': brandId, 'handle': ""};
    } else {
      throw const FormatException(
          'Invalid id format. Expected format: brandId_handle');
    }
  }

  static String getProductHandle(String url) {
    const String productPrefix = '/products/';

    int startIndex = url.indexOf(productPrefix);

    if (startIndex != -1) {
      startIndex += productPrefix.length;

      return url.substring(startIndex);
    } else {
      return '';
    }
  }

  static String getCollectionHandle(String url) {
    const String collectionPrefix = '/collections/';

    int startIndex = url.indexOf(collectionPrefix);

    if (startIndex != -1) {
      startIndex += collectionPrefix.length;

      return url.substring(startIndex);
    } else {
      return '';
    }
  }

  static String extractCollectionInfo(String url) {
    // Define the substring to search for
    const String delimiter = '/collections/';

    // Find the position of the delimiter
    int index = url.indexOf(delimiter);

    if (index != -1) {
      // Extract the substring before the delimiter
      String beforeDelimiter = url.substring(0, index);

      return beforeDelimiter;
    } else {
      return 'Delimiter not found in the URL';
    }
  }

  static Future<void> handleOnTap(Function navigationFunction) async {
    try {
      await navigationFunction();
    } finally {}
  }

  // User Utils
  static String? userId;
  static String? userToken;

  static Future<void> setUserParameters() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;

      if (user == null) {
        user = (await FirebaseAuth.instance.signInAnonymously()).user;
      }

      userId = user!.uid;

      try {
        userToken = await FirebaseMessaging.instance.getToken();
      } catch (e) {
        print("🔔 Notification permission blocked or denied: $e");
        userToken = null;
      }

      print("✅ User ID: $userId");
      print("✅ Token: ${userToken ?? 'No token (permission denied)'}");

    } catch (e) {
      print("❌ Error in setUserParameters: $e");
    }
  }


  static Future<bool> isValidImage(String url) async {
    try {
      final response = await http.head(Uri.parse(url));
      return response.statusCode == 200;
    } catch (_) {
      return false;
    }
  }

  static Future<void> launchBrandProduct(String baseUrl, FeedModel feed) async {
    final Uri uri = Uri.parse(baseUrl).replace(queryParameters: {
      'utm_source': 'Savyour.io',
      'utm_medium': 'savyour',
      'utm_campaign': 'free_promo'
    });

    if (await canLaunchUrl(uri)) {
      if(kIsWeb){
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      }else if(Platform.isAndroid || Platform.isIOS) {
        // Get.to(()=> WebViewTrackingPage(url: uri.toString(),feed: feed,),);
      }
    } else {
      print('Could not launch $uri');
    }
  }


  static Widget loadingIndicator({
    Color backgroundColor = Colors.black38,
    Color indicatorColor = Colors.white,
  }) {
    return Container(
      width: Get.width,
      height: Get.height,
      color: backgroundColor,
      child: Center(
        child: CircularProgressIndicator(
          color: indicatorColor,
        ),
      ),
    );
  }
}
