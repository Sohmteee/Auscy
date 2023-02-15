import 'package:chat_gpt_02/reply_preview.dart';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

import 'data.dart';
import 'functions.dart';

class TextComposer extends StatefulWidget {
  const TextComposer({super.key});

  @override
  State<TextComposer> createState() => _TextComposerState();
}

class _TextComposerState extends State<TextComposer> {
  void setResponse(bool val) {
    setState(() {
      isResponse = val;
    });
  }

  Widget buildReplyPreview() {
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
              buildReplyPreview(),
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
                  maxLines: 5,
                  onSubmitted: (value) => sendMessage(),
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
              sendMessage();
            },
          ),
        ),
      ],
    ).px16();
  }
}
