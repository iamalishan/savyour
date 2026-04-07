import 'package:ecommerce_web/screens/search/search_controller/search_service_controller.dart';
import 'package:ecommerce_web/screens/search_in_brand/controller/search_in_brand_controller.dart';

import '../constants/app_imports.dart';
import '../screens/brand/controller/brand_service_controller.dart';
import '../screens/collection/collection_controller/collection_service_controller.dart';
import '../screens/share_screen_shots/brand_post.dart';
import '../screens/share_screen_shots/collection_post.dart';
import '../screens/share_screen_shots/collection_story.dart';

class NavbarSearchController extends GetxController {

  final detailCon = Get.put(DetailController());

  var isSearchVisible = true.obs;
  var searchHomeTEC = TextEditingController().obs;

  var currentPage = "home".obs;

  var currentBrandId = ''.obs;

  Timer? _debounce;

  String getHintText() {
    switch (currentPage.value) {
      case 'home':
      case 'product':
        return 'Search products and brands...';
      case 'main':
        return 'Search products and brands...';
      case 'brands':
        return 'Search brands...';
      default:
        return 'Search products and brands...';
    }
  }

  void onSubmit(String value) async{
    switch (currentPage.value) {
      case 'home':
      case 'brand':
      case 'collection':
      case 'main':
      case 'product':
        FirebaseAnalyticsUtil.analyticLogEvent(name: 'search_view');
        Get.put(SearchServiceController(), permanent: true);
        Get.toNamed('/search', arguments: {'query': value});
        break;
      case 'brands':
        break;
    }
  }

  void onChanged(String value) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    _debounce = Timer(const Duration(milliseconds: 500), () {
      switch (currentPage.value) {
        case 'search':
        case 'collection':
        case 'brand':
        case 'product':
          final searchCon = Get.put(SearchServiceController());
          searchCon.updateSearch(value);
          break;
        case 'brands':
          Get.put(BrandServiceController()).onSearchChanged(value);
          break;
      }
    });
  }

  void updatePageFromRoute(String route) {
    if(route != "/search"){
      searchHomeTEC.value.clear();
    }
    if (route.startsWith('/b/')) {
      if(!detailCon.isWeb){
        isSearchVisible.value = false;
      }
      currentBrandId.value = route.split('/')[2];
      setCurrentPage('brand');
    } else if (route.startsWith('/c/')) {
      if(!detailCon.isWeb){
        isSearchVisible.value = false;
      }
      currentBrandId.value = route.split('/')[3];
      setCurrentPage('collection');
    } else if (route.startsWith('/p/')) {
      setCurrentPage('product');
    } else if (route == '/brand') {
      setCurrentPage('brands');
    } else if (route == '/search') {
      setCurrentPage('search');
    } else if (route == '/main') {
      setCurrentPage('main');
    } else {
      setCurrentPage('home');
    }
  }

  void setCurrentPage(String page) {
    currentPage.value = page;
  }

  void toggleSearchVisibility() {
    isSearchVisible.value = !isSearchVisible.value;
  }

  @override
  void onClose() {
    searchHomeTEC.value.dispose();
    _debounce?.cancel();
    super.onClose();
  }
}
