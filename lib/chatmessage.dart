import 'package:chat_gpt_02/provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:provider/provider.dart';
import 'package:swipe_to/swipe_to.dart';
import 'package:toast/toast.dart';
import 'package:velocity_x/velocity_x.dart';

import 'data.dart';

class ChatMessage extends StatefulWidget {
  const ChatMessage({
    super.key,
    required this.text,
    required this.sender,
  });

  final String text;
  final MessageSender sender;

  @override
  State<ChatMessage> createState() => _ChatMessageState();
}

class _ChatMessageState extends State<ChatMessage> with ChangeNotifier {
  bool _isResponse = false;
  bool get isResponse => _isResponse;

  set setResponse(bool value) {
    _isResponse = value;
    notifyListeners();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<MyProvider>(
      create: (_) => MyProvider(),
      child: Consumer<MyProvider>(
        builder: (context, model, child) {
          return SwipeTo(
            onRightSwipe: () {
              setState(() {
                model.setResponse(true);
                replyMessage = ChatMessage(
                  text: widget.text,
                  sender: widget.sender,
                );
                debugPrint("Replying to: ${replyMessage!.text}");
              });
            },
            child: Row(
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
                        backgroundImage:
                            AssetImage("assets/images/chatgpt_icon.png"),
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
                    Toast.show("Copied text to clipbord",
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
                              : Colors.black,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ),
                if (widget.sender == MessageSender.user)
                  Padding(
                    padding: const EdgeInsets.only(top: 23),
                    child: Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
                      child: const CircleAvatar(
                        radius: 15,
                        backgroundColor: Vx.green500,
                        child: Icon(
                          size: 18,
                          color: Colors.white,
                          Icons.person,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
