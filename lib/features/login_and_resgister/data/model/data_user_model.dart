class DataInfo {
  int? id;
  String? name;
  String? user;
  String? phone;

  DataInfo({this.id, this.name, this.user, this.phone});

  factory DataInfo.fromJson(Map<String, dynamic> json) => DataInfo(
        id: json['id'] as int?,
        name: json['name'] as String?,
        user: json['user'] as String?,
        phone: json['phone'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'user': user,
        'phone': phone,
      };
}
