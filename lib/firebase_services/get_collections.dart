import 'package:ecommerce_web/constants/app_imports.dart';
import 'package:http/http.dart' as http;

class GetCollectionsNew extends GetxController {
  var collections = <Collection>[].obs;
  var currentPage = 1.obs;

  // =================== Fetch Single Collection =========================
  Future<Collection> fetchSingleCollection(String brandUrl, String collectionHandle) async {
    var baseUrl = AppUrls.getBaseUrl('getcollectiondetail');
    final cleanedUrl = brandUrl.cleanUrl;

    final uri = Uri.parse(baseUrl).replace(queryParameters: {
      'brandUrl': cleanedUrl,
      'collectionHandle': collectionHandle,
    });

    try {
      final response = await http.get(uri, headers: {
        'accept': 'application/json',
      });

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final collectionsJson = data['collection'] as Map<String, dynamic>;
        return Collection.fromJson(collectionsJson);
      } else {
        throw Exception('Failed to fetch collection. Status: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching collection: $e');
    }
  }

  // =================== Fetch Multiple Collections ===========================
  Future<List<Collection>> fetchMultipleCollections(String brandUrl, {int page = 1}) async {
    var baseUrl = AppUrls.getBaseUrl('getcollections');
    final cleanedUrl = brandUrl.cleanUrl;

    final uri = Uri.parse(baseUrl).replace(queryParameters: {
      'brandUrl': cleanedUrl,
      'page': page.toString(),
      'limit': '20',
    });

    List<Collection> fetchedCollections = [];

    try {
      final response = await http.get(uri, headers: {
        'accept': 'application/json',
      });

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final collectionsJson = data['collections'] as List<dynamic>;

        fetchedCollections = collectionsJson
            .map((json) => Collection.fromJson(json))
            .toList();

      } else {
        print('Failed to fetch collections. Status: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching collections: $e');
    }

    return fetchedCollections;
  }

  // =================== Fetch Multiple Collections ===========================
  Future<List<Collection>> fetchDifferentCollections(List<String> urls) async {
    final baseUrl = AppUrls.getBaseUrl('getMultipleCollections');
    final uri = Uri.parse(baseUrl);

    List<Collection> fetchedCollections = [];

    try {
      final response = await http.post(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'accept': 'application/json',
        },
        body: json.encode({'urls': urls}),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final collectionsJson = data['collections'] as List<dynamic>;

        // Filter only successful responses
        for (var item in collectionsJson) {
          if (item is Map<String, dynamic> &&
              item['success'] == true &&
              item['collection'] != null) {
            try {
              final collection = Collection.fromJson(item['collection']);
              fetchedCollections.add(collection);
            } catch (e) {
              print('Error parsing collection: $e');
            }
          } else {
            print('Skipped collection due to failure or missing data: $item');
          }
        }
      } else {
        print('Failed to fetch collections. Status: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching collections: $e');
    }

    return fetchedCollections;
  }

}