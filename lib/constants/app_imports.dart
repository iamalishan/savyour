// Main
export 'package:flutter/material.dart' hide Element;
export 'package:flutter/foundation.dart';
export 'dart:convert';
export 'dart:async';
export 'dart:ui'
    hide
        Image,
        decodeImageFromList,
        TextStyle,
        ImageDecoderCallback,
        Codec,
        Gradient,
        StrutStyle;

// Constants
export './app_imports.dart';
export './app_urls.dart';
export './app_assets.dart';
export './app_colors.dart';
export './app_theme.dart';

// Controllers
export '../controllers/detail_controller.dart';
export '../controllers/user_controller.dart';
export '../controllers/password_alert_controller.dart';
export '../controllers/feeds_controller.dart';

// Features
// // Admin
// export '../features/admin/bindings/admin_home_binding.dart';
// export '../features/admin/bindings/sales_options_binding.dart';
// export '../features/admin/bindings/update_priority_binding.dart';
// export '../features/admin/bindings/web_view_binding.dart';
// export '../features/admin/views/admin_home.dart';
// export '../features/admin/views/sales_options.dart';
// export '../features/admin/views/update_priority_screen.dart';
// export '../features/admin/views/web_view.dart';
//
// Brand
export '../screens/brand/view/brands_screen.dart';
//
// Splash
export '../screens/splash/controller/splash_controller.dart';
export '../screens/splash/view/splash_screen.dart';
//
// Category
export '../screens/category/view/categories_screen.dart';
export '../screens/category/view/category_brands_screen.dart';
//
// Collection
export '../screens/collection/view/collections_screen.dart';
//
// Favorite
export '../screens/favorite/view/favorite_screen.dart';

// Notification
export '../screens/notification/view/notification_screen.dart';

// Search
export '../screens/search/view/search_screen.dart';

// Search In Brand
export '../screens/search_in_brand/view/search_in_brand_view.dart';


// Home
// export '../screens/home/home_binding/home_binding.dart';
export '../screens/home/view/home_screen.dart';

// Product
export '../screens/product_detail/view/product_detail_view.dart';
//
// // Price History
// export '../features/price_history/binding/price_history_binding.dart';
// export '../features/price_history/view/price_history_screen.dart';
//
// Product
export '../screens/product/view/image_detail.dart';
export '../screens/product/view/products_screen.dart';
//
// Sales
export '../screens/sales/view/sales_screen.dart';
//
// Web
export '../screens/web_home/view/web_screen.dart';
// export '../screens/web_product_detail/binding/web_product_detail_binding.dart';
// export '../screens/web_product_detail/view/web_product_detail.dart';

// Firebase Services
export '../firebase_services/get_banners.dart';
export '../firebase_services/get_brands.dart';
export '../firebase_services/get_categories.dart';
export '../firebase_services/get_category_brands.dart';
export '../firebase_services/get_collections.dart';
export '../firebase_services/get_products.dart';
export '../firebase_services/get_sales.dart';
export '../firebase_services/homepage_service.dart';

// Commons
export '../common_widgets/cards/banner_box.dart';
export '../common_widgets/cards/brand_box.dart';
export '../common_widgets/cards/category_box.dart';
export '../common_widgets/cards/product_box.dart';
export '../common_widgets/cards/sale_box.dart';
export '../common_widgets/cards/coupon_box.dart';
export '../common_widgets/cards/small_coupon_box.dart';
export '../common_widgets/cards/featured_collection_box.dart';
export '../common_widgets/widgets/alert.dart';
export '../common_widgets/widgets/button.dart';
export '../common_widgets/widgets/custom_drawer.dart';
export '../common_widgets/widgets/mobile_navbar.dart';
export '../common_widgets/widgets/nav_bar.dart';
export '../common_widgets/widgets/price_history_dialog.dart';
export '../common_widgets/widgets/progress_indicators.dart';
export '../common_widgets/widgets/reuse_text.dart';
export '../common_widgets/widgets/search_field.dart';
export '../common_widgets/widgets/simple_alert.dart';
export '../common_widgets/widgets/sortBy_dropdown.dart';
export '../common_widgets/widgets/cached_image.dart';
export '../common_widgets/widgets/icon_container.dart';
export '../common_widgets/widgets/searched_products_widget.dart';

// Models
export 'package:ecommerce_web/models/app_user_model.dart';
export 'package:ecommerce_web/models/like_model.dart';
export 'package:ecommerce_web/models/collection_model.dart';
export 'package:ecommerce_web/models/brand_model.dart';
export 'package:ecommerce_web/models/product_model.dart';
export 'package:ecommerce_web/models/sale_model.dart';
export 'package:ecommerce_web/models/coupon_model.dart';
export 'package:ecommerce_web/models/notification_model.dart';
export 'package:ecommerce_web/models/feed_model.dart';

// Shimmers
export '../common_widgets/shimmers/banner_shimmer.dart';
export '../common_widgets/shimmers/brand_shimmer.dart';
export '../common_widgets/shimmers/header_shimmer.dart';
export '../common_widgets/shimmers/product_detail_shimmer.dart';
export '../common_widgets/shimmers/product_shimmer.dart';

// Utils
export '../utils/context_util.dart';
export '../utils/links_services.dart';
export '../utils/test.dart';
export '../utils/utils.dart';
export '../utils/extensions.dart';
export '../utils/firebase_analytics_util.dart';

// Routes
export '../routes/app_routes.dart';
export '../routes/app_pages.dart';

// Root level exports
export '../firebase_options.dart';
export '../main.dart';
// export '../screens/splash/view/splash_screen.dart';

// GetX
export 'package:get/get.dart';

// Firebase
export 'package:cloud_firestore/cloud_firestore.dart' hide kIsWasm;
export 'package:firebase_auth/firebase_auth.dart';
export 'package:firebase_messaging/firebase_messaging.dart';
export 'package:firebase_core/firebase_core.dart';
export 'package:firebase_crashlytics/firebase_crashlytics.dart';
export 'package:firebase_analytics/firebase_analytics.dart';

// Others
export 'package:flutter/services.dart';
export 'package:url_launcher/url_launcher.dart';
// export 'package:webview_flutter/webview_flutter.dart';
export 'package:cached_network_image/cached_network_image.dart';
export 'package:share_plus/share_plus.dart';
export 'package:carousel_slider/carousel_slider.dart';
export 'package:shimmer/shimmer.dart';
export 'package:screenshot/screenshot.dart';
export 'package:path_provider/path_provider.dart';
// export 'package:uni_links2/uni_links.dart';
// export 'package:html/dom.dart' hide Node, Text;
export 'package:meta_seo/meta_seo.dart';
export 'package:google_fonts/google_fonts.dart';
export 'package:font_awesome_flutter/font_awesome_flutter.dart';
export 'package:intl/intl.dart' hide TextDirection;
