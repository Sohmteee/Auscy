import 'package:chat_gpt_02/chatmessage.dart';
import 'package:chat_gpt_02/reply_hover_bubble.dart';
import 'package:flutter/material.dart';

class MyProvider extends StatefulWidget with ChangeNotifier {
  MyProvider({
    super.key,
    String sender;
  String text;
  void Function(bool) setResponse;
  void Function(ChatMessage) setReplyMessage;

  MyProvider({
    required this.sender,
    required this.text,
    required this.setResponse,
    required this.setReplyMessage,
  });

  ReplyHoverBubble replyHoverBubble = ReplyHoverBubble(sender: sender, text: text, setResponse: setResponse, setReplyMessage: setReplyMessage);

  });

  @override
  State<MyProvider> createState() => _MyProviderState();
}

class _MyProviderState extends State<MyProvider> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
