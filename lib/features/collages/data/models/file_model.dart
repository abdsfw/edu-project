class FileModel {
  int? id;
  String? fileName;
  String? storageName;
  String? path;
  String? type;
  String? size;
  int? courseId;
  int? levelId;

  FileModel({
    this.id,
    this.fileName,
    this.storageName,
    this.path,
    this.type,
    this.size,
    this.courseId,
    this.levelId,
  });

  factory FileModel.fromJson(Map<String, dynamic> json) => FileModel(
        id: json['id'] as int?,
        fileName: json['fileName'] as String?,
        storageName: json['storageName'] as String?,
        path: json['path'] as String?,
        type: json['type'] as String?,
        size: json['size'] as String?,
        courseId: json['courseID'] as int?,
        levelId: json['levelID'] as int?,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'fileName': fileName,
        'storageName': storageName,
        'path': path,
        'type': type,
        'size': size,
        'courseID': courseId,
        'levelID': levelId,
      };
}
