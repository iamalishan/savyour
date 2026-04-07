import '../constants/app_imports.dart';

extension CapitalizeExtension on String {
  String capitalizeEachWord() {
    if (trim().isEmpty) return this;

    return trim().split(' ').map((word) {
      if (word.isEmpty) return word;
      return word[0].toUpperCase() + word.substring(1).toLowerCase();
    }).join(' ');
  }
}

extension ProductHandleExtractor on String {
  String extractProductHandle() {
    try {
      final uri = Uri.parse("https://dummy.com$this"); // Add dummy host
      final segments = uri.pathSegments;
      final index = segments.indexOf('products');
      if (index != -1 && index + 1 < segments.length) {
        return segments[index + 1];
      }
    } catch (e) {
      print("Error extracting handle: $e");
    }
    return '';
  }
}

extension CollectionHandleExtractor on String {
  String extractCollectionHandle() {
    try {
      final uri = Uri.parse(this);
      final handle = uri.pathSegments.last;
        return handle;
    } catch (e) {
      print("Error extracting handle: $e");
    }
    return '';
  }
}

extension TimeAgo on DateTime {
  String timeAgo() {
    final now = DateTime.now();
    final difference = now.difference(this);

    if(difference.inSeconds < 1){
      return "Just Now";
    } else if (difference.inSeconds < 60) {
      return "${difference.inSeconds}s";
    } else if (difference.inMinutes < 60) {
      return "${difference.inMinutes}m";
    } else if (difference.inHours < 24) {
      return "${difference.inHours}h";
    } else {
      return DateFormat("dd/MMM/yyyy HH:mm").format(this);
    }
  }
}

extension ShareUrlParser on Uri {
  Map<String, String> get sharedInfo {
    final pathSegments = this.pathSegments;

    if (pathSegments.isEmpty) return {};

    final type = pathSegments[0];

    switch (type) {
      case 'b':
        if (pathSegments.length >= 2) {
          return {
            'shared_type': 'brand',
            'brand_id': pathSegments[1],
          };
        }
        break;

      case 'c':
        if (pathSegments.length >= 3) {
          return {
            'shared_type': 'collection',
            'collection_id': pathSegments[1],
            'brand_id': pathSegments[2],
          };
        }
        break;

      case 'p':
        if (pathSegments.length >= 3) {
          return {
            'shared_type': 'product',
            'product_id': pathSegments[1],
            'brand_id': pathSegments[2],
          };
        }
        break;
    }

    return {}; // Invalid or unsupported path
  }
}

extension UrlCleaner on String {
  String get cleanUrl {
    return replaceAll(RegExp(r'^https?:\/\/'), '');
  }
}

