import 'dart:convert';

import 'package:html/parser.dart' as html;
import 'package:http/http.dart' as http;

class InstagramScraper {
  // CORS proxy URLs
  static const List<String> _corsProxies = [
    'https://cors-anywhere.herokuapp.com/',
    'https://api.allorigins.win/raw?url=',
    'https://thingproxy.freeboard.io/fetch/',
  ];

  Future<Map<String, dynamic>?> scrapeUserData(String username) async {
    // Try different CORS proxies if one fails
    for (String proxy in _corsProxies) {
      try {
        final targetUrl = 'https://www.instagram.com/$username/';
        final proxyUrl = proxy + Uri.encodeComponent(targetUrl);

        final response = await http.get(
          Uri.parse(proxyUrl),
          headers: {
            'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36',
          },
        );

        if (response.statusCode == 200) {
          final document = html.parse(response.body);

          // Extract JSON data from script tag
          final scripts = document.querySelectorAll('script');
          for (var script in scripts) {
            final content = script.text;
            if (content.contains('window._sharedData')) {
              // Parse the JSON data
              final startIndex = content.indexOf('{');
              final endIndex = content.lastIndexOf('}') + 1;
              final jsonString = content.substring(startIndex, endIndex);

              final data = json.decode(jsonString);
              return extractUserInfo(data);
            }
          }
        }
      } catch (e) {
        print('Error with proxy $proxy: $e');
        continue; // Try next proxy
      }
    }

    print('All proxies failed');
    return null;
  }

  Map<String, dynamic> extractUserInfo(Map<String, dynamic> data) {
    final user = data['entry_data']['ProfilePage'][0]['graphql']['user'];
    return {
      'username': user['username'],
      'full_name': user['full_name'],
      'biography': user['biography'],
      'followers_count': user['edge_followed_by']['count'],
      'following_count': user['edge_follow']['count'],
      'profile_pic_url': user['profile_pic_url_hd'],
      'is_verified': user['is_verified'],
    };
  }
}