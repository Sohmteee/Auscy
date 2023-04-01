import 'package:auscy/chat_tile.dart';
import 'package:auscy/data.dart';
import 'package:flutter/material.dart';
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
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Row(
          children: const [
            SizedBox(width: 20),
            Text(
              "Chats",
              style: TextStyle(
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
            /* return (chatList[index].chatScreen.messages.isEmpty)
                ? null
                : chatList[index]; */
            return chatList[index];
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Vx.black,
        onPressed: () {
          int id = chatList.length;
          chatList.add(
            ChatTile(
              id: id,
              chatScreen: ChatScreen(
                title: "New Chat",
                messages: const [],
              ),
              time: DateTime.now(),
            ),
          );
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => chatList[id].chatScreen,
            ),
          );
        },
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}
