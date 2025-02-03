import 'dart:async';
import 'dart:developer';

// import 'package:audioplayers/audioplayers.dart';
import 'package:auscy/res/res.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';
import 'package:record/record.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({
    required this.chatRoom,
    super.key,
  });

  final ChatRoom chatRoom;

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late Map<String, dynamic> chatInDB;

  final TextEditingController _controller = TextEditingController();

  bool _isTyping = false;
  bool _isProcessingResponse = false;
  bool _isImageUploading = false;
  bool _isNamingChat = false;

  bool _isRecording = false;
  bool _isTranscribing = false;
  final _recorder = AudioRecorder();

  Timer? _recordingTimer;
  int _recordDuration = 0;
  // final AudioPlayer _audioPlayer = AudioPlayer();

  final types.User auscy = const types.User(
    id: 'auscy',
    firstName: 'Auscy',
    role: types.Role.admin,
  );

  Future<void> _initializeRecorder() async {
    final micStatus = await Permission.microphone.request();
    // final storageStatus = await Permission.storage.request();

    if (micStatus != PermissionStatus.granted) {
      log('Microphone permission not granted');
      showTopSnackBar(
        Overlay.of(context),
        CustomSnackBar.error(
          message: 'Please grant microphone permissions',
        ),
      );
      return;
    }

    // if (storageStatus != PermissionStatus.granted) {
    //   log('Storage permission not granted');
    //   showTopSnackBar(
    //     Overlay.of(context),
    //     CustomSnackBar.error(
    //       message: 'Please grant storage permissions',
    //     ),
    //   );
    // }
  }

  @override
  void initState() {
    _loadChat();
    _initializeRecorder();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    _recorder.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode =
        MediaQuery.of(context).platformBrightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.chatRoom.title),
        actions: [
          ZoomTapAnimation(
            child: IconButton(
              splashColor: Colors.transparent,
              splashRadius: 1,
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (context) {
                      return Dialog(
                        backgroundColor: isDarkMode
                            ? darkBackgroundColor
                            : lightBackgroundColor,
                        child: Padding(
                          padding: EdgeInsets.all(20.w),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              AppBoldText(
                                'Rename Chat',
                                fontSize: 20.sp,
                              ),
                              SizedBox(height: 20.h),
                              TextField(
                                controller: TextEditingController(
                                    text: widget.chatRoom.title),
                                autofocus: true,
                                style: TextStyle(
                                  color: isDarkMode ? lightColor : darkColor,
                                ),
                                decoration: const InputDecoration(
                                  hintText: 'Enter new chat title',
                                  hintStyle: TextStyle(
                                    color: Colors.grey,
                                  ),
                                ),
                                textCapitalization: TextCapitalization.words,
                                onSubmitted: (value) {
                                  context.read<ChatRoomProvider>().renameChat(
                                        context,
                                        chatRoom: widget.chatRoom,
                                        title: value,
                                      );
                                  Navigator.pop(context);
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    });
              },
              icon: const Icon(
                IconlyLight.edit,
              ),
            ),
          )
        ],
      ),
      body: Padding(
        padding: EdgeInsets.only(
          left: 8.sp,
          right: 8.sp,
          bottom: 8.sp,
        ),
        child: Chat(
          messages: widget.chatRoom.messages,
          scrollPhysics: const BouncingScrollPhysics(),
          onSendPressed: (message) {
            _handleSendPressed(message);
            debugPrint(widget.chatRoom.messages
                .map((e) => e.toJson()['text'])
                .toList()
                .toString());
          },
          theme: isDarkMode ? const DarkChatTheme() : const DefaultChatTheme(),
          user: widget.chatRoom.chat!.user,
          dateHeaderBuilder: (p0) {
            String headerText;
            getDateDifference() {
              final dayDiff = DateTime.now().difference(p0.dateTime).inDays;
              if (dayDiff == 0) {
                return 'Today';
              } else if (dayDiff == 1) {
                return 'Yesterday';
              } else {
                const monthNames = {
                  1: 'January',
                  2: 'February',
                  3: 'March',
                  4: 'April',
                  5: 'May',
                  6: 'June',
                  7: 'July',
                  8: 'August',
                  9: 'September',
                  10: 'October',
                  11: 'November',
                  12: 'December'
                };

                final monthName = monthNames[p0.dateTime.month] ?? '';
                final day = p0.dateTime.day;
                final year = p0.dateTime.year == DateTime.now().year
                    ? ''
                    : ', ${p0.dateTime.year}';

                return '$monthName $day$year';
              }
            }

            headerText = getDateDifference();

            return Container(
              padding: EdgeInsets.only(
                top: 8.sp,
                bottom: 8.sp,
              ),
              child: Center(
                child: Text(
                  headerText,
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 12.sp,
                  ),
                ),
              ),
            );
          },
          onAttachmentPressed: _handleAttachmentPressed,
          onMessageTap: _handleMessageTap,
          onMessageLongPress: (context, message) {
            debugPrint('Message long pressed: ${message.toJson()['text']}');
          },
          onPreviewDataFetched: _handlePreviewDataFetched,
          emojiEnlargementBehavior: EmojiEnlargementBehavior.multi,
          typingIndicatorOptions: TypingIndicatorOptions(
            typingMode: TypingIndicatorMode.avatar,
            typingUsers: [
              if (_isTyping) auscy,
            ],
            customTypingIndicatorBuilder: (
                {required bubbleAlignment,
                required context,
                required indicatorOnScrollStatus,
                required options}) {
              return Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.only(
                    left: 16.w,
                    bottom: 8.h,
                  ),
                  child: Row(
                    children: [
                      const Text(
                        'Auscy is typing',
                        style: TextStyle(
                          color: Colors.grey,
                          // fontSize: 12,
                        ),
                      ),
                      SizedBox(width: 10.w),
                      SpinKitThreeBounce(
                        color: primaryColor,
                        size: 20.sp,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          isAttachmentUploading: _isImageUploading,
          customBottomWidget: SizedBox(
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _controller,
                        onSubmitted: (value) {
                          _handleSendPressed(
                            types.PartialText(
                              text: value.trim(),
                            ),
                          );
                          _controller.clear();
                        },
                        onChanged: (value) {
                          setState(() {});
                        },
                        enabled: !_isRecording && !_isTranscribing,
                        minLines: 1,
                        maxLines: 4,
                        keyboardType: TextInputType.multiline,
                        textInputAction: TextInputAction.newline,
                        textCapitalization: TextCapitalization.sentences,
                        style: TextStyle(
                          color: isDarkMode ? lightColor : darkColor,
                        ),
                        decoration: InputDecoration(
                          hintText: 'Type a message',
                          hintStyle: const TextStyle(
                            color: Colors.grey,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(24.sp),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(24.sp),
                            borderSide: BorderSide(
                              color: isDarkMode ? lightColor : darkColor,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(24.sp),
                            borderSide: BorderSide(
                              color: primaryColor,
                              width: 2.sp,
                            ),
                          ),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 16.w,
                            vertical: 12.h,
                          ),
                          prefixIcon: ZoomTapAnimation(
                            onTap: _handleImageSelection,
                            child: Icon(
                              IconlyLight.image,
                              color: isDarkMode ? lightColor : darkColor,
                              size: 25.sp,
                            ),
                          ),
                          suffixIcon: !_isRecording
                              ? ZoomTapAnimation(
                                  onTap: () {
                                    _startRecording();
                                  },
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                      vertical: 10.h,
                                    ),
                                    child: SvgPicture.asset(
                                      'assets/svg/mic.svg',
                                      color:
                                          isDarkMode ? lightColor : darkColor,
                                    ),
                                  ),
                                )
                              : null,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 8.w),
                      child: Opacity(
                        opacity: _controller.text.trim().isEmpty || _isTyping
                            ? 0.3
                            : 1,
                        child: ZoomTapAnimation(
                          child: Container(
                            padding: EdgeInsets.only(
                              left: 10.sp,
                              right: 12.sp,
                              top: 12.sp,
                              bottom: 12.sp,
                            ),
                            decoration: const BoxDecoration(
                              color: primaryColor,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              IconlyBold.send,
                              color: Colors.white,
                              size: 20.sp,
                            ),
                          ),
                          onTap: () {
                            if (_controller.text.trim().isEmpty || _isTyping) {
                              return;
                            }

                            _handleSendPressed(
                              types.PartialText(
                                text: _controller.text.trim(),
                              ),
                            );
                            _controller.clear();

                            _getResponse();
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                if (_isRecording || _isTranscribing)
                  GestureDetector(
                    onTap: _stopRecording,
                    child: Container(
                      height: 150.h,
                      width: double.infinity,
                      margin: EdgeInsets.only(top: 10.h),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.secondary,
                        borderRadius: BorderRadius.circular(24.sp),
                      ),
                      child: _isRecording
                          ? Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    IconButton(
                                      onPressed: () {
                                        _recordingTimer?.cancel();
                                        _recorder.stop().catchError((e) {
                                          log('Error stopping recording: $e');
                                          showTopSnackBar(
                                            Overlay.of(context),
                                            CustomSnackBar.error(
                                              message:
                                                  'Failed to stop recording. Try again.',
                                            ),
                                          );
                                          return null;
                                        });
                                        setState(() {
                                          _isRecording = false;
                                        });
                                      },
                                      icon: const Icon(
                                        Icons.close,
                                        color: Colors.red,
                                      ),
                                    ),
                                  ],
                                ),
                                Spacer(flex: 2),
                                Text(
                                  "${(_recordDuration ~/ 60).toString().padLeft(2, '0')}:${(_recordDuration % 60).toString().padLeft(2, '0')}",
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontSize: 16.sp,
                                  ),
                                ),
                                Spacer(),
                                Center(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.stop_circle_outlined,
                                        color: Colors.red,
                                      ),
                                      5.sW,
                                      AppText('Tap to stop recording'),
                                    ],
                                  ),
                                ),
                                Spacer(flex: 3),
                              ],
                            )
                          : _isTranscribing
                              ? Center(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SpinKitThreeBounce(
                                        color: primaryColor,
                                        size: 20.sp,
                                      ),
                                      10.sW,
                                      AppText(
                                        'Converting to text...',
                                      ),
                                    ],
                                  ),
                                )
                              : Container(),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String get preResponse {
    return '''
  You are an AI chatbot called Auscy, created by Somtochukwu Ukaegbe (Sohmtee), a multi-talented Flutter developer, software engineer, UI/UX designer, tech enthusiast, and creative thinker. He has built a variety of applications, including chatbots, inventory management systems, word games, and more. Sohmtee is passionate about learning new technologies, sharing knowledge, and helping others grow in their careers. He is always eager to explore new ideas, experiment with innovative solutions, and collaborate with like-minded individuals to create impactful projects. His github link is https://github.com/sohmteee (display it exactly like this in plain text).

  Auscy is designed to be a highly versatile and engaging AI assistant, capable of helping users with a wide range of topics, including:

  - **Technology & Software Development:** Assisting with software architecture, debugging, cloud services, app deployment, UI/UX design, backend and frontend development, and API integration.
  - **AI & Machine Learning:** Explaining AI concepts, offering guidance on chatbot development, voice processing, and text generation models like Gemini and Deepgram.
  - **General Knowledge:** Answering questions about science, history, geography, mathematics, finance, health, psychology, and current events.
  - **Personal Productivity:** Offering study techniques, time management strategies, productivity hacks, note-taking methods, and motivation to help users stay on track.
  - **Education & Learning:** Assisting with academic subjects, providing explanations for complex topics, and helping users study more efficiently.
  - **Entertainment & Creativity:** Engaging in fun conversations, recommending books, movies, anime, or music, generating creative story ideas, and assisting with poetry or scriptwriting.
  - **Life & Self-Improvement:** Giving advice on personal growth, career decisions, maintaining a balanced lifestyle, relationship guidance, and mental wellness.
  - **Voice & Speech Processing:** Transcribing voice messages, analyzing spoken words, generating human-like responses, and offering voice assistant capabilities.
  - **Casual Conversations & Social Topics:** Chatting about hobbies, trending topics, gaming, pop culture, sports, and engaging in light-hearted discussions.
  - **Finance & Crypto:** Providing insights on personal finance, budgeting, saving, cryptocurrency, blockchain, and making informed financial decisions.
  - **Business & Entrepreneurship:** Assisting with business ideas, branding strategies, marketing insights, customer engagement, and startup planning.
  - **Travel & Culture:** Giving travel recommendations, explaining cultural differences, helping with trip planning, and providing language learning support.
  - **Fitness & Nutrition:** Suggesting workout routines, healthy diet plans, meal prep ideas, and general wellness tips.
  - **DIY & Electronics:** Helping with basic electronics, IoT projects (like ESP32 integrations), hardware troubleshooting, and home automation.
  - **Social Media & Content Creation:** Assisting with post ideas, engagement strategies, video editing tips, and growing a brand online.
  - **Legal & Ethical Guidance:** Offering general insights on laws, contracts, digital privacy, ethical dilemmas, and cybersecurity awareness.

  Auscy should always maintain a friendly, engaging, and helpful tone. Whether a user needs technical guidance, life advice, or just a casual chat, Auscy should be there to assist in the best possible way.

  ${user!.displayName != null ? 'The user\'s name is ${user!.displayName!.split(' ').first}' : ''}
  ''';
  }

  Future<List<Content>> segmentChat({int length = 20}) async {
    final messages =
        widget.chatRoom.messages.take(length).toList().reversed.toList();

    final List<Content> contents = [];

    for (var message in messages) {
      // String role = message.author.id == auscy.id ? 'yam doctor' : 'user';

      if (message is types.TextMessage) {
        contents.add(
          Content.text(message.text),
        );
      } else if (message is types.ImageMessage) {
        contents.add(
            Content.data('image/png', await File(message.uri).readAsBytes()));
      } else if (message is types.AudioMessage) {
        contents.add(
            Content.data('audio/opus', await File(message.uri).readAsBytes()));
      }
    }

    debugPrint(contents.toString());
    return contents;
  }

  void _getResponse() async {
    if (_isProcessingResponse) return; // 🔹 Prevents duplicate responses
    _isProcessingResponse = true;

    final messages = await segmentChat();

    setState(() {
      _isTyping = true;
    });

    final response = await gemini
        .generateContent([
          Content.text(preResponse),
          ...messages,
        ])
        .then((value) =>
            value.candidates.first.text?.trim() ??
            'I can\'t help you with that.')
        .catchError((error) {
          if (error is GenerativeAIException) {
            return 'Auscy is overloaded. Please try again later.';
          } else {
            return error.toString();
          }
        });

    setState(() {
      _isTyping = false;
      _isProcessingResponse = false; // 🔹 Reset flag after response
    });

    debugPrint(response);

    final message = types.TextMessage(
      id: const Uuid().v4(),
      author: auscy,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      text: response.trim(),
    );

    await _addMessage(message);
  }

  Future<void> _nameChat() async {
    if (_isNamingChat) return; // Prevents duplicate execution
    _isNamingChat = true;

    final messages = await segmentChat(length: 5);

    final response = await gemini
        .generateContent(
          [
            Content.text('''
Analyze the conversation so far and generate a concise, engaging title that best represents the overall topic or theme of the chat. The title should be no more than 5 words, avoid generic terms like 'chat' or 'conversation,' and should have proper punctuation. Capitalize the first letter of each word. If the discussion is casual or lacks a clear theme, generate a creative yet relevant title based on the messages exchanged:\n
        '''),
            ...messages,
          ],
          generationConfig: GenerationConfig(
            maxOutputTokens: 10,
          ),
        )
        .then((value) => value.candidates.first.text)
        .catchError((error) {
          showTopSnackBar(
            Overlay.of(context),
            CustomSnackBar.error(
              message: error.toString(),
            ),
          );
          return 'New Chat';
        });

    debugPrint('Chat Name: $response');
    setState(() {
      context.read<ChatRoomProvider>().renameChat(
            context,
            chatRoom: widget.chatRoom,
            title: response!.trim(),
          );
    });

    _isNamingChat = false;
  }

  Future<void> _addMessage(types.Message message) async {
    try {
      log('Adding message: ${message.toJson()}');
      setState(() {
        // Ensure the message ID is unique
        if (!widget.chatRoom.messages.any((m) => m.id == message.id)) {
          widget.chatRoom.messages.insert(0, message);
        }
      });
      await usersDB.doc(user!.uid).set(
        {
          'chats':
              (await usersDB.doc(user!.uid).get()).data()!['chats'].map((chat) {
            if (chat['id'] == widget.chatRoom.id) {
              // Ensure the message ID is unique
              if (!chat['messages'].any((m) => m['id'] == message.id)) {
                chat['messages'].insert(0, message.toJson());
              }
            }
            return chat;
          }).toList(),
        },
        SetOptions(merge: true),
      );
    } catch (e) {
      log(e.toString());
    }

    if (widget.chatRoom.title == 'New Chat') {
      log('Name chat..........................................');
      _nameChat();
    }
  }

  void _startRecording() async {
    FocusScope.of(context).unfocus();
    try {
      await _initializeRecorder();

      bool hasPermission = await _recorder.hasPermission();
      if (!hasPermission) {
        log('Microphone permission not granted');
        showTopSnackBar(
          Overlay.of(context),
          CustomSnackBar.error(
            message: 'Microphone permission is required to record audio.',
          ),
        );
        return;
      }

      final directory = await getApplicationDocumentsDirectory();
      final filePath =
          '${directory.path}/${DateTime.now().millisecondsSinceEpoch}.opus';

      await _recorder.start(
        RecordConfig(
          encoder: AudioEncoder.opus,
        ),
        path: filePath,
      );

      setState(() {
        _isRecording = true;
        _recordDuration = 0;
      });

      _recordingTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
        setState(() {
          _recordDuration++;
        });
      });
    } catch (e) {
      log('Error starting recording: $e');
      showTopSnackBar(
        Overlay.of(context),
        CustomSnackBar.error(
          message: 'Failed to start recording. Try again.',
        ),
      );
    }
  }

  void _stopRecording() async {
    if (!_isRecording) return;

    try {
      final path = await _recorder.stop();
      _recordingTimer?.cancel();

      setState(() {
        _isRecording = false;
      });

      if (path == null) return;

      setState(() {
        _isTranscribing = true;
      });

      await deepgram.listen.file(File(path)).then((result) {
        if (result.transcript != null && result.transcript!.trim().isNotEmpty) {
          log(result.transcript!);
          setState(() {
            _controller.text += "${result.transcript!} ";
          });
        }
      }).catchError((error) {
        showTopSnackBar(
          Overlay.of(context),
          CustomSnackBar.error(
            message: error.toString(),
          ),
        );
      }).whenComplete(() {
        setState(() {
          _isTranscribing = false;
        });
      });
    } catch (e) {
      log('Error stopping recording: $e');
    } finally {
      await _recorder.dispose(); // 🔹 Ensure microphone is completely released
      log('Microphone released successfully');
    }
  }

  void _handleAttachmentPressed() {
    _handleImageSelection();
  }

  void _handleImageSelection() async {
    try {
      final result = await ImagePicker().pickMultiImage(
        imageQuality: 70,
        maxWidth: 1440,
      );

      if (result.isNotEmpty) {
        final List<types.ImageMessage> imageMessages = [];
        for (var imageFile in result) {
          final bytes = await imageFile.readAsBytes();
          final image = await decodeImageFromList(bytes);

          final message = types.ImageMessage(
            id: const Uuid().v4(),
            author: widget.chatRoom.chat!.user,
            createdAt: DateTime.now().millisecondsSinceEpoch,
            height: image.height.toDouble(),
            name: imageFile.name,
            size: bytes.length,
            uri: imageFile.path,
            width: image.width.toDouble(),
          );

          imageMessages.add(message);
        }

        _showImagePromptDialog(imageMessages);
      }
    } catch (e) {
      log('Error picking image: $e');
    }
  }

  void _showImagePromptDialog(List<types.ImageMessage> imageMessages) {
    showDialog(
      context: context,
      builder: (context) {
        final TextEditingController promptController = TextEditingController();
        return Dialog(
          child: Padding(
            padding: EdgeInsets.all(20.w),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AppBoldText(
                  'Add a prompt for the images',
                  fontSize: 20.sp,
                ),
                SizedBox(height: 20.h),
                TextField(
                  controller: promptController,
                  autofocus: true,
                  decoration: const InputDecoration(
                    hintText: 'Enter your prompt',
                  ),
                  textCapitalization: TextCapitalization.sentences,
                ),
                SizedBox(height: 20.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        _sendImagesWithPrompt(
                            imageMessages, promptController.text.trim());
                      },
                      child: const Text('Skip'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        _sendImagesWithPrompt(
                            imageMessages, promptController.text.trim());
                      },
                      child: const Text('Send'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _sendImagesWithPrompt(
      List<types.ImageMessage> imageMessages, String prompt) async {
    setState(() {
      _isImageUploading = true;
    });
    for (var message in imageMessages) {
      // Ensure each image message has a unique ID
      final uniqueMessage = message.copyWith(
        id: const Uuid().v4(),
      );
      await _addMessage(uniqueMessage);
    }
    setState(() {
      _isImageUploading = false;
    });
    if (prompt.isNotEmpty) {
      final textMessage = types.TextMessage(
        author: widget.chatRoom.chat!.user,
        createdAt: DateTime.now().millisecondsSinceEpoch,
        id: const Uuid().v4(),
        text: prompt,
      );
      await _addMessage(textMessage);
    }

    _getResponse();
  }

  void _handleMessageTap(BuildContext _, types.Message message) async {
    if (message is types.FileMessage) {
      var localPath = message.uri;

      if (message.uri.startsWith('http')) {
        try {
          final index = widget.chatRoom.messages
              .indexWhere((element) => element.id == message.id);
          final updatedMessage =
              (widget.chatRoom.messages[index] as types.FileMessage).copyWith(
            isLoading: true,
          );

          setState(() {
            widget.chatRoom.messages[index] = updatedMessage;
          });

          final client = http.Client();
          final request = await client.get(Uri.parse(message.uri));
          final bytes = request.bodyBytes;
          final documentsDir = (await getApplicationDocumentsDirectory()).path;
          localPath = '$documentsDir/${message.name}';

          if (!File(localPath).existsSync()) {
            final file = File(localPath);
            await file.writeAsBytes(bytes);
          }
        } finally {
          final index = widget.chatRoom.messages
              .indexWhere((element) => element.id == message.id);
          final updatedMessage =
              (widget.chatRoom.messages[index] as types.FileMessage).copyWith(
            isLoading: null,
          );

          setState(() {
            widget.chatRoom.messages[index] = updatedMessage;
          });
        }
      }

      // await OpenFilex.open(localPath);
    }
  }

  void _handlePreviewDataFetched(
    types.TextMessage message,
    types.PreviewData previewData,
  ) {
    final index = widget.chatRoom.messages
        .indexWhere((element) => element.id == message.id);
    final updatedMessage =
        (widget.chatRoom.messages[index] as types.TextMessage).copyWith(
      previewData: previewData,
    );

    setState(() {
      widget.chatRoom.messages[index] = updatedMessage;
    });
  }

  void _handleSendPressed(types.PartialText message) async {
    final textMessage = types.TextMessage(
      author: widget.chatRoom.chat!.user,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      id: const Uuid().v4(),
      text: message.text,
    );

    await _addMessage(textMessage);
  }

  void _loadChat() async {
    chatInDB = await usersDB.doc(user!.uid).get().then((data) {
      return (data.data()!['chats'] as List).singleWhere((chat) {
        return chat['id'] == widget.chatRoom.id;
      });
    });

    setState(() {
      widget.chatRoom.title = chatInDB['title'];
      widget.chatRoom.messages = (chatInDB['messages'] as List)
          .map((e) => types.Message.fromJson(e))
          .toList();
    });
  }
}
