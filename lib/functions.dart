import 'package:auscy/chatmessage.dart';

import 'data.dart';

jsonToChatMessage(Map<String, dynamic> json) {
  return ChatMessage(
    text: json['text'],
    sender: json['sender'],
    time: json['time'],
  );
}

Future createUser({required String name}) async{
final docUser = db.collection(collectionPath)
}
