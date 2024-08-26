import 'package:auscy/widgets/chat_message.dart';
import 'package:auscy/widgets/chat_tile.dart';

import 'data.dart';

jsonToChatMessage(Map<String, dynamic> json) {
  return ChatMessage(
    text: json['text'],
    sender: json['sender'] == "user" ? MessageSender.user : MessageSender.bot,
    time: json['time'],
  );
}

jsonToMessageList(List<Map<String, dynamic>> json) {
  List<ChatMessage> messages = [];

  for (Map<String, dynamic> message in json) {
    messages.add(jsonToChatMessage(message));
  }

  return messages;
}

jsonToChatTile(Map<String, dynamic> json) {
  return ChatTile(
    id: json['id'],
    title: json['title'],
    chatScreen: json['chatScreen'],
    time: json['time'],
  );
}

/* Future createMessage({required String username}) async {
  final docUser = db.collection('chat').doc(username);

  await docUser.set({
    'messages': messagesInJSON,
  });

  await docUser.update({
    'messages': FieldValue.arrayUnion(messages),
  });
} */
