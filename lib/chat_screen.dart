import 'package:chat_gpt_02/reply_preview.dart';
import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
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
  final TextEditingController _controller = TextEditingController();
  final List<ChatMessage> _messages = [];
  late OpenAI? chatGPT;

  bool _isTyping = false;

  @override
  void initState() {
    chatGPT = OpenAI.instance.build(
      token: dotenv.env['OPENAI_API_KEY'],
      baseOption: HttpSetup(receiveTimeout: 60000),
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
    if (_controller.text.isEmpty) return;
    ChatMessage message = ChatMessage(
      text: _controller.text.trim(),
      sender: MessageSender.user,
    );

    setState(() {
      _messages.insert(0, message);
      _isTyping = true;
    });

    _controller.clear();

    /* String prmpt = "";

    List<String> promptList =
        _messages.take(20).map((msg) => msg.text.trim()).toList();

    prmpt = promptList.join('\n'); */

    final request = CompleteText(
      prompt: message.text,
      model: kTranslateModelV3,
    );

    final response = await chatGPT!.onCompleteText(
      request: request,
    );
    Vx.log(response!.choices[0].text);
    insertNewData(response.choices[0].text.trim());
  }

  void insertNewData(String response) {
    ChatMessage botMessage = ChatMessage(
      text: response,
      sender: MessageSender.bot,
    );

    setState(() {
      _isTyping = false;
      _messages.insert(0, botMessage);
    });
  }

  Widget _buildTextComposer() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          child: Column(
            children: [
              buildReplyHoverBubble(),
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
                  controller: _controller,
                  textCapitalization: TextCapitalization.sentences,
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
            color: Vx.zinc200,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: IconButton(
              icon: const Icon(
                Icons.send,
              ),
              onPressed: () {
                _sendMessage();
              },
            ),
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

  Widget buildReplyHoverBubble() {
    return isResponse
        ? ReplyPreview(
            sender: replyMessage!.sender,
            text: replyMessage!.text,
            setResponse: setResponse,
            setReplyMessage: setReplyMessage,
          )
        : const SizedBox();
  }

  Widget replyPreview(MessageSender sender, String text) {
    return Container(
      padding: const EdgeInsets.all(10),
      width: double.maxFinite,
      decoration: const BoxDecoration(
          color: Vx.zinc200,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(20),
          )),
      child: IntrinsicHeight(
        child: Row(
          children: [
            Container(
              width: 5,
              decoration: const BoxDecoration(
                color: Vx.green500,
                borderRadius: BorderRadius.horizontal(
                  left: Radius.circular(8),
                ),
              ),
            ),
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: Vx.zinc300,
                  borderRadius: BorderRadius.horizontal(
                    right: Radius.circular(8),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            sender == MessageSender.user ? "You" : "ChatGPT",
                            style: const TextStyle(
                              color: Vx.green500,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                isResponse = false;
                              });
                            },
                            child: const Icon(
                              size: 20,
                              Icons.close,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 5),
                      Text(
                        text.trim(),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  return _messages[index];
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
        ));
  }
}
