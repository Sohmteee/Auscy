import 'package:chat_gpt_02/chatmessage.dart';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

class ReplyPreview extends StatefulWidget {
  const ReplyPreview({
    super.key,
    required this.sender,
    required this.text,
    required this.setResponse,
    required this.setReplyMessage,
  });

  final String text;
  final ChatMessageType sender;
  final void Function(bool val) setResponse;
  final void Function(ChatMessage message) setReplyMessage;

  @override
  State<ReplyPreview> createState() => _ReplyPreviewState();
}

class _ReplyPreviewState extends State<ReplyPreview> {
  @override
  Widget build(BuildContext context) {
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
                            widget.sender == "user" ? "Me" : "ChatGPT",
                            style: const TextStyle(
                              color: Vx.green500,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                widget.setResponse(false);
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
                        widget.text.trim(),
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
}
