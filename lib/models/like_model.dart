class LikeModel {
  final String id;
  final String handle;
  final String brandId;
  final String brandUrl;
  final DateTime timestamp;

  LikeModel({
    required this.id,
    required this.handle,
    required this.brandId,
    required this.brandUrl,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'handle': handle,
      'brandId': brandId,
      'brandUrl': brandUrl,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  factory LikeModel.fromMap(Map<String, dynamic> map) {
    return LikeModel(
      id: map['id'],
      handle: map['handle'],
      brandId: map['brandId'],
      brandUrl: map['brandUrl'],
      timestamp: DateTime.parse(map['timestamp']),
    );
  }
}
