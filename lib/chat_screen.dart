import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:velocity_x/velocity_x.dart';

import 'chatmessage.dart';
import 'data.dart';
import 'functions.dart';
import 'threedots.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
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
      messages.add(message);
      _isTyping = true;
    });

    controller.clear();
    scrollToBottom();

    String prompt = "";
    int start = (messages.length < 20) ? 0 : (messages.length - 20);

    List<String> last20Texts =
        messages.sublist(start).map((message) => message.text).toList();

    prompt = "${last20Texts.join('\n')}.";

    final request = CompleteText(
      prompt: prompt,
      model: kTranslateModelV3,
      maxTokens: 4000,
    );

    try {
      final response = await chatGPT!.onCompleteText(
        request: request,
      );
      // Vx.log(response!.choices[0].text);

      if (response!.choices[0].text.trim() == "") {
        _sendMessage();
      } else {
        insertNewData(response.choices[0].text.trim(), false);
      }
    } catch (e) {
      debugPrint(e.toString());
      insertNewData(
          "This error occured while trying to respond: \n\n$e"
          "\nCould you please resend your last message?"
          "\nYou can simply copy your message by long-pressing it",
          true);
    }
    scrollToBottom();
  }

  void insertNewData(String response, bool isErrorMessage) {
    ChatMessage botMessage = ChatMessage(
      text: response,
      sender: MessageSender.bot,
      isErroMessage: isErrorMessage,
    );

    scrollToBottom();

    setState(() {
      _isTyping = false;
      messages.add(botMessage);
    });

    scrollToBottom();
  }

  Widget _buildTextComposer() {
    toggleSend() {
      setState(() {
        icon = controller.text.trim().isNotEmpty ? Icons.send : Icons.mic;
      });
    }

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
                  onChanged: (value) {
                    setState(() {
                      toggleSend();
                    });
                  },
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
            icon: Icon(
              color: Vx.white,
              icon,
            ),
            onPressed: () {
              _sendMessage();
            },
          ),
        ),
      ],
    ).px16();
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
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "ChatGPT",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 25,
              ),
            ),
            GestureDetector(
              onTap: () => setState(() {
                messages.clear();
              }),
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  "Reset",
                  style: TextStyle(color: Colors.white,),
                ),
              ),
            )
          ],
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Flexible(
                child: ListView.builder(
              padding: Vx.m8,
              itemCount: messages.length,
              controller: scrollController,
              itemBuilder: (context, index) {
                return messages[index];
              },
            )),
            if (_isTyping)
              Container(
                color: Colors.transparent,
                child: const ThreeDots(),
              ),
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
  }
}
