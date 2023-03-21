import 'package:auscy/chatmessage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'data.dart';

jsonToChatMessage(Map<String, dynamic> json) {
  return ChatMessage(
    text: json['text'],
    sender: json['sender'],
    time: json['time'],
  );
}

Future createMessage(
    {required String username}) async {
  final docUser = db.collection('chat').doc(username);

  /* await docUser.set({
    'messages' : messagesInJSON,
  }); */

  await docUser.update({
    'messages': FieldValue.arrayUnion(messages),
  });
}
