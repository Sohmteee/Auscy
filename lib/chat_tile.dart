import 'package:flutter/material.dart';

class ChatTile extends StatefulWidget {
  const ChatTile({
    super.key,
    this.text,
    required this.message,
  });

  final String? text;
  L

  @override
  State<ChatTile> createState() => _ChatTileState();
}

class _ChatTileState extends State<ChatTile> {
  @override
  Widget build(BuildContext context) {
    return Container(
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
                widget.text ?? "",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              Text(
                widget.text ?? "",
                style: const TextStyle(
                  fontSize: 12,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
