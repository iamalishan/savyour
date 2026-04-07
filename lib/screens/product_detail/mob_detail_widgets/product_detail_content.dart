import 'package:ecommerce_web/screens/product_detail/mob_detail_widgets/product_description.dart';
import 'package:ecommerce_web/screens/product_detail/mob_detail_widgets/shop_bottom_button.dart';

import '../../../constants/app_imports.dart';
import '../controller/product_detail_controller.dart';
import 'image_indicators.dart';
import 'images_scroller.dart';

class MobProductDetailContent extends StatelessWidget {
  MobProductDetailContent({
    super.key,
  });

  final ProductDetailController controller = Get.find<ProductDetailController>();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(color: AppColors.bgColor),
        SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: controller.controller.isWeb ? 500 : 400,
                child: Stack(
                  children: [
                    ImagesScroller(),
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
                    ImagesIndicators(),
                  ],
                ),
              ),
              SizedBox(height: 20),
              // Page indicators
              ProductDescription(),
              SizedBox(height: 60),
            ],
          ),
        ),
        ShopBottomButton(context: context),],
    );
  }
}
