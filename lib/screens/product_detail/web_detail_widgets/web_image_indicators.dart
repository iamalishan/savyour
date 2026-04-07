import '../../../constants/app_imports.dart';
import '../controller/product_detail_controller.dart';

class WebImageIndicators extends StatelessWidget {
  WebImageIndicators({
    super.key,
  });

  final ProductDetailController controller = Get.find<
      ProductDetailController>();

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 20,
      left: 0,
      right: 0,
      child: Obx(() {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            controller.numPages.value > 5 ? 5 : controller.numPages.value,
                (index) {
              int adjustedIndex;
              if (controller.numPages.value <= 5) {
                adjustedIndex = index;
              } else if (controller.currentPage.value < 2) {
                adjustedIndex = index;
              } else if (controller.currentPage.value >=
                  controller.numPages.value - 3) {
                adjustedIndex = controller.numPages.value - 5 + index;
              } else {
                adjustedIndex = controller.currentPage.value - 2 + index;
              }
              return CustomIndicator(
                  isActive: adjustedIndex == controller.currentPage.value);
            },
          ),
        );
      }),
    );
  }
}
