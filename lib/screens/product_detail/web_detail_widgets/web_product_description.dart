import 'package:ecommerce_web/screens/product_detail/common_widgets/notification_button.dart';

import '../../../common_widgets/widgets/hover_scale_wrapper.dart';
import '../../../common_widgets/widgets/price_history_graph.dart';
import '../../../constants/app_imports.dart';
import '../common_widgets/like_button.dart';
import '../common_widgets/share_button.dart';
import '../controller/product_detail_controller.dart';

class WebProductDescription extends StatelessWidget {
  WebProductDescription({super.key});

  final controller = Get.find<ProductDetailController>();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ReuseText(
            title: controller.product?.title ?? '',
            fontWeight: FontWeight.bold,
          ),
          if (controller.product?.vendor != null)
            ReuseText(title: controller.product!.vendor!),
          SizedBox(height: 20),
          SizedBox(
            width: Get.width / 2 - 40,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                    Get.toNamed("/b/${controller.brand!.id}");
                  },
                  child: Row(
                    children: [
                      ClipOval(
                        child:   controller.brand!.imageBase64 != null?
                        Image.memory(
                          base64Decode(controller.brand!.imageBase64!),
                          height: 50,
                          width: 50,
                          fit: BoxFit.cover,
                        ):CachedNetworkImage(
                          imageUrl: controller.brand!.imageUrl ?? '',
                          placeholder: (context, url) => Image.asset(
                            "assets/images/placeholderImage.png",
                            fit: BoxFit.fitHeight,
                            height: 50,
                            width: 50,
                          ),
                          errorWidget: (context, url, error) => Image.asset(
                            "assets/images/placeholderImage.png",
                            fit: BoxFit.cover,
                            height: 50,
                            width: 50,
                          ),
                          fit: BoxFit.cover,
                          height: 50,
                          width: 50,
                        ),
                      ),
                      SizedBox(width: 10),
                      ReuseText(
                        title: controller.brand?.name ?? '',
                        fontWeight: FontWeight.bold,
                      ),
                    ],
                  ),
                ),
                Column(
                  children: [
                    ReuseText(
                      title: "Rs: ${controller.product!.variants.first.price}",
                      fontSize: 16,
                      fontWeight: FontWeight.w900,
                      fontColor: Colors.red,
                    ),
                    if (controller.product!.variants.first.compareAtPrice !=
                            null &&
                        controller.product!.variants.first.compareAtPrice!
                            .trim()
                            .toString()
                            .isNotEmpty)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          ReuseText(
                            title:
                                "Rs: ${controller.product!.variants.first.compareAtPrice}",
                            fontSize: 11,
                            decoration: TextDecoration.lineThrough,
                          ),
                          SizedBox(width: 5),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.red.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: ReuseText(
                              title:
                                  "-${controller.product!.variants.first.discount}%",
                              fontColor: Colors.red,
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 20),
          SizedBox(
            width: Get.width / 2 - 40,
            child: Obx(() {
              return Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  // ShareButton(),
                  // SizedBox(width: 10),
                  NotificationButton(context: context),
                  SizedBox(width: 10),
                  LikeButton(),
                  SizedBox(width: 10),
                  ReuseText(
                    title:
                        "${controller.fbProduct.value?.userLikedList.length ?? 0}",
                    fontColor: Colors.red,
                    fontWeight: FontWeight.w800,
                  ),
                ],
              );
            }),
          ),
          SizedBox(height: 20),
          if(controller.brandCoupons.isNotEmpty)
          ...[
          ReuseText(
            title: "Brand Coupons:",
            fontSize: 20,
            fontWeight: FontWeight.w900,
          ),
          SizedBox(height: 10),
            SizedBox(
              height: 65,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: controller.brandCoupons.length,
                itemBuilder: (context, index) {
                  final coupon = controller.brandCoupons[index];
                  return SmallCouponBox(coupon: coupon).marginOnly(right: 10);
                },
              ),
            ),
            SizedBox(height: 10),
          ],
          ReuseText(
            title: "Price History",
            fontSize: 20,
            fontWeight: FontWeight.w900,
          ),
          SizedBox(height: 20),
          Visibility(
            visible:
                controller.product!.variants.first.compareAtPrice == null ||
                controller.product!.variants.first.compareAtPrice ==
                    controller.product!.variants.first.price ||
                controller.product!.variants.first.compareAtPrice!
                    .trim()
                    .isEmpty,
            child: ReuseText(
              title: "We don't have any price history for this product yet.",
            ),
          ),
          Visibility(
            visible:
                controller.product!.variants.first.compareAtPrice != null &&
                controller.product!.variants.first.compareAtPrice !=
                    controller.product!.variants.first.price &&
                controller.product!.variants.first.compareAtPrice!
                    .trim()
                    .isNotEmpty,
            child: SizedBox(
              height: 200,
              width: Get.width / 2 - 40,
              child: LineChartPrice(
                product: controller.product!,
                fbProductModel: controller.fbProduct.value!,
              ),
            ),
          ),
          SizedBox(height: 20),
          ReuseText(
            title: "Description",
            fontSize: 20,
            fontWeight: FontWeight.w900,
          ),
          SizedBox(height: 10),
          if (controller.product!.productType.toString().trim().isNotEmpty)
            SizedBox(
              width: Get.width / 2,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ReuseText(title: "Type", fontWeight: FontWeight.bold),
                  ReuseText(title: controller.product!.productType!),
                ],
              ),
            ),
          SizedBox(height: 10),
          SizedBox(
            width: Get.width / 2,
            child: ReuseText(title: controller.product!.description.trim()),
          ),
          if (controller.relatedProducts.isNotEmpty) ...[
            SizedBox(height: 20),
            ReuseText(
              title: "Recommended Products",
              fontSize: 20,
              fontWeight: FontWeight.w900,
            ),
            SizedBox(height: 20),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                mainAxisExtent: controller.controller.isWeb ? 350 : 300,
              ),
              itemCount: controller.relatedProducts.length,
              itemBuilder: (context, index) {
                final product = controller.relatedProducts[index];
                return GestureDetector(
                  onTap: () {
                    Get.toNamed(
                      "/p/${product.handle}/${controller.brand!.id}",
                      arguments: {
                        "product": product,
                        "brand": controller.brand,
                        "collection": null,
                      },
                    );
                  },
                  child: ProductBox(
                    title: product.title,
                    description: product.description.toString().trim().isEmpty
                        ? null
                        : product.description.toString().trim(),
                    newPrice: product.variants.first.price,
                    oldPrice: product.variants.first.compareAtPrice,
                    discount: product.variants.first.discount ?? 0,
                    netImg: product.images.first.src,
                  ),
                );
              },
            ),
          ],
          SizedBox(height: 20),
        ],
      ),
    );
  }
}
