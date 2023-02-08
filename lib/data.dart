import 'package:chat_gpt_02/chatmessage.dart';

enum ChatMessageType {
  user,
  bot,
}

String? reply;
String hintText = "Type your message here";
ChatMessage? replyMessage;

bool isResponse = false;
