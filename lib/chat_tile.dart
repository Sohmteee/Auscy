import 'package:auscy/chat_screen.dart';
import 'package:auscy/chatmessage.dart';
import 'package:auscy/functions.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:velocity_x/velocity_x.dart';

class ChatTile extends StatefulWidget {
  const ChatTile({
    super.key,
    this.title,
    required this.messages,
    required this.time,
  });

  final String? title;
  final List<ChatMessage> messages;
  final DateTime time;

  List<Map<String, dynamic>> listToMap(List<ChatMessage> messages) {
    List<Map<String, dynamic>> messagesInJSON = [];

    for (ChatMessage message in messages) {
      messagesInJSON.add(message.toJSON());
    }

    return messagesInJSON;
  }

  Map<String, dynamic> toJSON() {
    return {
      'title': title,
      'message': listToMap(messages),
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
    box = Hive.box('chats');
    
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChatScreen(
              title: widget.title ?? "New Chat",
              messages: [],
            ),
          ),
        );
      },
      child: ListTile(
        leading: const CircleAvatar(
          backgroundImage: AssetImage("assets/images/auscy_icon.png"),
        ),
        title: Text(
          widget.title ?? "New Chat",
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        subtitle: Text(
          widget.messages.last.text,
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
          style: const TextStyle(
            fontSize: 12,
          ),
        ),
        trailing: Text(
          DateFormat("h:mm a").format(widget.time),
          style: const TextStyle(
            color: Vx.gray400,
            fontSize: 10,
          ),
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
