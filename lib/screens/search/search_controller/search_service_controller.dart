import '../../../constants/app_imports.dart';
import '../../../models/fb_product_model.dart';

class SearchServiceController extends GetxController {
  final searchQuery = ''.obs;
  final searchController = TextEditingController();
  final ScrollController brandScrollController = ScrollController();
  final ScrollController productScrollController = ScrollController();

  // Separated lists
  RxList<Brand> loadedBrands = <Brand>[].obs;
  RxList<Brand> searchedBrands = <Brand>[].obs;
  RxList<FBProductModel> loadedProducts = <FBProductModel>[].obs;
  RxList<FBProductModel> searchedProducts = <FBProductModel>[].obs;

  // Flags
  RxBool isLoadingBrands = false.obs;
  RxBool isLoadingProducts = false.obs;
  RxBool hasMoreBrands = true.obs;
  RxBool hasMoreProducts = true.obs;

  // Pagination
  RxInt brandPage = 0.obs;
  RxInt productPage = 0.obs;
  RxInt brandLimit = 20.obs;
  RxInt productLimit = 20.obs;

  final bool isWeb;

  SearchServiceController({this.isWeb = false}) {
    brandLimit.value = isWeb ? 40 : 20;
    productLimit.value = isWeb ? 40 : 20;

    _initScrollListener();
  }

  void _initScrollListener() {
    brandScrollController.addListener(() {
      if (brandScrollController.offset >= brandScrollController.position.maxScrollExtent &&
          !brandScrollController.position.outOfRange &&
          !isLoadingBrands.value &&
          hasMoreBrands.value) {
        loadMoreBrands();
      }
    });

    productScrollController.addListener(() {
      if (productScrollController.offset >= productScrollController.position.maxScrollExtent &&
          !productScrollController.position.outOfRange &&
          !isLoadingProducts.value &&
          hasMoreProducts.value) {
        loadMoreProducts();
      }
    });
  }

  Timer? _debounce;

  void updateSearch(String value) {
    searchQuery.value = value.trim();
    _debounce?.cancel();

    _debounce = Timer(const Duration(milliseconds: 300), () async {
      final isSearchActive = searchQuery.value.length > 2;

      if (isSearchActive) {
        _resetSearchResults();
        await Future.wait([
          fetchBrands(isInitial: true),
          fetchProducts(isInitial: true),
        ]);

        FirebaseAnalyticsUtil.analyticLogEvent(name: 'searched_for', parameters: {
          'search_query': searchQuery.value,
          'search_type': 'both',
        });
      } else {
        _resetDefaultResults();
        // Uncomment if you want to load default data when search is cleared
        // await Future.wait([
        //   fetchBrands(isInitial: true),
        //   fetchProducts(isInitial: true),
        // ]);
      }
    });
  }

  void _resetSearchResults() {
    searchedBrands.clear();
    searchedProducts.clear();
    brandPage.value = 0;
    productPage.value = 0;
    hasMoreBrands.value = true;
    hasMoreProducts.value = true;
  }

  void _resetDefaultResults() {
    loadedBrands.clear();
    loadedProducts.clear();
    brandPage.value = 0;
    productPage.value = 0;
    hasMoreBrands.value = true;
    hasMoreProducts.value = true;
  }

  // Brand-specific methods
  Future<void> fetchBrands({bool isInitial = false}) async {
    if (isLoadingBrands.value || !hasMoreBrands.value) return;

    isLoadingBrands.value = true;
    try {
      final queryText = searchQuery.value.capitalizeEachWord();
      final collection = FirebaseFirestore.instance.collection('brands');
      Query firestoreQuery;

      if (searchQuery.value.length > 2) {
        firestoreQuery = collection
            .where('name', isGreaterThanOrEqualTo: queryText)
            .where('name', isLessThanOrEqualTo: queryText + '\uf8ff')
            .orderBy('name');
      } else {
        firestoreQuery = collection.orderBy('priority');
      }

      // Apply pagination
      if (!isInitial && brandPage.value > 0) {
        final currentBrands = searchQuery.value.length > 2 ? searchedBrands : loadedBrands;
        if (currentBrands.isNotEmpty) {
          final lastBrand = currentBrands.last;
          if (searchQuery.value.length > 2) {
            firestoreQuery = firestoreQuery.startAfter([lastBrand.name]);
          } else {
            firestoreQuery = firestoreQuery.startAfter([lastBrand.priority]);
          }
        }
      }

      final snapshot = await firestoreQuery.limit(brandLimit.value).get();
      final result = snapshot.docs.map((doc) => Brand.fromFireStore(doc)).toList();

      if (searchQuery.value.length > 2) {
        if (isInitial) {
          searchedBrands.value = result;
        } else {
          searchedBrands.addAll(result);
        }
        hasMoreBrands.value = result.length == brandLimit.value;
      } else {
        if (isInitial) {
          loadedBrands.value = result;
        } else {
          loadedBrands.addAll(result);
        }
        hasMoreBrands.value = result.length == brandLimit.value;
      }

      if (result.isNotEmpty) {
        brandPage.value++;
      }
    } catch (e) {
      debugPrint('Error loading brands: $e');
    } finally {
      isLoadingBrands.value = false;
    }
  }

  Future<void> loadMoreBrands() async {
    await fetchBrands(isInitial: false);
  }

  Future<void> refreshBrands() async {
    brandPage.value = 0;
    hasMoreBrands.value = true;
    if (searchQuery.value.length > 2) {
      searchedBrands.clear();
    } else {
      loadedBrands.clear();
    }
    await fetchBrands(isInitial: true);
  }

  // Product-specific methods
  Future<void> fetchProducts({bool isInitial = false}) async {
    if (isLoadingProducts.value || !hasMoreProducts.value) return;

    isLoadingProducts.value = true;
    try {
      final queryText = searchQuery.value.capitalizeEachWord();
      final collection = FirebaseFirestore.instance.collection('products');
      Query firestoreQuery;

      if (searchQuery.value.length > 2) {
        firestoreQuery = collection
            .where('title', isGreaterThanOrEqualTo: queryText)
            .where('title', isLessThanOrEqualTo: queryText + '\uf8ff')
            .orderBy('title');
      } else {
        firestoreQuery = collection.orderBy('last_updated', descending: true);
      }

      if (!isInitial && productPage.value > 0) {
        final currentProducts =
        searchQuery.value.length > 2 ? searchedProducts : loadedProducts;
        if (currentProducts.isNotEmpty) {
          final lastProduct = currentProducts.last;
          final startAfterField = searchQuery.value.length > 2
              ? lastProduct.title
              : lastProduct.lastUpdated;

          if (startAfterField != null) {
            firestoreQuery = firestoreQuery.startAfter([startAfterField]);
          }
        }
      }

      final snapshot = await firestoreQuery.limit(productLimit.value).get();

      if (snapshot.docs.isEmpty) {
        hasMoreProducts.value = false;
        debugPrint('No more products to load.');
      } else {
        final result =
        snapshot.docs.map((doc) => FBProductModel.fromFirestore(doc)).toList();

        if (searchQuery.value.length > 2) {
          if (isInitial) {
            searchedProducts.value = result;
          } else {
            searchedProducts.addAll(result);
          }
        } else {
          if (isInitial) {
            loadedProducts.value = result;
          } else {
            loadedProducts.addAll(result);
          }
        }

        hasMoreProducts.value = true;
        productPage.value++;
      }
    } catch (e) {
      debugPrint('Error loading products: $e');
    } finally {
      isLoadingProducts.value = false;
    }
  }

  Future<void> loadMoreProducts() async {
    await fetchProducts(isInitial: false);
  }

  Future<void> refreshProducts() async {
    productPage.value = 0;
    hasMoreProducts.value = true;
    if (searchQuery.value.length > 2) {
      searchedProducts.clear();
    } else {
      loadedProducts.clear();
    }
    await fetchProducts(isInitial: true);
  }

  // Getters
  List<Brand> get brandsToDisplay =>
      searchQuery.value.length > 2 ? searchedBrands : loadedBrands;

  List<FBProductModel> get productsToDisplay =>
      searchQuery.value.length > 2 ? searchedProducts : loadedProducts;

  bool get isSearchActive => searchQuery.value.length > 2;

  // Clear search
  void clearSearch() {
    searchController.clear();
    searchQuery.value = '';
    _resetSearchResults();
    _resetDefaultResults();
  }

  @override
  void onClose() {
    brandScrollController.dispose();
    productScrollController.dispose();
    searchController.dispose();
    _debounce?.cancel();
    super.onClose();
  }
}