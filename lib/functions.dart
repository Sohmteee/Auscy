import 'package:auscy/chatmessage.dart';

import 'data.dart';

jsonToChatMessage(Map<String, dynamic> json) {
  return ChatMessage(
    text: json['text'],
    sender: json['sender'],
    time: json['time'],
  );
}

Future createMessage(
    {required String username, required ChatMessage message}) async {
  final docUser = db.collection('chat').doc(username);

  final json = message.toJSON();

  await docUser.set({
    'messages' : []
  });
}
