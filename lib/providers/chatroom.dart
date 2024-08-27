import 'package:auscy/data.dart';
import 'package:auscy/models/chatroom.dart';
import 'package:flutter/material.dart';

class ChatRoomProvider extends ChangeNotifier {
  List<ChatRoom> chats = [];

  void addChat(ChatRoom chat) {
    chats.add(chat);
    try{
      usersDB.doc(chat.id).set(chat.toJson());
    } catch(e) {
      
    }
    notifyListeners();
  }

  void removeChat(ChatRoom chat) {
    chats.remove(chat);
    notifyListeners();
  }

  void renameChat(ChatRoom chat, String title) {
    chat.title = title;
    notifyListeners();
  }
}
