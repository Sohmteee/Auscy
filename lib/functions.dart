import 'package:chat_gpt_02/chatmessage.dart';

JSONtoChatMessage(Map<String, dynamic> json) {
  return ChatMessage(text: json[''], sender: sender)
}