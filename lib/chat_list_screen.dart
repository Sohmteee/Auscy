import 'package:auscy/chat_tile.dart';
import 'package:auscy/data.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:velocity_x/velocity_x.dart';

import 'chat_screen.dart';

class ChatListScreen extends StatefulWidget {
  const ChatListScreen({super.key});

  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Vx.gray700,
      appBar: AppBar(
        backgroundColor: Vx.gray700,
        elevation: 0,
        title: Row(
          children: const [
            SizedBox(width: 20),
            Text(
              "Chats",
              style: TextStyle(
                color: Vx.gray200,
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
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Vx.gray800,
            boxShadow: [
              BoxShadow(
                offset: Offset(-2, 2),
                blurRadius: 2,
              )
            ],
          ),
          child: const Icon(
            Icons.add,
            color: Vx.gray200,
          ),
        ),
      ),
    );
  }
}
