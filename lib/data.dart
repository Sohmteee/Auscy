import 'package:auscy/chatmessage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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

List messages = [];

final db = FirebaseFirestore.instance;

dob() {
  for (ChatMessage message in messages) {
    messagesInJSON['messages']?.add(message.toJSON());
  }
}

final Map<String, List<Map<String, dynamic>>> messagesInJSON = {
  'messages': [
    /* {
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
    }, */
  ]
};

String initPrompt =
    "Sohmtee, a 19-year-old Nigerian Frontend Software Developer,"
    "created Auscy(You), an AI chatbot, in March 2023. He is currently studying Computer Science at UNIZIK and lives in Anambra and Enugu. He has two younger sisters, Adaugo and Nkeoma, and his parents are Ugochukwu and Uche Ukaegbe. He is in a relationship with Sharon Oyetunji Eyinjuoluwa, a 20-year-old Frontend Web Developer who is also studying at UNIZIK, and she has two younger brothers.";

RegExp questionWordsRegex = RegExp(
    r'^(what|when|where|why|how|who|which|whose|can|do|does|will|would|should|could|is|are|have|had|did|was|were|am|shall|may|might|must|ought|would)\b');
