import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';
import 'package:flutter/animation.dart';
import 'package:velocity_x/velocity_x.dart';

import 'chatmessage.dart';
import 'data.dart';

/* void scrollToBottom() {
  scrollController.animateTo(
    scrollController.position.maxScrollExtent + 1000,
    duration: const Duration(milliseconds: 500),
    curve: Curves.easeOut,
  );
} */

void insertNewData(String response) {
  ChatMessage botMessage = ChatMessage(
    text: response,
    sender: MessageSender.bot,
  );

  isTyping = false;
  messages.insert(0, botMessage);
}

void sendMessage() async {
  if (controller.text.isEmpty) return;
  ChatMessage message = ChatMessage(
    text: controller.text.trim(),
    sender: MessageSender.user,
  );

  messages.insert(0, message);
  isTyping = true;

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
