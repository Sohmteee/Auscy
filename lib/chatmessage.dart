import 'package:chat_gpt_02/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:swipe_to/swipe_to.dart';
import 'package:velocity_x/velocity_x.dart';

import 'data.dart';

class ChatMessage extends StatefulWidget {
  ChatMessage({
    super.key,
    required this.text,
    required this.sender,
    this.isReply = false,
  });

  final String text;
  final String sender;
  bool isReply;

  void toggleReply() {
    isReply = true;
  }

  @override
  State<ChatMessage> createState() => _ChatMessageState();
}

class _ChatMessageState extends State<ChatMessage> {
  @override
  Widget build(BuildContext context) {
    return SwipeTo(
      onRightSwipe: () {
        setState(() {
          isResponse = true;
          replyMessage = ChatMessage(
            text: widget.text,
            sender: widget.sender,
          );
          debugPrint("Replying to: ${replyMessage!.text}");
        });
      },
      child: ChatBubble(
        clipper: ChatBubbleClipper8(
            type: widget.sender == "user"
                ? BubbleType.sendBubble
                : BubbleType.receiverBubble),
        alignment:
            widget.sender == "user" ? Alignment.topRight : Alignment.topLeft,
        margin: const EdgeInsets.only(top: 20),
        backGroundColor: widget.sender == "user" ? Vx.green500 : Vx.zinc200,
        child: Container(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.7,
          ),
          child: Text(
            widget.text.trim(),
            style: TextStyle(
              color: widget.sender == "user" ? Colors.white : Colors.black,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }
}

class ChatMessageData with ChangeNotifier {
  bool isReply(ChatMessage chatMessage)
  void toggleReply(ChatMessage chatMessage) {
    chatMessage.toggleReply();
    notifyListeners();
  }
}
