import 'dart:developer';

import 'package:auscy/data.dart';
import 'package:auscy/models/chatroom.dart';
import 'package:auscy/screens/sign_in.dart';
import 'package:auscy/widgets/text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ChatRoomProvider extends ChangeNotifier {
  List<ChatRoom> chats = [];

  void addChat(BuildContext context, {required ChatRoom chatRoom}) {
    chats.add(chatRoom);
    showDialog(
        context: context,
        builder: (context) {
          return SizedBox(
            width: 100.sp,
            height: 100.sp,
            child: const CircularProgressIndicator(),
          );
        });
    try {
      usersDB.doc(user?.uid).set(
        {
          'chats': chats.map((chat) => chat.toJson()).toList(),
        },
        SetOptions(merge: true),
      );
      log('Chat was added');
    } catch (e) {
      log(e.toString());
      chats.remove(chatRoom);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: AppBoldText(
              'Failed to add chat, check your internet connection and try again.'),
          closeIconColor: Colors.white,
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
    } finally {
      Navigator.pop(context);
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
