class Pdf {
  int? id;
  String? url;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? levelId;

  Pdf({this.id, this.url, this.createdAt, this.updatedAt, this.levelId});

  factory Pdf.fromJson(Map<String, dynamic> json) => Pdf(
        id: json['id'] as int?,
        url: json['url'] as String?,
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
        'createdAt': createdAt?.toIso8601String(),
        'updatedAt': updatedAt?.toIso8601String(),
        'level_id': levelId,
      };
}
