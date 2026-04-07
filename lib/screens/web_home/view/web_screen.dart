import 'package:ecommerce_web/constants/app_imports.dart';
import 'package:ecommerce_web/common_widgets/widgets/adsense_banner.dart';
import 'package:ecommerce_web/firebase_services/get_coupons.dart';
import 'package:ecommerce_web/screens/web_home/widgets/coupon_section.dart';

import '../widgets/banner_section.dart';
import '../widgets/brand_section.dart';
import '../widgets/category_section.dart';
import '../widgets/sale_section.dart';
import '../widgets/stream_builder_section.dart';

class WebScreen extends StatefulWidget {
  WebScreen({super.key});

  @override
  State<WebScreen> createState() => _WebScreenState();
}

class _WebScreenState extends State<WebScreen> {
  final BannerController bannerController = Get.put(
    BannerController(),
    permanent: true,
  );
  final CategoriesController categoryController = Get.put(
    CategoriesController(),
    permanent: true,
  );
  final BrandsController brandController = Get.put(
    BrandsController(),
    permanent: true,
  );
  final SalesController saleController = Get.put(
    SalesController(),
    permanent: true,
  );
  final CouponsController couponController = Get.put(
    CouponsController(),
    permanent: true,
  );
  final DetailController detailController = Get.put(
    DetailController(),
    permanent: true,
  );

  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    FirebaseAnalyticsUtil.analyticLogEvent(name: 'homepage_view');
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    detailController.determinePlatform(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Container(color: AppColors.bgColor),
            SingleChildScrollView(
              controller: scrollController,
              child: Obx(() {
                return Column(
                  children: [
                    NavBar(selectedIndex: detailController.navbarIndex),
                      BannerSection(bannerController: bannerController)
                          .marginOnly(bottom: 20),
                      CategorySection(categoryController: categoryController)
                          .marginOnly(bottom: 20),
                      BrandSection(brandController: brandController).marginOnly(
                          bottom: 20),
                      SaleSection(saleController: saleController).marginOnly(
                          bottom: 20),
                      CouponSection(couponsController: couponController)
                          .marginOnly(bottom: 20),
                    StreamBuilderSection(),
                  ],
                );
              }),
            ),
            Obx(() {
              if (detailController.isHomeLoading) {
                return Utils.loadingIndicator();
              }
              return const SizedBox.shrink();
            }),
          ],
        ),
      ),
    );
  }
}
