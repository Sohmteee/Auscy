import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:toast/toast.dart';
import 'package:velocity_x/velocity_x.dart';

import 'data.dart';

class ChatMessage extends StatefulWidget {
  const ChatMessage({
    super.key,
    required this.text,
    required this.sender,
    this.isErroMessage,
  });

  final String text;
  final MessageSender sender;
  final bool? isErroMessage;

  @override
  State<ChatMessage> createState() => _ChatMessageState();
}

class _ChatMessageState extends State<ChatMessage> {
  Map<String, dynamic> toJSON(){
    return {
      'text' : widget.text,
      'sender' : widget.sender == MessageSender.user ? "user" : "bot",
      'isErroMessage' : widget.isErroMessage,
    };
  }

  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);
    return Row(
      mainAxisAlignment: widget.sender == MessageSender.user
          ? MainAxisAlignment.end
          : MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.sender == MessageSender.bot)
          Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              child: const CircleAvatar(
                radius: 15,
                backgroundColor: Vx.zinc200,
                backgroundImage: AssetImage("assets/images/chatgpt_icon.png"),
              ),
            ),
          ),
        GestureDetector(
          onLongPress: () async {
            await Clipboard.setData(
              ClipboardData(
                text: widget.text.trim(),
              ),
            );
            Toast.show("Copied Text to Clipbord",
                duration: Toast.lengthShort, gravity: Toast.bottom);
          },
          child: ChatBubble(
            clipper: ChatBubbleClipper8(
                type: widget.sender == MessageSender.user
                    ? BubbleType.sendBubble
                    : BubbleType.receiverBubble),
            margin: const EdgeInsets.only(top: 20),
            backGroundColor: widget.sender == MessageSender.user
                ? Vx.green500
                : widget.isErroMessage ?? false
                    ? Vx.red500
                    : Vx.zinc200,
            child: Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.7,
              ),
              child: Text(
                widget.text.trim(),
                style: TextStyle(
                  color: widget.sender == MessageSender.user
                      ? Colors.white
                      : widget.isErroMessage ?? false
                          ? Colors.white
                          : Colors.black,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
