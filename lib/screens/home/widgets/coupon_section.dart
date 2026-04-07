import 'package:ecommerce_web/constants/app_imports.dart';
import 'package:ecommerce_web/firebase_services/get_coupons.dart';
import 'package:ecommerce_web/screens/web_home/widgets/section_header.dart';

import '../../../common_widgets/cards/coupon_box.dart';

class CouponSection extends StatelessWidget {
  final CouponsController couponsController;
  final VoidCallback onViewAll;

  const CouponSection({super.key, required this.couponsController,
    required this.onViewAll,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (couponsController.isLoading.value) {
        return const BrandShimmer();
      } else if (couponsController.coupons.isEmpty) {
        return const SizedBox.shrink();
      }
      final coupons = couponsController.coupons;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeader(
            title: "Coupons",
            onViewAll: () => Get.toNamed(AppRoutes.coupon),
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 170,
            child: ListView.builder(
              shrinkWrap: true,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              scrollDirection: Axis.horizontal,
              itemCount: coupons.length,
              itemBuilder: (context, index) {
                final coupon = coupons[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: CouponBox(
                    coupon: coupon,
                    onTap: (){
                      Get.toNamed("/b/${coupon.brandId}", arguments: {"brand": null});
                    },
                  ),
                );
              },
            ),
          ),
        ],
      );
    });
  }

  Widget _buildSectionHeader(String title, {required VoidCallback onViewAll}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          TextButton(
            onPressed: onViewAll,
            child: const Text("View All"),
          ),
        ],
      ),
    );
  }
}
