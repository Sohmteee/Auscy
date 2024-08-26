import 'package:auscy/data.dart';
import 'package:auscy/data/colors/colors.dart';
import 'package:auscy/widgets/chat_tile.dart';
import 'package:flutter/material.dart';

import 'chat.dart';

class ChatListScreen extends StatefulWidget {
  const ChatListScreen({super.key});

  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: grey700,
      appBar: AppBar(
        backgroundColor: grey700,
        elevation: 0,
        title: Row(
          children: [
            const SizedBox(width: 20),
            Text(
              "Chats",
              style: TextStyle(
                color: grey200,
                fontWeight: FontWeight.bold,
                fontSize: 25,
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: ListView.builder(
          itemCount: chatList.length,
          itemBuilder: (context, index) {
            return (chatList[index].chatScreen.messages.isEmpty)
                ? null
                : chatList.reversed.toList()[index];
          },
        ),
      ),
      floatingActionButton: GestureDetector(
        onTap: () {
          int id = chatList.length;
          setState(() {
            ChatScreen chatScreen = ChatScreen(
              id: id,
              title: "New Chat",
              messages: const [],
            );
            chatList.add(
              ChatTile(
                id: id,
                title: chatScreen.title,
                chatScreen: chatScreen,
                time: DateTime.now(),
              ),
            );
          });
          if (chatList.isNotEmpty) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => chatList[id].chatScreen,
              ),
            );
          }
        },
        child: Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: grey800,
            boxShadow: const [
              BoxShadow(
                offset: Offset(-2, 2),
                blurRadius: 2,
              )
            ],
          ),
          child: Icon(
            Icons.add,
            color: grey200,
          ),
        ),
      ),
    );
  }
}
