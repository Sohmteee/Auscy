import 'dart:convert';

import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:http/http.dart' as http;

import 'chatmessage.dart';
import 'data.dart';
import 'package:openai_gpt3_api/openai_gpt3_api.dart';

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
      baseOption: HttpSetup(receiveTimeout: 10000),
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

  Future<String> generateRequest(String prompt) async {
    final apiKey = dotenv.env['OPENAI_API_KEY'];
    var url = Uri.https("api.openai.com", "/v1/completions");
    final response = await http.post(url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $apiKey',
        },
        body: jsonEncode({
          'model': 'text-davinci-003',
          'prompt': prompt.trim(),
          'temperature': 0.3,
          'max_token': 4000,
          'top_p': 1,
          'frequency_penalty': 0.0,
          'presence_penalty': 0.0,
        }));

    Map<String, dynamic> newResponse = jsonDecode(response.body);
    debugPrint(newResponse['choices'][0]['text']);
    return newResponse['choices'][0]['text'];
  }

  String? endsWithPunctuation(String inputString) {
    if (inputString.endsWith('.') ||
        inputString.endsWith('?') ||
        inputString.endsWith('!')) {
      return null;
    } else {
      return '.';
    }
  }

  String getLast20Texts() {
    int start = (messages.length < 20) ? 0 : (messages.length - 19);

    List<String> last20Texts =
        messages.sublist(start).map((message) => message.text).toList();

    return last20Texts.join('\n');
  }

  void _sendMessage() async {
    String text = controller.text;

    if (text.trim().isEmpty) return;

    String? punctuation = endsWithPunctuation(text.trim());
    if (punctuation != null) text += punctuation;

    ChatMessage message = ChatMessage(
      text: text.trim(),
      sender: MessageSender.user,
    );

    setState(() {
      messages.add(message);
      _isTyping = true;
    });

    controller.clear();
    setState(() {
      icon = text.trim().isNotEmpty ? Icons.send : Icons.mic;
    });

    String prompt = getLast20Texts();

    /* try {
      final response = generateRequest(prompt);

      if (response.toString().trim() == "") {
        _sendMessage();
      } else {
        insertNewData(response.toString().trim(), false);
      }
    } catch (e) {
      debugPrint(e.toString());
      insertNewData(
          "This error occured while trying to respond: \n$e"
          "\nCould you please resend your last message?"
          "\nYou can simply copy your message by long-pressing it",
          true);
    } */

    /* final request = CompleteText(
      prompt: prompt,
      model: kTranslateModelV3,
      maxTokens: 4000,
    );

    try {
      final response = await chatGPT!.onCompleteText(
        request: request,
      );
      Vx.log(response!.choices[0].text);

      if (response.choices[0].text.trim() == "") {
        _sendMessage();
      } else {
        insertNewData(response.choices[0].text.trim(), false);
      }
    } catch (e) {
      debugPrint(e.toString());
      insertNewData(
          "This error occured while trying to respond: \n$e"
          "\nCould you please resend your last message?"
          "\nYou can simply copy your message by long-pressing it",
          true);
    } */

    try {
      final response = await generateRequest(prompt);
      Vx.log(response);

      if (response.trim() == "") {
        _sendMessage();
      } else {
        insertNewData(response.trim(), false);
      }
    } catch (e) {
      debugPrint(e.toString());
      insertNewData(
          "This error occured while trying to respond: \n$e"
          "\nCould you please resend your last message?"
          "\nYou can simply copy your message by long-pressing it",
          true);
    }
  }

  void insertNewData(String response, bool isErrorMessage) {
    ChatMessage botMessage = ChatMessage(
      text: response,
      sender: MessageSender.bot,
      isErroMessage: isErrorMessage,
    );

    setState(() {
      _isTyping = false;
      messages.add(botMessage);
    });
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
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
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
                _isTyping = false;
                setState(() {
                  icon = controller.text.trim().isNotEmpty
                      ? Icons.send
                      : Icons.mic;
                });
              }),
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  "Reset",
                  style: TextStyle(
                    color: Colors.white,
                  ),
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
                reverse: true,
                itemCount: messages.length,
                controller: scrollController,
                itemBuilder: (context, index) {
                  return messages.reversed.toList()[index];
                },
              ),
            ),
            if (_isTyping)
              const SpinKitThreeBounce(
                color: Colors.black,
                size: 30.0,
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
