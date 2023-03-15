import 'package:chat_gpt_02/chatmessage.dart';

jsonToChatMessage(Map<String, dynamic> json) {
  return ChatMessage(
    text: json['text'],
    sender: json['sender'],
    time: json['time'],
    isErroMessage: json['isErroMessage'],
  );
}
