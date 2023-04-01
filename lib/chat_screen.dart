import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:http/http.dart' as http;

import 'chatmessage.dart';
import 'data.dart';

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

  @override
  void initState() {
    super.initState();
    /* box = Hive.box("messages");
    if (box.get("messages") == null) box.put("messages", []);
    messages = box.get("messages"); */
  }

  @override
  void dispose() {
    Hive.close();
    super.dispose();
  }

  // Link for api - https://beta.openai.com/account/api-keys
  Future<String> generateResponse(String prompt) async {
    final apiKey = dotenv.env['OPENAI_API_KEY']!;
    final response =
        await http.post(Uri.parse("https://api.openai.com/v1/completions"),
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $apiKey',
            },
            body: jsonEncode({
              'model': 'text-davinci-003',
              'prompt': prompt.trim(),
              'temperature': 0.3,
              'max_tokens': 3000,
              'top_p': 1,
              'frequency_penalty': 0.0,
              'presence_penalty': 0.0,
            }));

    Map<String, dynamic> newResponse = jsonDecode(response.body);
    debugPrint(newResponse.toString());
    return newResponse['choices'][0]['text'];
  }

  String? endsWithPunctuation(String inputString) {
    if (inputString.endsWith('.') ||
        inputString.endsWith('?') ||
        inputString.endsWith('!')) {
      return null;
    } else {
      return shouldAddQuestionMark(inputString) ? '?' : '.';
    }
  }

  String getLast20Texts() {
    int start =
        (widget.messages.length < 20) ? 0 : (widget.messages.length - 19);

    List last20Texts =
        widget.messages.sublist(start).map((message) => message.text).toList();

    last20Texts.insert(0, initPrompt);

    return last20Texts.join('\n');
  }

  bool shouldAddQuestionMark(String string) {
    List<String> statements = [];
    List<String> lines = string.split("\n");

    for (String line in lines) {
      List<String> lineStatements = line.split(RegExp('[.,?!]'));

      for (String statement in lineStatements) {
        statement = statement.trim();
        if (statement.isNotEmpty) {
          statements.add(statement);
        }
      }
    }

    List<String> words = statements.last.split(" ");
    if (questionWordsRegex.hasMatch(words.first.toLowerCase().trim())) {
      return statements.last.endsWith("?") ? false : true;
    }

    return false;
  }

  void _sendMessage() async {
    String text = controller.text.trim();

    if (text.isEmpty) return;

    String? punctuation = endsWithPunctuation(text);
    if (punctuation != null) {
      text += punctuation;
    }

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

    String prompt = getLast20Texts();

    try {
      final response = await generateResponse(prompt);
      Vx.log(response);

      if (response.trim() == "") {
        setState(() {
          _isTyping = false;
        });
      } else {
        insertNewData(response.trim(), false);
      }

      if (widget.messages.length > 5) {
        final title = await generateResponse(
            "$prompt\n In 3 words or less, summarize this in form of a title.");
        Vx.log(title);

        setState(() {
          widget.title = title.trim();
          chatList[widget.id].title = title.trim();
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
      alignment: Alignment.bottomCenter,
      backgroundColor: Vx.red500,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Container(
        padding: const EdgeInsets.all(20),
        child: Text(
          e.trim(),
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
          decoration: const BoxDecoration(
            color: Vx.zinc900,
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
        leading: const BackButton(),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                widget.title == null ? "New Chat" : widget.title!,
                maxLines: 2,
                style: const TextStyle(
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
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Vx.zinc900,
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
                itemCount: widget.messages.length,
                itemBuilder: (context, index) {
                  return widget.messages.reversed.toList()[index];
                },
              ),
            ),
            if (_isTyping)
              Row(
                children: const [
                  SizedBox(width: 60),
                  Text(
                    "Auscy is typing",
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(width: 5),
                  SpinKitThreeBounce(
                    color: Colors.black,
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
