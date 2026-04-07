import 'package:ecommerce_web/screens/share_screen_shots/product_post.dart';

import '../../../constants/app_imports.dart';
import '../../share_screen_shots/brand_post.dart';
import '../controller/product_detail_controller.dart';

class NotificationButton extends StatelessWidget {
  NotificationButton({super.key, required this.context});

  final BuildContext context;
  final controller = Get.find<ProductDetailController>();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => GestureDetector(
        onLongPressUp: (){
          if(controller.product!.images.length > 2){
            Get.to(()=> BrandPostScreenShot());
          }
        },
        onTap: controller.isNotified.value
            ? () {
                showDialog(
                  barrierDismissible: false,
                  barrierColor: Colors.black26,
                  context: context,
                  builder: (BuildContext context) {
                    return Obx(() {
                      return ConfirmationAlert(
                        title: "Alert !",
                        isNoButton: true,
                        onFirstTap: () {
                          Get.back();
                        },
                        isLoading: controller.isNotificationLoading.value,
                        subTitle: "Do you want to remove this product?",
                        onSecondTap: () async {
                          await controller.toggleNotification();
                          Get.back();
                        },
                      );
                    });
                  },
                );
              }
            : () {
                showDialog(
                  barrierDismissible: false,
                  barrierColor: Colors.black26,
                  context: context,
                  builder: (BuildContext context) {
                    return Obx(() {
                      return ConfirmationAlert(
                        title: "Information !",
                        isNoButton: true,
                        onFirstTap: () {
                          Get.back();
                        },
                        isLoading: controller.isNotificationLoading.value,
                        subTitle: "Are you sure about getting notification ?",
                        onSecondTap: () async {
                          await controller.toggleNotification();
                          Get.back();
                        },
                      );
                    });
                  },
                );
              },
        child: Material(
          elevation: 10,
          shape: CircleBorder(),
          child: Container(
            height: 40,
            width: 40,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(
              Icons.notifications,
              color: controller.isNotified.value ? Colors.red : Colors.black,
            ),
          ),
        ),
      ),
    );
  }
}
