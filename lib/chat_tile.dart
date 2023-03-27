import 'package:flutter/material.dart';

class ChatTile extends StatefulWidget {
  const ChatTile({
    super.key,
    this.text,

  });

  final String? text;

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
            children: [
              (widget.text != null)
                Text(
                  widget.text!,
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                ),
            ],
          )
        ],
      ),
    );
  }
}
