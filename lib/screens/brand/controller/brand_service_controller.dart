import 'dart:async';
import 'package:ecommerce_web/constants/app_imports.dart';

import '../../../controllers/navbar_search_controller.dart';

class BrandServiceController extends GetxController {
  final ScrollController scrollController = ScrollController();

  RxList<Brand> loadedBrands = <Brand>[].obs;
  RxList<Brand> searchedBrands = <Brand>[].obs;
  RxBool isLoading = false.obs;
  RxBool hasMore = true.obs;
  RxString searchText = ''.obs;
  RxInt limit = 20.obs;

  final bool isWeb;
  Timer? _debounce;

  BrandServiceController({this.isWeb = false}) {
    limit.value = isWeb ? 40 : 20;
    _initScrollListener();
  }

  void _initScrollListener() {
    scrollController.addListener(() {
      if (scrollController.offset >= scrollController.position.maxScrollExtent &&
          !scrollController.position.outOfRange &&
          !isLoading.value &&
          hasMore.value) {
        loadMoreBrands();
      }
    });
  }

  @override
  void onClose() {
    scrollController.dispose();
    _debounce?.cancel();
    super.onClose();
  }

  Future<void> loadBrands() async {
    if (isLoading.value) return;

    isLoading.value = true;

    try {
      Query query = FirebaseFirestore.instance.collection('brands');

      QuerySnapshot querySnapshot;

      if (searchText.value.length > 2) {
        final search = searchText.value.capitalizeEachWord();

        query = query
            .where('name', isGreaterThanOrEqualTo: search)
            .where('name', isLessThanOrEqualTo: search + '\uf8ff');

        querySnapshot = await query.limit(limit.value).get();

        searchedBrands.value = querySnapshot.docs
            .map((doc) => Brand.fromFireStore(doc))
            .toList();

      } else {
        querySnapshot = await query
            .orderBy('priority')
            .limit(limit.value)
            .get();

        loadedBrands.value = querySnapshot.docs
            .map((doc) => Brand.fromFireStore(doc))
            .toList();
      }

      hasMore.value = (searchText.value.length > 2
          ? searchedBrands.length
          : loadedBrands.length) ==
          limit.value;
    } catch (e) {
      print('Error loading brands: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void loadMoreBrands() {
    limit.value += isWeb ? 40 : 20;
    loadBrands();
  }

  void onSearchChanged(String value) {
    searchText.value = value;
    _debounce?.cancel();

    if (value.length > 2) {
      _debounce = Timer(Duration(milliseconds: 500), () {
        searchedBrands.clear();
        limit.value = isWeb ? 40 : 20;
        hasMore.value = true;
        loadBrands();
      });
    } else {
      searchedBrands.clear();
      limit.value = isWeb ? 40 : 20;
      hasMore.value = true;
      loadBrands();
    }
  }

  List<Brand> get brandsToDisplay =>
      searchText.value.length > 2 ? searchedBrands : loadedBrands;
}
