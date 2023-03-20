import 'package:auscy/chatmessage.dart';
import 'package:flutter/material.dart';

enum MessageSender {
  user,
  bot,
}

String? reply;
String hintText = "Type your message here";
ChatMessage? replyMessage;

bool isTyping = false;
bool isResponse = false;

final TextEditingController controller = TextEditingController();

IconData icon = Icons.mic;

final List<ChatMessage> messages = [];

final messagesInJSON = {
  'messages': [
    {
      'text': "Hello",
      'sender': 'user',
      'isErroMessage': false,
    },
    {
      'text': "How are you?",
      'sender': 'bot',
      'isErroMessage': false,
    },
    {
      'text': "I'm good, you?",
      'sender': 'user',
      'isErroMessage': false,
    },
    {
      'text': "I'm good too",
      'sender': "bot",
      'isErroMessage': false,
    },
  ]
};

RegExp questionWordsRegex = RegExp(r')

List questionWords = [
  "what",
  "when",
  "where",
  "why",
  "how",
  "who",
  "which",
  "whose",
  "can",
  "do",
  "does",
  "will",
  "would",
  "should",
  "could",
  "is",
  "are",
  "have",
  "had",
  "did",
  "was",
  "were",
  "am",
  "shall",
  "may",
  "might",
  "must",
  "ought",
  "would",
];
