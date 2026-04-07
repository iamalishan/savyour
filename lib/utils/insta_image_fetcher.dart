import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' show parse;
import 'package:html/dom.dart';

import '../constants/app_urls.dart';

// Future<Map<String, dynamic>?> fetchInstagramData(String username) async {
//   final url = Uri.parse('https://blastup.com/instagram-follower-count');
//
//   final headers = {
//     'Content-Type': 'application/json',
//     'Origin': 'https://blastup.com',
//     'Referer': 'https://blastup.com/instagram-follower-count',
//     'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64)',
//     'Accept': '*/*',
//     'Accept-Language': 'en-US,en;q=0.9',
//     'Cookie': '_ga=GA1.1.501380699.1752166075; _ga_BT51ZCHLGT=GS2.1.s1752166075\$o1\$g1\$t1752167400\$j56\$l0\$h0; XSRF-TOKEN=eyJpdiI6IjhGcHBaQ1FLS3BmZExMQlBTTXFRMVE9PSIsInZhbHVlIjoiVU1LNkNwSGhtR1gvQnMwUUlvWTZuSVNRV1RtYUxmNnh6WXdCMUV6c2JhQk5iYVViYjVVVG5RMkVESkxmcnFlNFZEdDNUNnByOC9zTS9jem83ai9IM3lQTkN4NXpzcExJdUEwWE9qNTM1VXhZMU56K2hqZUZDUHhMY3RVdHUrOWciLCJtYWMiOiIyOGZiN2E4Nzk0NDg0M2YyNzEzMDQxMGY4NTA3Mjg5OGNmYWYwOTNiYjVkNDM4ZTE0YmI3YThiMWY2MDZiYjcxIiwidGFnIjoiIn0%3D; blastup_session=eyJpdiI6ImVUSVpyenBKVTJJait4cUZWQ0MzdGc9PSIsInZhbHVlIjoidVE1RGJnTG1qSXNJclF0aXlKVjE4TFRwL2F3UHZYY1VyWTVLQW40MlVYR0poa29YaUVnS1NCbzU1VXF2aE5mNHYzbXlmWDA5c0J2VFJGd1JCVUE5M24ya1AvVFZQSE9mMnlFNGVuOGRHNXVRVDBPNlhPUmZGMWkxZTBVWVlrdFMiLCJtYWMiOiI4NWNlZDM5YTY2ZTdkM2Q0OWYwZGQ1NjU0ZjE0OTIwNzdiZmZhNTZlNzEwODU5MWI0NzJhNDY5ODMxOGUzMWYzIiwidGFnIjoiIn0%3D'
//   };
//
//   final body = jsonEncode({
//     'username': username,
//     '_token': 'eEQRXE7PNlS8YoDTnAbiQozO5sLV0vpVOx54cvvG', // Update this if expired
//   });
//
//   print(url);
//
//   final response = await http.post(url, headers: headers, body: body);
//
//   if (response.statusCode == 200) {
//     final data = jsonDecode(response.body);
//     if (data['success'] == true) {
//       getImageSizeInMB(data['profile_picture']);
//       return {
//         'followers': data['followers'],
//         'image': data['profile_picture'],
//       };
//     }
//   } else {
//     print('Error: ${response.statusCode}');
//   }
//
//   return null;
// }
//
// int getImageSizeInBytes(String base64String) {
//   // Remove Data URI prefix if present
//   final base64 = base64String.split(',').last;
//   Uint8List bytes = base64Decode(base64);
//   return bytes.lengthInBytes;
// }
//
// double getImageSizeInKB(String base64String) {
//   return getImageSizeInBytes(base64String) / 1024;
// }
//
// double getImageSizeInMB(String base64String) {
//   print('Heklkfjlksdjfkdskf ${getImageSizeInKB(base64String) / 1024}');
//   return getImageSizeInKB(base64String) / 1024;
// }

Future<List<String>> extractCollectionUrls(String brandUrl) async {
  final proxyBaseUrl = AppUrls.getBaseUrl('getHtmlContent');
  final encodedUrl = Uri.encodeComponent(brandUrl);
  final fullUrl = '$proxyBaseUrl?url=$encodedUrl';

  try {
    final response = await http.get(Uri.parse(fullUrl));

    if (response.statusCode == 200) {
      Document document = parse(response.body);

      // Find all <a> tags
      List<Element> links = document.querySelectorAll('a');

      // Extract hrefs that contain '/collections/' and filter duplicates
      List<String> collectionUrls = links
          .map((e) => e.attributes['href'])
          .where((href) =>
      href != null &&
          href.contains('/collections/') &&
          !href.startsWith('#'))
          .map((href) {
        if (href!.startsWith('/')) {
          return '${Uri.parse(brandUrl).origin}$href';
        }
        return href;
      })
          .toSet()
          .toList(); // Remove duplicates

      return collectionUrls;
    } else {
      throw Exception("Failed to load page: ${response.statusCode}");
    }
  } catch (e) {
    print("Error while scraping collections: $e");
    return [];
  }
}

// ==================== Store and Fetch Image ====================

int passCount = 0;
int failCount = 0;
int skipCount = 0;

Future<void> fetchAndStoreInstagramBanners() async {
  final firestore = FirebaseFirestore.instance;
  final brandsSnapshot = await firestore.collection('brands').get();

  for (var doc in brandsSnapshot.docs) {
    final data = doc.data();
    final brandId = data['id'];
    final links = [
      data['facebook'],
      data['instagram'],
      data['twitter'],
      data['youtube'],
    ].whereType<String>().toList();

    final instaLink = links.firstWhere(
          (link) => link.contains('instagram.com'),
      orElse: () => '',
    );

    if (instaLink.isEmpty) {
      skipCount++;
      print("❌ No Instagram link for brand $brandId");
      _printCounts();
      continue;
    }

    final uri = Uri.tryParse(instaLink);
    if (uri == null || uri.pathSegments.isEmpty) {
      skipCount++;
      print("❌ Invalid Instagram link for brand $brandId");
      _printCounts();
      continue;
    }

    final username = uri.pathSegments.last;
    print("🔎 Fetching banner for @$username...");

    final bannerUrl = await _fetchInstagramBanner(username);

    if (bannerUrl == null) {
      failCount++;
      print("❌ Failed to fetch banner for @$username");
      _printCounts();
      continue;
    }

    try {
      final bannerResponse = await http.get(Uri.parse(bannerUrl));
      if (bannerResponse.statusCode == 200) {
        final base64Image = base64Encode(bannerResponse.bodyBytes);
        print("✅ Base64 for @$username");

        await firestore.collection('brands').doc(brandId).set({
          'imageBase64': base64Image,
          'isBase64': true,
        }, SetOptions(merge: true));

        passCount++;
        print("🔥 Stored base64 for brand: $brandId");
      } else {
        failCount++;
        print("❌ Failed to download banner image for @$username");
      }
    } catch (e) {
      failCount++;
      print("❌ Error downloading banner image: $e");
    }

    _printCounts();
  }
}

Future<String?> _fetchInstagramBanner(String username) async {
  const int maxRetries = 5;
  final baseUrl = AppUrls.getBaseUrl('getMixernoInstagramStats');
  final uri = Uri.parse(baseUrl).replace(queryParameters: {'username': username});

  for (int attempt = 1; attempt <= maxRetries; attempt++) {
    try {
      final response = await http.get(uri, headers: {'accept': 'application/json'});

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data is Map && data['user'] != null && data['user']['banner'] != null) {
          return data['user']['banner'];
        } else if (data is Map && data['error'] == "Failed to fetch Instagram stats") {
          print("⚠️ API Error for @$username: ${data['error']}");
          return null; // Skip on known error
        } else {
          print("🔁 Unexpected response, retrying ($attempt/5)...");
          await Future.delayed(const Duration(seconds: 1));
        }
      } else {
        print("❌ API failed with status ${response.statusCode}");
      }
    } catch (e) {
      print("❌ API call error for @$username: $e");
    }
  }

  print("❌ Max retries reached for @$username");
  return null;
}



void _printCounts() {
  print('''
📊 Progress Summary:
✅ Stored: $passCount
❌ Failed: $failCount
⚠️ Skipped: $skipCount
-------------------------------
''');
}

