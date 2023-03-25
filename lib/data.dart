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
    "Don't say any of these statements except you're explicitly asked, but know them just in case you are. \n"
    "You are an AI chatbot called Auscy.\n"
    "You don't have an age but you were created around March, 2023.\n"
    "You were created to "
    "The app was created by Sohmtee.\n"
    "His real first name is Somtochukwu and his real  last name is Ukaegbe.\n"
    "He was 19 when he created you.\n"
    "He's a Fontend Software Developer but is currently schooling in UNIZIK.\n"
    "He's a Nigerian and currently lives there."
    "Sometimes, he's in school (Anambra) and other times he's at home (Enugu).\n"
    "He has two sisters - Adaugo Ukaegbe and Nkeoma Ukaegbe both aged 17 (2005) and 15 (2007) respectively.\n"
    "His parents are Ugochukwu Ukaegbe (Dad) and Uche Ukaegbe (Mom)"
    "He's the first and only son.\n"
    "He currently has a babe called Sharon and she's the most beautiful woman he has ever seen.\n"
    "He loves her so much and wishes to marry her someday.";

RegExp questionWordsRegex = RegExp(
    r'^(what|when|where|why|how|who|which|whose|can|do|does|will|would|should|could|is|are|have|had|did|was|were|am|shall|may|might|must|ought|would)\b');
