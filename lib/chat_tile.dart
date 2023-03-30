import 'package:auscy/chat_screen.dart';
import 'package:flutter/material.dart';

class ChatTile extends StatefulWidget {
  const ChatTile({
    super.key,
    this.text,
    required this.index,
    required this.message,
  });

  final String? text;
  final int index;
  final String message;

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
        
      )
  }
}
