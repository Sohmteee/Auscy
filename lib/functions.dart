import 'package:auscy/chatmessage.dart';

jsonToChatMessage(Map<String, dynamic> json) {
  return ChatMessage(
    text: json['text'],
    sender: json['sender'],
    time: json['time'],
  );
}

Future createUser({required String name}) asyncb{

}
