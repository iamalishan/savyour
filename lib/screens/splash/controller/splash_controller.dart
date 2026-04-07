import 'package:ecommerce_web/constants/app_imports.dart';

class SplashController extends GetxController {
  void navigateBasedOnScreenSize(BuildContext context) {
    DetailController detailController = Get.put(DetailController());

    double width = MediaQuery.of(context).size.width;

    if (width > 500) {
      detailController.setIsWeb(true);
      Get.toNamed(AppRoutes.webHome);
    } else {
      detailController.setIsMobWeb(width <= 500 && kIsWeb);
      Get.offNamed(AppRoutes.home);
    }
  }
}
