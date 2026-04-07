import 'package:html/parser.dart' as html_parser;

class Product {
  final int id;
  final String title;
  final String handle;
  final String bodyHtml;
  final DateTime publishedAt;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? vendor;
  final List<Variant> variants;
  final List<Images> images;
  final String description;
  final String? productType;
  final bool isRecommended;

  Product({
    required this.id,
    required this.title,
    required this.handle,
    required this.bodyHtml,
    required this.publishedAt,
    required this.createdAt,
    required this.updatedAt,
    this.vendor,
    required this.variants,
    required this.images,
    this.productType,
    this.isRecommended = false,
  }) : description = _parseHtmlToPlainText(bodyHtml);

  static String _parseHtmlToPlainText(String htmlString) {
    if (!htmlString.contains('<')) return htmlString.trim();
    var document = html_parser.parse(htmlString);
    return document.body?.text.trim() ?? '';
  }

  factory Product.fromJson(Map<String, dynamic> json, {bool isRecommended = false}) {
    final rawHtml = json['body_html'] ?? json['description'] ?? '';

    return Product(
      id: json['id'] as int,
      title: json['title'] as String,
      vendor: json['vendor'] as String?,
      handle: json['handle'] as String,
      bodyHtml: rawHtml,
      publishedAt: DateTime.parse(json['published_at']),
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at'] ?? DateTime.now().toIso8601String()),
      productType: json['product_type'] ?? json['type'] as String?,
      variants: (json['variants'] as List)
          .map((variantJson) =>
          Variant.fromJson(variantJson as Map<String, dynamic>, isRecommended: isRecommended))
          .toList(),
      images: (json['images'] as List)
          .map((imageJson) => Images.fromJson(imageJson))
          .toList(),
      isRecommended: isRecommended,
    );
  }
}

class Variant {
  final String price;
  final String? compareAtPrice;
  final int? discount;

  Variant({required this.price, this.compareAtPrice})
      : discount = _calculateDiscount(price, compareAtPrice);

  static int _calculateDiscount(String price, String? compareAtPrice) {
    double currentPrice = double.tryParse(price) ?? 0.0;
    double originalPrice = compareAtPrice != null
        ? double.tryParse(compareAtPrice) ?? 0.0
        : 0.0;

    if (originalPrice == 0.0 || currentPrice == 0.0) return 0;
    return ((originalPrice - currentPrice) / originalPrice * 100).round();
  }

  factory Variant.fromJson(Map<String, dynamic> json, {bool isRecommended = false}) {
    String convertPrice(dynamic value) {
      double parsed = 0.0;
      if (value is int) parsed = value.toDouble();
      else if (value is String) parsed = double.tryParse(value) ?? 0.0;

      return isRecommended ? (parsed / 100).toStringAsFixed(2) : parsed.toStringAsFixed(0);
    }

    return Variant(
      price: convertPrice(json['price']),
      compareAtPrice: json['compare_at_price'] != null
          ? convertPrice(json['compare_at_price'])
          : null,
    );
  }
}

class Images {
  final int? id;
  final int? position;
  final String src;

  Images({this.id, this.position, required this.src});

  factory Images.fromJson(dynamic json) {
    if (json is String) {
      return Images(src: json);
    } else if (json is Map<String, dynamic>) {
      return Images(
        id: json['id'] as int?,
        position: json['position'] as int?,
        src: json['src'] as String,
      );
    } else {
      throw Exception('Unsupported image format: $json');
    }
  }
}
