import 'package:ecommerce_web/constants/app_imports.dart';
import 'package:http/http.dart' as http;

class ProductsController extends GetxController {
  var products = <Product>[].obs;
  var currentPage = 1.obs;

  // ================= Fetch Single Product =====================
  Future<Product> fetchSingleProduct(String brandUrl, String productHandle) async {
    var baseUrl = AppUrls.getBaseUrl('getproductdetail');
    final cleanedUrl = brandUrl.cleanUrl;

    final uri = Uri.parse(baseUrl).replace(queryParameters: {
      'brandUrl': cleanedUrl,
      'productHandle': productHandle,
    });

    print(uri.toString());

    try {
      final response = await http.get(uri, headers: {
        'accept': 'application/json',
      });

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final productJson = data['product'] as Map<String, dynamic>;
        return Product.fromJson(productJson);
      } else {
        throw Exception('Failed to fetch product. Status: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching product: $e');
    }
  }

  // ================= Fetch Multiple Products =====================
  Future<List<Product>> fetchMultipleProducts(String brandUrl, String collectionName, {int page = 1}) async {
    var baseUrl = AppUrls.getBaseUrl('getcollectionproducts');
    final cleanedUrl = brandUrl.cleanUrl;

    final uri = Uri.parse(baseUrl).replace(queryParameters: {
      'brandUrl': cleanedUrl,
      'collectionName': collectionName,
      'page': page.toString(),
      'limit': '20',
    });

    List<Product> fetchedProducts = [];

    try {
      final response = await http.get(uri, headers: {
        'accept': 'application/json',
      });

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final productsJson = data['products'] as List<dynamic>;

        fetchedProducts = productsJson
            .map((json) => Product.fromJson(json))
            .toList();

      } else {
        print('Failed to fetch products. Status: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching products: $e');
    }

    return fetchedProducts;
  }

  // ================= Fetch Related Products =====================
  Future<List<Product>> fetchRelatedProducts(String brandUrl, String productId) async {
    var baseUrl = AppUrls.getBaseUrl('getrecommendedproducts');
    final cleanedUrl = brandUrl.cleanUrl;

    final uri = Uri.parse(baseUrl).replace(queryParameters: {
      'brandUrl': cleanedUrl,
      'productId': productId
    });

    print(uri.toString());

    List<Product> fetchedProducts = [];

    try {
      final response = await http.get(uri, headers: {
        'accept': 'application/json',
      });

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final productsJson = data['products'] as List<dynamic>;

        fetchedProducts = productsJson
            .map((json) => Product.fromJson(json, isRecommended: true))
            .toList();

      } else {
        print('Failed to fetch recommended products. Status: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching recommended products: $e');
    }

    return fetchedProducts;
  }
}