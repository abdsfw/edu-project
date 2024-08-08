
import 'data_user_model.dart';

class Data {
  String? token;
  DataInfo? dataInfo;

  Data({this.token, this.dataInfo});

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        token: json['token'] as String?,
        dataInfo: json['data'] == null
            ? null
            : DataInfo.fromJson(json['data'] as Map<String, dynamic>),
      );

  Map<String, dynamic> toJson() => {
        'token': token,
        'data': dataInfo?.toJson(),
      };
}
