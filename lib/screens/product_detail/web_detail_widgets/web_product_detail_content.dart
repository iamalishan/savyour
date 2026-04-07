import 'package:ecommerce_web/screens/product_detail/web_detail_widgets/web_image_indicators.dart';
import 'package:ecommerce_web/screens/product_detail/web_detail_widgets/web_images_scroller.dart';
import 'package:ecommerce_web/screens/product_detail/web_detail_widgets/web_product_description.dart';
import 'package:ecommerce_web/screens/product_detail/web_detail_widgets/web_shop_button.dart';

import '../../../constants/app_imports.dart';
import '../controller/product_detail_controller.dart';

class WebProductDetailContent extends StatelessWidget {
  WebProductDetailContent({
    super.key,
  });

  final ProductDetailController controller = Get.find<ProductDetailController>();

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Row(
        children: [
          Expanded(
            flex: 5,
            child: Column(
              children: [
                SizedBox(
                  height: controller.controller.isWeb ? Get.height - 70 : 400,
                  child: Stack(
                    children: [
                      // Image Carousel
                      WebImagesScroller(),
                      Padding(
                        padding: const EdgeInsets.all(15),
                        child: GestureDetector(
                          onTap: () {
                            Get.back();
                          },
                          child: Material(
                            elevation: 5,
                            shape: CircleBorder(),
                            child: Container(
                              height: 40,
                              width: 40,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Icon(Icons.arrow_back),
                            ),
                          ),
                        ),
                      ),
                      WebImageIndicators(),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 5,
            child: Container(
              color: AppColors.bgColor,
              child: Column(
                children: [
                  // Scrollable description content
                  Expanded(
                    child: SingleChildScrollView(
                      child: WebProductDescription(),
                    ),
                  ),
                  // Fixed shop button at bottom
                  WebShopButton(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
