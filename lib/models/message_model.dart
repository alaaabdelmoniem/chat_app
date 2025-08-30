import 'package:chat_app/constants.dart';

class MessageModel {
  final String message;
  final String id;
  MessageModel(this.id, {required this.message});
  factory MessageModel.fromJson(json) {
    return MessageModel(message: json[kMessage], json['id']);
  }
}
