import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_chat_ui/flutter_chat_ui.dart';

class ChatRoom {
  final String id;
  String title;
  Chat? chat;
  List<types.Message> messages = [];

  ChatRoom({
    required this.id,
    required this.title,
    required this.messages,
  }) : chat = Chat(
          onSendPressed: (message) {},
          user: const types.User(
            id: 'user',
            firstName: 'You',
            role: types.Role.user,
          ),
          messages: const [],
        );

  factory ChatRoom.fromJson(Map<String, dynamic> json) {
    return ChatRoom(
      id: json['id'],
      title: json['title'],
      messages: (json['messages'] as List)
          .map((e) => types.Message.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'messages': messages.map((e) => e.toJson()).toList(),
    };
  }
}
