import 'package:chat_gpt_02/reply_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:velocity_x/velocity_x.dart';

import 'data.dart';

class TextComposer extends StatefulWidget {
  const TextComposer({super.key});

  @override
  State<TextComposer> createState() => _TextComposerState();
}

class _TextComposerState extends State<TextComposer> {

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

    /* String prmpt = "";

    List<String> promptList =
       messages.take(20).map((msg) => msg.text.trim()).toList();

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
  
  void setResponse(bool val) {
    setState(() {
      isResponse = val;
    });
  }

  Widget buildReplyHoverBubble() {
    return isResponse
        ? ReplyPreview(
            sender: replyMessage!.sender,
            text: replyMessage!.text,
            setResponse: setResponse,
          )
        : const SizedBox();
  }

  @override
  Widget build(BuildContext context) {
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
                  controller: controller,
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
}
