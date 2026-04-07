import 'package:html/parser.dart' as html_parser;

class Collection {
  final int id;
  final String title;
  final String handle;
  final String htmlDesc;
  final DateTime publishedAt;
  final DateTime updatedAt;
  final String? image;
  final int productsCount;
  final String description;

  Collection({
    required this.id,
    required this.title,
    required this.handle,
    required this.htmlDesc,
    required this.publishedAt,
    required this.updatedAt,
    required this.image,
    required this.productsCount,
  }) : description = _parseHtmlToPlainText(htmlDesc);

  static String _parseHtmlToPlainText(String htmlString) {
    var document = html_parser.parse(htmlString);
    return document.body?.text ?? '';
  }

  factory Collection.fromJson(Map<String, dynamic> json) {
    final imageJson = json['image'];

    return Collection(
      id: (json['id'] is int) ? json['id'] : int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      title: json['title'] ?? '',
      handle: json['handle'] ?? '',
      htmlDesc: json['description'] ?? '',
      publishedAt: DateTime.tryParse(json['published_at'] ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updated_at'] ?? '') ?? DateTime.now(),
      image: imageJson != null && imageJson['src'] != null ? imageJson['src'] as String : null,
      productsCount: (json['products_count'] is int)
          ? json['products_count']
          : int.tryParse(json['products_count']?.toString() ?? '0') ?? 0,
    );
  }

}
