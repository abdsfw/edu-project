class Video {
  int? id;
  String? url;
  String? quality;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? levelId;

  Video({
    this.id,
    this.url,
    this.quality,
    this.createdAt,
    this.updatedAt,
    this.levelId,
  });

  factory Video.fromJson(Map<String, dynamic> json) => Video(
        id: json['id'] as int?,
        url: json['url'] as String?,
        quality: json['quality'] as String?,
        createdAt: json['createdAt'] == null
            ? null
            : DateTime.parse(json['createdAt'] as String),
        updatedAt: json['updatedAt'] == null
            ? null
            : DateTime.parse(json['updatedAt'] as String),
        levelId: json['level_id'] as int?,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'url': url,
        'quality': quality,
        'createdAt': createdAt?.toIso8601String(),
        'updatedAt': updatedAt?.toIso8601String(),
        'level_id': levelId,
      };
}
