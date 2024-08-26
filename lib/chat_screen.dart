import 'dart:convert';
import 'dart:developer';

import 'package:auscy/data/colors/colors.dart';
import 'package:auscy/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:hive_flutter/hive_flutter.dart';
// import 'package:http/http.dart' as http;

// import 'package:velocity_x/velocity_x.dart';

import 'data.dart';
import 'widgets/chat_message.dart';

class ChatScreen extends StatefulWidget {
  ChatScreen({
    super.key,
    required this.id,
    this.title,
    required this.messages,
  });

  int id;
  String? title;
  List<ChatMessage> messages;

  List<Map<String, dynamic>> listToMap(List<ChatMessage> messages) {
    List<Map<String, dynamic>> messagesInJSON = [];

    for (ChatMessage message in messages) {
      messagesInJSON.add(message.toJSON());
    }

    return messagesInJSON;
  }

  Map<String, dynamic> toJSON() {
    return {
      'title': title,
      'messages': listToMap(messages),
    };
  }

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  bool _isTyping = false;
  bool isResponse = false;
  late final Box box;
  final gemini = GenerativeModel(
      model: "gemini-1.5-flash",
      apiKey: apiKey,
      generationConfig: GenerationConfig(
        temperature: .7,
      ));
  // double t

  @override
  void initState() {
    super.initState();
    /* box = Hive.box("messages");
    if (box.get("messages") == null) box.put("messages", []);
    messages = box.get("messages"); */
  }

  @override
  void dispose() {
    // Hive.close();
    super.dispose();
    if (widget.messages.isEmpty) {
      chatList.removeAt(widget.id);
    }
  }

  // Link for api - https://beta.openai.com/account/api-keys

  Future<List<Content>> segmentChat({int length = 20}) async {
    final messages = widget.messages.take(length).toList().reversed.toList();

    final List<Content> contents = [];

    for (var message in messages) {
      // String role = message.author.id == yamDoctor.id ? 'yam doctor' : 'user';
      contents.add(
        Content.text(message.text),
      );
    }

    debugPrint(contents.toString());
    return contents;
  }

  Future<String> generateResponse({String? prePrompt}) async {
    final messages = await segmentChat();

    final response = await gemini
        .generateContent([
          if (prePrompt != null) Content.text(prePrompt),
          ...messages,
        ])
        .then((value) =>
            value.candidates.first.text?.trim() ??
            'I can\'t help you with that.')
        .catchError((error) =>
            'It looks like an error occurred. Check your internet connection and try again.');

    return response;
  }

  void _sendMessage() async {
    String text = controller.text.trim();

    if (text.isEmpty) return;

    ChatMessage message = ChatMessage(
      text: text,
      sender: MessageSender.user,
      time: DateTime.now(),
    );

    setState(() {
      widget.messages = [...widget.messages, message];
      // box.put("messages", messages);
      // messagesInJSON['messages']?.add(message.toJSON());
      _isTyping = true;
      icon = Icons.mic;
    });

    controller.clear();

    try {
      final response = await generateResponse();
      log(response.trim());

      if (response.trim() == "") {
        setState(() {
          _isTyping = false;
        });
      } else {
        insertNewData(response.trim(), false);
      }

      if (widget.messages.length > 5 && widget.title == "New Chat") {
        final title = await generateResponse(
           prePrompt:  "In 3 words or less, summarize this in form of a title.");
        log(title);

        setState(() {
          widget.title = str;
          chatList[widget.id].title = str;
        });
      }
    } catch (e) {
      debugPrint(e.toString());
      showDialog(
        context: context,
        builder: (context) {
          return errorDialog(e);
        },
      );
      _isTyping = false;
    }
  }

  Dialog errorDialog(e) {
    return Dialog(
      backgroundColor: red500,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Container(
        padding: const EdgeInsets.all(20),
        child: Text(
          e.toString().trim(),
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  void insertNewData(String response, bool isErrorMessage) {
    ChatMessage botMessage = ChatMessage(
      text: response,
      sender: MessageSender.bot,
      time: DateTime.now(),
    );

    setState(() {
      _isTyping = false;
      widget.messages.add(botMessage);
      // box.put("messages", messages);
      // messagesInJSON['messages']?.add(botMessage.toJSON());
      // createMessage(username: "Sohmtee");
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
                  color: grey200,
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
                  spellCheckConfiguration: const SpellCheckConfiguration(),
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
          decoration: BoxDecoration(
            color: grey900,
            shape: BoxShape.circle,
            boxShadow: const [
              BoxShadow(
                offset: Offset(-2, 2),
                blurRadius: 2,
              )
            ],
          ),
          child: IconButton(
            icon: Icon(
              color: grey200,
              icon,
            ),
            onPressed: () {
              _sendMessage();
            },
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: grey700,
      appBar: AppBar(
        backgroundColor: grey700,
        elevation: 0,
        leading: BackButton(
          color: grey200,
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                widget.title == null ? "New Chat" : widget.title!,
                maxLines: 2,
                style: TextStyle(
                  color: grey200,
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                ),
              ),
            ),
            GestureDetector(
              onTap: () => setState(() {
                widget.messages.clear();
                // box.put("messages", messages);
                _isTyping = false;
                setState(() {
                  icon = controller.text.trim().isNotEmpty
                      ? Icons.send
                      : Icons.mic;
                });
              }),
              child: Container(
                padding: const EdgeInsets.all(13),
                decoration: BoxDecoration(
                  color: grey900,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: const [
                    BoxShadow(
                      offset: Offset(-2, 2),
                      blurRadius: 2,
                    )
                  ],
                ),
                child: Text(
                  "Clear Chat",
                  style: TextStyle(
                    color: grey200,
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
                padding: const EdgeInsets.all(8),
                reverse: true,
                itemCount: widget.messages.length,
                itemBuilder: (context, index) {
                  return widget.messages.reversed.toList()[index];
                },
              ),
            ),
            if (_isTyping)
              Row(
                children: [
                  const SizedBox(width: 60),
                  Text(
                    "Auscy is typing",
                    style: TextStyle(
                      color: grey200,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(width: 5),
                  SpinKitThreeBounce(
                    color: grey200,
                    size: 20.0,
                  ),
                ],
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
