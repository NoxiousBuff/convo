import 'package:hint/constants/message_string.dart';

class DuleModel {
  final String msgTxt;
  final String url;
  final String urlType;
  final String? aniType;
  final bool online;
  final String? roomUid;

  DuleModel({
    required this.msgTxt,
    required this.roomUid,
    required this.url,
    required this.urlType,
    required this.online,
    this.aniType,
  });

  DuleModel.fromJson(Map<String, dynamic> json)
      : msgTxt = json[DatabaseMessageField.msgTxt],
        roomUid = json[DatabaseMessageField.roomUid],
        url = json[DatabaseMessageField.url],
        urlType = json[DatabaseMessageField.urlType],
        online = json[DatabaseMessageField.online],
        aniType = json[DatabaseMessageField.aniType];

  Map<String, dynamic> toJson() => {
        DatabaseMessageField.msgTxt: msgTxt,
        DatabaseMessageField.roomUid: roomUid,
        DatabaseMessageField.url: url,
        DatabaseMessageField.urlType: urlType,
        DatabaseMessageField.online: online,
        DatabaseMessageField.aniType: aniType,
      };
}
