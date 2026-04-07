import 'dart:convert';
import 'package:ecommerce_web/constants/app_imports.dart';
import 'package:http/http.dart' as http;

import '../../../controllers/navbar_search_controller.dart';

class SearchInBrandController extends GetxController {
  final BrandsController brandsController = Get.put(BrandsController());
  final navbarSearchCon = Get.put(NavbarSearchController());

  final searchTEC = TextEditingController();
  final fetchedProducts = <SearchedProduct>[].obs;
  final brand = Rx<Brand?>(null);

  final isBrandLoading = false.obs;
  final isLoading = false.obs;
  final currentPage = 1.obs;
  final hasMore = true.obs;

  final String baseUrl =
      'https://script.google.com/macros/s/AKfycbwZ_0fZUOqhG_SifdAO4T90cl5UB3IBvJ6R4zL4sDUHaR87nh1HY1a7b9UV5mIl4DtNVA/exec';

  Timer? _debounce;

  void onSearchChanged(String brandId) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      searchProducts(brandId, mainBrand: brand.value, reset: true);
    });
  }

  Future<void> searchProducts(
      String brandId, {
        Brand? mainBrand,
        bool reset = false,
      }) async {
    if (reset) {
      currentPage.value = 1;
      fetchedProducts.clear();
      hasMore.value = true;
    }

    if (!hasMore.value || isLoading.value) return;

    if (mainBrand == null && brand.value == null) {
      isBrandLoading(true);
    }

    isLoading(true);

    try {
      if (brand.value == null) {
        brand.value = mainBrand ?? await brandsController.fetchBrand(brandId);
      }

      final brandUrl = brand.value?.url;
      if (brandUrl == null || brandUrl.isEmpty) {
        print("Error: Brand URL is null or empty.");
        hasMore(false);
        return;
      }

      final fullUrl =
          "$baseUrl?url=$brandUrl&query=${searchTEC.value.text}&page=${currentPage.value}";

      final response = await http.get(Uri.parse(fullUrl));

      if (response.statusCode == 200) {
        final inputString = response.body;
        const startMarker = '{"searchResult":{"query":"';
        const endMarker = '}});}';

        final startIndex = inputString.indexOf(startMarker);
        final endIndex = inputString.indexOf(endMarker, startIndex);

        if (startIndex != -1 && endIndex != -1) {
          final jsonString = inputString.substring(startIndex, endIndex + 2);

          final validJsonString = jsonString
              .replaceAllMapped(RegExp(r'(\w+):'), (match) => '"${match[1]}":')
              .replaceAll(RegExp(r"'"), '"');

          final jsonData = jsonDecode(validJsonString);
          final List<dynamic> productList =
              jsonData['searchResult']['productVariants'] ?? [];

          if (productList.isEmpty) {
            hasMore(false);
          } else {
            final newProducts =
            productList.map((item) => SearchedProduct.fromJson(item)).toList();
            fetchedProducts.addAll(newProducts);
            currentPage.value += 1;
          }
        } else {
          hasMore(false);
        }
      } else {
        hasMore(false);
      }
    } catch (e) {
      print("Error fetching search products: $e");
      hasMore(false);
    } finally {
      isLoading(false);
      isBrandLoading(false);
    }
  }

  @override
  void onClose() {
    // searchTEC.dispose();
    super.onClose();
  }
}

class SearchedProduct {
  final String id;
  final String title;
  final String? sku;
  final double price;
  final String currencyCode;
  final String imageUrl;
  final String productTitle;
  final String productId;
  final String productUrl;
  final String vendor;

  SearchedProduct({
    required this.id,
    required this.title,
    required this.price,
    required this.currencyCode,
    required this.imageUrl,
    required this.productTitle,
    required this.productId,
    required this.productUrl,
    required this.vendor,
    this.sku,
  });

  factory SearchedProduct.fromJson(Map<String, dynamic> json) {
    return SearchedProduct(
      id: json['id'].toString(),
      title: json['title'] ?? '',
      sku: json['sku'],
      price: (json['price']?['amount'] ?? 0).toDouble(),
      currencyCode: json['price']?['currencyCode'] ?? '',
      imageUrl: 'https:${json['image']?['src'] ?? ''}',
      productTitle: json['product']?['title'] ?? '',
      productId: json['product']['id'].toString(),
      productUrl: json['product']?['url'] ?? '',
      vendor: json['product']?['vendor'] ?? '',
    );
  }
}
