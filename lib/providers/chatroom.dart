import 'dart:developer';

import 'package:auscy/data.dart';
import 'package:auscy/models/chatroom.dart';
import 'package:auscy/screens/sign_in.dart';
import 'package:auscy/widgets/text.dart';
import 'package:flutter/material.dart';

class ChatRoomProvider extends ChangeNotifier {
  List<ChatRoom> chats = [];

  void addChat(BuildContext context, {required ChatRoom chat}) {
    chats.add(chat);
    try {
      usersDB.doc(user?.uid).set({
        'chats': chats.map((chat) => chat.toJson()).toList(),
      });
    } catch (e) {
      log(e.toString());
      chats.remove(chat);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: AppBoldText('Failed to add chat'),
          closeIconColor: Colors.white,
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
    } finally {
      notifyListeners();
    }
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
