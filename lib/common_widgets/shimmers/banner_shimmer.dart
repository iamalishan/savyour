import 'package:ecommerce_web/constants/app_imports.dart';

class BannerShimmer extends StatelessWidget {
  BannerShimmer({super.key});

  final DetailController detailController = Get.put(DetailController());

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: detailController.isWeb ? Get.height / 2 : 280,
      child: Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.white,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.grey.shade300,
            // borderRadius: BorderRadius.circular(20),
          ),
        ),
      ),
    );
  }
}
