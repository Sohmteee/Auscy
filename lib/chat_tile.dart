import 'package:auscy/chat_screen.dart';
import 'package:auscy/chat_message.dart';
import 'package:auscy/data.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:velocity_x/velocity_x.dart';

class ChatTile extends StatefulWidget {
  ChatTile({
    super.key,
    required int id,
    this.title,
    required this.chatScreen,
    required this.time,
  });

  String? title;
  final ChatScreen chatScreen;
  final DateTime time;

  List<Map<String, dynamic>> chatScreenToMap(ChatScreen chatScreen) {
    List<Map<String, dynamic>> messagesInJSON = [];

    for (ChatMessage message in chatScreen.messages) {
      messagesInJSON.add(message.toJSON());
    }

    return messagesInJSON;
  }

  Map<String, dynamic> toJSON() {
    return {
      'title': title,
      'chatScreen': chatScreen.toJSON(),
      'time': time,
    };
  }

  @override
  State<ChatTile> createState() => _ChatTileState();
}

class _ChatTileState extends State<ChatTile> {
  late Box box;

  @override
  void initState() {
    super.initState();
    // box = Hive.box('chats');

    /* if (box.get('chats') == null) box.put('chats', []);
    chats = box.get('chats'); */
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        int id = chatList.length;
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChatScreen(
              id: id,
              title: widget.title ?? "New Chat",
              messages: widget.chatScreen.messages,
            ),
          ),
        );
      },
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(1),
          decoration: const BoxDecoration(
            color: Vx.gray200,
            shape: BoxShape.circle,
          ),
          child: const CircleAvatar(
            backgroundImage: AssetImage("assets/images/auscy_icon.png"),
          ),
        ),
        title: Text(
          widget.title ?? "New Chat",
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: Vx.gray100,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        subtitle: Text(
          widget.chatScreen.messages.last.text,
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
          style: const TextStyle(
            color: Vx.gray300,
            fontSize: 12,
          ),
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              DateFormat("h:mm a").format(widget.time),
              style: const TextStyle(
                color: Vx.gray400,
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/* Container(
        padding: const EdgeInsets.all(10),
        child: Row(
          children: [
            const CircleAvatar(
              backgroundImage: AssetImage("assets/images/auscy_icon.png"),
            ),
            const SizedBox(width: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.text ?? "No Title",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Text(
                  widget.message,
                  style: const TextStyle(
                    fontSize: 12,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
       */
