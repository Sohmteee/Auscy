import 'package:chat_gpt_02/chatmessage.dart';
import 'package:flutter/material.dart';

enum MessageSender {
  user,
  bot,
}

String? reply;
String hintText = "Type your message here";
ChatMessage? replyMessage;

bool isResponse = false;

final TextEditingController controller = TextEditingController();
