import 'package:auscy/chat_screen.dart';
import 'package:auscy/chatmessage.dart';
import 'package:flutter/material.dart';
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

  listToMap

  Map<String, dynamic> toJSON() {
    return {
      'title': title,
      'message': messages,
      'time': DateFormat("h:mm a").format(time),
    };
  }

  @override
  State<ChatTile> createState() => _ChatTileState();
}

class _ChatTileState extends State<ChatTile> {
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
          widget.messages,
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
