import '../constants/app_imports.dart';

class Brand {
  final String id;
  final String name;
  final String? imageUrl;
  final String description;
  final List<String> links;
  final String url;
  final int priority;
  final String? imageBase64;

  Brand({
    required this.id,
    required this.name,
    this.imageUrl,
    required this.description,
    required this.links,
    required this.url,
    required this.priority,
    this.imageBase64,
  });

  factory Brand.fromFireStore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    List<String> rawLinks = [];

    final possibleLinks = ['facebook', 'instagram', 'twitter', 'youtube'];

    for (var key in possibleLinks) {
      if (data.containsKey(key)) {
        final val = data[key];
        if (val is String &&
            val.trim().isNotEmpty &&
            Uri.tryParse(val)?.hasAbsolutePath == true) {
          rawLinks.add(val);
        }
      }
    }

    return Brand(
      id: data['id'],
      name: data['name'],
      imageUrl: data['image'],
      description: data['description'],
      links: rawLinks,
      url: data['url'],
      priority: data['priority'],
      imageBase64: data['imageBase64'],
    );
  }

  Map<String, dynamic> toFireStore() {
    return {
      'id': id,
      'name': name,
      'image': imageUrl,
      'description': description,
      'url': url,
      'priority': priority,
    };
  }
}
