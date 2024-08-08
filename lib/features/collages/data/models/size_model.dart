class SizeModel {
  int? fileID;
  String? type;
  String? size;
  int? courseID;
  int? levelID;
  bool? isDownloaded;
  SizeModel({
    this.fileID,
    this.type,
    this.size,
    this.courseID,
    this.levelID,
    this.isDownloaded,
  });
// courseID INTEGER , levelID INTEGER
  factory SizeModel.fromJson(Map<String, dynamic> json) => SizeModel(
        fileID: json['fileID'] as int?,
        type: json['type'] as String?,
        size: json['size'] as String?,
        courseID: json['courseID'] as int?,
        levelID: json['levelID'] as int?,
        isDownloaded: json['isDownload'] == 'true',
      );

  Map<String, dynamic> toJson() => {
        'fileID': fileID,
        'type': type,
        'size': size,
        'courseID': courseID,
        'levelID': levelID,
        'isDownload': isDownloaded,
      };
}
