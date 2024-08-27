import 'package:auscy/models/chatroom.dart';
import 'package:auscy/providers/chatroom.dart';
import 'package:auscy/screens/chat.dart';
import 'package:auscy/widgets/text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconly/iconly.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    context.read<ChatRoomProvider>().initChats();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ChatRoomProvider>(
      builder: (context, chatRoomProvider, _) {
        final chats = chatRoomProvider.chats;

        return Scaffold(
          appBar: AppBar(
            title: AppBoldText(
              'Chat History',
            ),
          ),
          floatingActionButton: Padding(
            padding: EdgeInsets.only(
              right: 6.w,
              bottom: 10.h,
            ),
            child: FloatingActionButton(
              backgroundColor: Theme.of(context).primaryColor,
              onPressed: () async {
                String id = const Uuid().v4();
                List<types.Message> messages = [];

                await chatRoomProvider.addChat(
                  context,
                  chatRoom: ChatRoom(
                    id: id,
                    title: 'New Chat',
                    messages: messages,
                    chat: Chat(
                      onSendPressed: (message) {},
                      user: const types.User(
                        id: 'user',
                        firstName: 'You',
                        role: types.Role.user,
                      ),
                      messages: const [],
                    ),
                  ),
                );

                debugPrint(
                    'Chats: ${chats.map((chat) => chat.title).toList()}');

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChatScreen(
                      chatRoom: chats.singleWhere((chat) => chat.id == id),
                    ),
                  ),
                );
              },
              child: const Icon(
                Icons.add,
              ),
            ),
          ),
          body: chats.isEmpty
              ? Center(
                  child: AppText(
                    'No chats yet',
                    color: Colors.grey,
                  ),
                )
              : ListView.builder(
                  itemCount: chats.length,
                  physics: const BouncingScrollPhysics(),
                  itemBuilder: (context, index) {
                    final chatRoom = chats[chats.length - index - 1];

                    return ListTile(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ChatScreen(
                              chatRoom: chatRoom,
                            ),
                          ),
                        );
                      },
                      title: AppBoldText(
                        chatRoom.title,
                      ),
                      trailing: PopupMenuButton<int>(
                        onSelected: (int result) async {
                          if (result == 1) {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return Dialog(
                                    child: Padding(
                                      padding: EdgeInsets.all(20.w),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          AppBoldText(
                                            'Rename Chat',
                                            fontSize: 20.sp,
                                          ),
                                          SizedBox(height: 20.h),
                                          TextField(
                                            controller: TextEditingController(
                                                text: chatRoom.title),
                                            autofocus: true,
                                            decoration: const InputDecoration(
                                              hintText: 'Enter new chat title',
                                            ),
                                            textCapitalization:
                                                TextCapitalization.words,
                                            onSubmitted: (value) async {
                                              await chatRoomProvider.renameChat(
                                                context,
                                                chatRoom: chatRoom,
                                                title: value,
                                              );
                                              Navigator.pop(context);
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                });
                          } else if (result == 2) {
                            await chatRoomProvider.removeChat(context,
                                chatRoom: chatRoom);
                          }
                        },
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                        itemBuilder: (BuildContext context) =>
                            <PopupMenuEntry<int>>[
                          PopupMenuItem<int>(
                            value: 1,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(IconlyLight.edit),
                                SizedBox(width: 10.w),
                                const Text('Rename'),
                              ],
                            ),
                          ),
                          PopupMenuItem<int>(
                            value: 2,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(IconlyLight.delete),
                                SizedBox(width: 10.w),
                                const Text('Delete'),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
        );
      },
    );
  }
}
