import 'package:auscy/chatmessage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'data.dart';

jsonToChatMessage(Map<String, dynamic> json) {
  return ChatMessage(
    text: json['text'],
    sender: json['sender'] == "user" ? MessageSender.user : MessageSender.bot,
    time: json['time'],
  );
}

List<Map<String, dynamic>> listToMap(List<ChatMessage> messages) {
  List<Map<String, dynamic>> messagesInJSON = [];

  for (ChatMessage message in messages) {
    messagesInJSON.add(message.toJSON());
  }

  return messagesInJSON;
}

Future createMessage(
    {required String username}) async {
  final docUser = db.collection('chat').doc(username);

  await docUser.set({
    'messages' : messagesInJSON,
  });

  await docUser.update({
    'messages': FieldValue.arrayUnion(messages),
  });
}
