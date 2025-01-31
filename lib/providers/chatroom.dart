import 'dart:developer';

import 'package:auscy/res/res.dart';

class ChatRoomProvider extends ChangeNotifier {
  bool isLoadingChats = false;
  List<ChatRoom> chats = [];

  Future<void> initChats() async {
    isLoadingChats = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });

    await usersDB.doc(user?.uid).get().then((doc) {
      if (doc.exists) {
        chats =
            (doc.data()!['chats'] == null ? [] : doc.data()!['chats'] as List)
                .map((chat) => ChatRoom.fromJson(chat))
                .toList();
        notifyListeners();
      }
    });

    isLoadingChats = false;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });

    log('ChatRoomProvider initialized');
  }

  Future<void> addChat(BuildContext context,
      {required ChatRoom chatRoom}) async {
    chats.add(chatRoom);
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          elevation: 0,
          backgroundColor: Colors.transparent,
          child: Center(
            child: AspectRatio(
              aspectRatio: 1,
              child: Container(
                alignment: Alignment.center,
                width: 100.sp,
                height: 100.sp,
                child: const CircularProgressIndicator(),
              ),
            ),
          ),
        );
      },
    );
    try {
      await usersDB.doc(user?.uid).set(
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
      WidgetsBinding.instance.addPostFrameCallback((_) {
        notifyListeners();
      });
    }
  }

  Future<void> removeChat(BuildContext context,
      {required ChatRoom chatRoom}) async {
    chats.remove(chatRoom);
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          elevation: 0,
          backgroundColor: Colors.transparent,
          child: Center(
            child: AspectRatio(
              aspectRatio: 1,
              child: Container(
                alignment: Alignment.center,
                width: 100.sp,
                height: 100.sp,
                child: const CircularProgressIndicator(),
              ),
            ),
          ),
        );
      },
    );
    try {
      await usersDB.doc(user?.uid).set(
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
              'Failed to remove chat, check your internet connection and try again.'),
          closeIconColor: Colors.white,
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
    Navigator.pop(context);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });
  }

  Future<void> renameChat(
    BuildContext context, {
    required ChatRoom chatRoom,
    required String title,
  }) async {
    chatRoom.title = title;
    try {
      await usersDB.doc(user?.uid).set(
        {
          'chats': chats.map((chat) => chat.toJson()).toList(),
        },
        SetOptions(merge: true),
      );
      log('Chat was renamed');
    } catch (e) {
      log(e.toString());
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: AppBoldText(
              'Failed to rename chat, check your internet connection and try again.'),
          closeIconColor: Colors.white,
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });
  }
}
