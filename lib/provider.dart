import 'package:chat_gpt_02/chatmessage.dart';
import 'package:chat_gpt_02/reply_hover_bubble.dart';
import 'package:flutter/material.dart';

class MyProvider extends  ChangeNotifier {
  MyProvider({
    super.key,
    required this.sender,
    required this.text,
    required this.setResponse,
    required this.setReplyMessage,
  });

  String sender;
  String text;
  void Function(bool) setResponse;
  void Function(ChatMessage) setReplyMessage;


}
