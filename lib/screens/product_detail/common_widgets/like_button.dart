import 'package:ecommerce_web/screens/product_detail/controller/product_detail_controller.dart';

import '../../../constants/app_imports.dart';

class LikeButton extends StatelessWidget {
  LikeButton({
    super.key,
  });

  final controller = Get.find<ProductDetailController>();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        controller.toggleLike();
      },
      child: Obx(() {
        return Material(
          elevation: 5,
          shape: CircleBorder(),
          child: Container(
            height: 40,
            width: 40,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: controller.isLikeLoading.value
                ? Padding(
              padding: const EdgeInsets.all(10.0),
              child: Center(
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.red,
                ),
              ),
            )
                : controller.isLiked.value
                ? Icon(Icons.favorite, color: Colors.red)
                : Icon(Icons.favorite_border),
          ),
        );
      }),
    );
  }
}
