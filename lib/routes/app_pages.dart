import 'package:ecommerce_web/screens/coupons/view/coupons_screen.dart';
import 'package:ecommerce_web/screens/feeds/view/feeds_screen.dart';

import '../constants/app_imports.dart';

class AppPages {
  static final routes = [
    // Splash
    GetPage(
      name: AppRoutes.splash,
      page: () => SplashScreen(),
      transition: Transition.rightToLeft,
    ),

    // Home
    GetPage(
      name: AppRoutes.home,
      page: () => HomeScreen(),
      transition: Transition.rightToLeft,
    ),

    GetPage(
      name: AppRoutes.webHome,
      page: () => WebScreen(),
      transition: Transition.rightToLeft,
    ),

    GetPage(
      name: '/p/:productHandle/:brandId',
      page: () => MobProductDetailView(),
      transition: Transition.rightToLeft,
    ),

    GetPage(
      name: '/c/:collectionHandle/:brandId',
      page: () => ProductsScreen(),
      transition: Transition.rightToLeft,
    ),

    GetPage(
      name: '/b/:brandId',
      page: () => CollectionsScreen(),
      transition: Transition.rightToLeft,
    ),

    GetPage(
      name: '/favorite',
      page: () => FavoriteScreen(),
      transition: Transition.rightToLeft,
    ),

    GetPage(
      name: '/search',
      page: () => const SearchScreen(),
      transition: Transition.rightToLeft,
    ),

    GetPage(
      name: '/searchInBrand',
      page: () => SearchInBrandView(),
      transition: Transition.rightToLeft,
    ),

    GetPage(
      name: '/notification',
      page: () => const NotificationScreen(),
      transition: Transition.rightToLeft,
    ),

    GetPage(
      name: AppRoutes.category,
      page: () => const CategoriesScreen(),
      transition: Transition.rightToLeft,
    ),

    GetPage(
      name: AppRoutes.brand,
      page: () => BrandsScreen(),
      transition: Transition.rightToLeft,
    ),

    GetPage(
      name: AppRoutes.sale,
      page: () => SalesScreen(),
      transition: Transition.rightToLeft,
    ),

    GetPage(
      name: AppRoutes.coupon,
      page: () => CouponsScreen(),
      transition: Transition.rightToLeft,
    ),

    GetPage(
      name: AppRoutes.feed,
      page: () => FeedsScreen(),
      transition: Transition.rightToLeft,
    ),
  ];
}
