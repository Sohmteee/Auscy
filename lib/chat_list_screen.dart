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
      floatingActionButton: Container(
        padding: const EdgeInsets.all(15),
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Vx.gray800,
        ),
        child: const Icon(
          Icons.add,
          color: Vx.gray200,
        ),
      ),
    );
  }
}
