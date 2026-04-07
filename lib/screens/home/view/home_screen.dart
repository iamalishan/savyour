import 'package:ecommerce_web/constants/app_imports.dart';
import 'package:ecommerce_web/firebase_services/get_coupons.dart';
import 'package:ecommerce_web/screens/home/widgets/coupon_section.dart';

import '../widgets/banner_section.dart';
import '../widgets/brand_section.dart';
import '../widgets/category_section.dart';
import '../widgets/sale_section.dart';
import '../widgets/stream_builder_section.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final BannerController bannerController = Get.put(BannerController());
  final CategoriesController categoryController = Get.put(
    CategoriesController(),
  );
  final BrandsController brandController = Get.put(BrandsController());
  final SalesController saleController = Get.put(SalesController());
  final CouponsController couponController = Get.put(CouponsController());
  final DetailController detailController = Get.put(DetailController());
  final HomeController homeController = Get.put(HomeController());

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
      appBar: detailController.isMobWeb ? MobileNavbar() : null,
      drawer: CustomDrawer(selectedIndex: detailController.mobNavbarIndex),
      body: SafeArea(
        child: Stack(
          children: [
            Container(color: AppColors.bgColor),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // Padding(
                    //   padding: const EdgeInsets.symmetric(horizontal: 15),
                    //   child: Row(
                    //     children: [
                    //       // const Expanded(
                    //       //   child: SearchField(
                    //       //     hintText: "Brands, Categories & Sales",
                    //       //   ),
                    //       // ),
                    //       // if (!detailController.isMobWeb)
                    //       //   const SizedBox(width: 10),
                    //       // if (!detailController.isMobWeb)
                    //       //   GestureDetector(
                    //       //     onTap: () {
                    //       //       // Get.to(const FavoriteScreen());
                    //       //     },
                    //       //     child: Container(
                    //       //       height: 45,
                    //       //       width: 45,
                    //       //       decoration: BoxDecoration(
                    //       //         color: EcommerceTheme.primaryColor,
                    //       //         borderRadius: BorderRadius.circular(15),
                    //       //       ),
                    //       //       child: const Icon(
                    //       //         Icons.favorite_border,
                    //       //         color: Colors.grey,
                    //       //       ),
                    //       //     ),
                    //       //   ),
                    //     ],
                    //   ),
                    // ),
                    // const SizedBox(height: 20),
                    BannerSection(
                      homeController: homeController,
                      bannerController: bannerController,
                    ).marginOnly(bottom: 20),
                    CategorySection(
                      categoryController: categoryController,
                      onViewAll: () => Get.toNamed(AppRoutes.category),
                    ).marginOnly(bottom: 20),
                    BrandSection(
                      brandController: brandController,
                      onViewAll: () => Get.toNamed(AppRoutes.brand),
                    ).marginOnly(bottom: 20),
                    SaleSection(
                      saleController: saleController,
                      onViewAll: () => Get.toNamed(AppRoutes.sale),
                    ).marginOnly(bottom: 20),
                    CouponSection(
                      couponsController: couponController,
                      onViewAll: () => Get.toNamed(AppRoutes.coupon),
                    ).marginOnly(bottom: 20),
                    HomePageStreamBuilderSection(
                      homeController: homeController,
                    ),
                  ],
                ),
              ),
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
