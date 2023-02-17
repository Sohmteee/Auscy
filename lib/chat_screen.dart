import 'package:chat_gpt_02/provider.dart';
import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:swipe_to/swipe_to.dart';
import 'package:velocity_x/velocity_x.dart';

import 'chatmessage.dart';
import 'data.dart';
import 'threedots.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  // final TextEditingController controller = TextEditingController();
  // final List<ChatMessage> messages = [];
  // late OpenAI? chatGPT;

  bool _isTyping = false;
  bool isResponse = false;

  @override
  void initState() {
    chatGPT = OpenAI.instance.build(
      token: dotenv.env['OPENAI_API_KEY'],
      baseOption: HttpSetup(receiveTimeout: 5000),
      isLogger: true,
    );

    super.initState();
  }

  @override
  void dispose() {
    chatGPT?.close();
    chatGPT?.genImgClose();
    super.dispose();
  }

  // Link for api - https://beta.openai.com/account/api-keys

  void _sendMessage() async {
    if (controller.text.isEmpty) return;
    ChatMessage message = ChatMessage(
      text: controller.text.trim(),
      sender: MessageSender.user,
    );

    setState(() {
      messages.insert(0, message);
      _isTyping = true;
    });

    controller.clear();

    String prompt = "";
    int start = (messages.length < 10) ? 0 : (messages.length - 10);

    List<String> last10Texts =
        messages.sublist(start).map((message) => message.text).toList();

    last10Texts = last10Texts.reversed.toList();

    prompt = "${last10Texts.join('\n')}.";

    final request = CompleteText(
      prompt: prompt,
      model: kTranslateModelV3,
      maxTokens: 2000,
      stop: ["\"\""],
    );

    try {
      final response = await chatGPT!.onCompleteText(
        request: request,
      );
      Vx.log(response!.choices[0].text);
      insertNewData(response.choices[0].text.trim());
    } catch (e) {
      insertNewData(e.toString());
    }
  }

  void insertNewData(String response) {
    if (response.trim() == "") _sendMessage();

    ChatMessage botMessage = ChatMessage(
      text: response
          : "An error occured.\nCouldn't get response.\nPlease try again",
      sender: MessageSender.bot,
    );

    setState(() {
      _isTyping = false;
      messages.insert(0, botMessage);
    });
  }

  Widget _buildTextComposer() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Vx.zinc200,
                  borderRadius: isResponse
                      ? const BorderRadius.vertical(bottom: Radius.circular(20))
                      : BorderRadius.circular(20),
                ),
                child: TextField(
                  autofocus: true,
                  controller: controller,
                  textCapitalization: TextCapitalization.sentences,
                  keyboardType: TextInputType.multiline,
                  minLines: 1,
                  maxLines: 6,
                  textInputAction: TextInputAction.newline,
                  onSubmitted: (value) => _sendMessage(),
                  decoration: InputDecoration.collapsed(
                    hintText: hintText,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 10),
        Container(
          decoration: const BoxDecoration(
            color: Vx.green500,
            shape: BoxShape.circle,
          ),
          child: IconButton(
            icon: const Icon(
              color: Vx.white,
              Icons.send,
            ),
            onPressed: () {
              _sendMessage();
            },
          ),
        ),
      ],
    ).px16();
  }

  void setResponse(bool val) {
    setState(() {
      isResponse = val;
    });
  }

  void setReplyMessage(ChatMessage message) {
    setState(() {
      replyMessage = message;
    });
  }

  Widget chatMessage(String text, MessageSender sender) {
    return SwipeTo(
      onRightSwipe: () {
        setState(() {
          isResponse = true;
          replyMessage = ChatMessage(
            text: text,
            sender: sender,
          );
          debugPrint("Replying to: ${replyMessage!.text}");
        });
      },
      child: Row(
        mainAxisAlignment: sender == MessageSender.user
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (sender == MessageSender.bot)
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
                child: const CircleAvatar(
                  radius: 15,
                  backgroundColor: Vx.zinc200,
                  backgroundImage: AssetImage("assets/images/chatgpt_icon.png"),
                ),
              ),
            ),
          ChatBubble(
            clipper: ChatBubbleClipper8(
                type: sender == MessageSender.user
                    ? BubbleType.sendBubble
                    : BubbleType.receiverBubble),
            margin: const EdgeInsets.only(top: 20),
            backGroundColor:
                sender == MessageSender.user ? Vx.green500 : Vx.zinc200,
            child: Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.7,
              ),
              child: Text(
                text.trim(),
                style: TextStyle(
                  color: sender == MessageSender.user
                      ? Colors.white
                      : Colors.black,
                  fontSize: 16,
                ),
              ),
            ),
          ),
          if (sender == MessageSender.user)
            Padding(
              padding: const EdgeInsets.only(top: 23),
              child: Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
                child: const CircleAvatar(
                  radius: 15,
                  backgroundColor: Vx.green500,
                  child: Icon(
                    size: 18,
                    color: Colors.white,
                    Icons.person,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<MyProvider>(
      create: (_) => MyProvider(),
      child: Consumer<MyProvider>(
        builder: (context, model, child) {
          return Scaffold(
            appBar: AppBar(
              leading: const Padding(
                padding: EdgeInsets.all(8.0),
                child: CircleAvatar(
                  backgroundImage: AssetImage("assets/images/chatgpt_icon.png"),
                ),
              ),
              title: const Text(
                "ChatGPT",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 25,
                ),
              ),
            ),
            body: SafeArea(
              child: Column(
                children: [
                  Flexible(
                      child: ListView.builder(
                    reverse: true,
                    padding: Vx.m8,
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      return messages[index];
                    },
                  )),
                  if (_isTyping) const ThreeDots(),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10, 10, 0, 10),
                    child: Column(
                      children: [
                        _buildTextComposer(),
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
