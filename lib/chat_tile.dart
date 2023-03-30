import 'package:auscy/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:velocity_x/velocity_x.dart';

class ChatTile extends StatefulWidget {
  const ChatTile({
    super.key,
    this.text,
    required this.index,
    required this.message,
    required this.time,
  });

  final String? text;
  final int index;
  final String message;
  final DateTime time;

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
              title: widget.text ?? "No title",
            ),
          ),
        );
      },
      child: ListTile(
        leading: const CircleAvatar(
          backgroundImage: AssetImage("assets/images/auscy_icon.png"),
        ),
        title: Text(
          widget.text ?? "No Title",
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        subtitle: Text(
          widget.message,
          style: const TextStyle(
            fontSize: 12,
          ),
        ),
        trailing: Align(
          alignment: MainAxisAlignment.end,
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
