import 'chatmessage.dart';
import 'data.dart';

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
