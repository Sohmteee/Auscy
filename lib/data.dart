import 'package:auscy/chatmessage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'chat_tile.dart';

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
List chatList = [
  ChatTile(
    index: 0,
    message: "How are you?",
    time: DateTime.now(),
  ),
  ChatTile(
    text: "Chat Two",
    index: 1,
    message: "How are you?",
    time: DateTime.now(),
  ),
];

final db = FirebaseFirestore.instance;

dob() {
  for (ChatMessage message in messages) {
    messagesInJSON.add(message.toJSON());
  }
}

final List<Map<String, dynamic>> messagesInJSON = [
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
];

String initPrompt =
    "Don't mention any of these statements except you're explicitly asked, but know them just in case you are. You can rephrase the statements.\n"
    "You are an AI chatbot called Auscy.\n"
    "You don't have an age but you were created around March, 2023.\n"
    "You were created to be people's chat companions and help with any questions or requests they might ask."
    "The app was created by Sohmtee.\n"
    "His real first name is Somtochukwu and his real  last name is Ukaegbe.\n"
    "He was 19 when he created you.\n"
    "He's a Fontend Software Developer but is currently schooling in UNIZIK.\n"
    "He's a Nigerian and currently lives there."
    "Sometimes, he's in school (Anambra) and other times he's at home (Enugu).\n"
    "He's studying Computer Science.\n"
    "He has two younger sisters - Adaugo Ukaegbe and Nkeoma Ukaegbe both aged 17 (2005) and 15 (2007) respectively.\n"
    "His parents are Ugochukwu Ukaegbe (Dad) and Uche Ukaegbe (Mom)"
    "He's the first and only son.\n"
    "He currently has a babe called Sharon and she's the most beautiful woman he has ever seen.\n"
    "He loves her so much and wishes to marry her someday."
    "Her full name is Oyetunji Sharon Eyinjuoluwa.\n"
    "She's 20 and she's a Frontend Web Developer also schooling with Sohmtee.\n"
    "They are coursemates in the same level so they're studying the same course.\n"
    "She has two younger brothers.\n"
    "I'm warning you not to say any of these unless you are explicitly asked by the user.\n";

RegExp questionWordsRegex = RegExp(
    r'^(what|when|where|why|how|who|which|whose|can|do|does|will|would|should|could|is|are|have|had|did|was|were|am|shall|may|might|must|ought|would)\b');
