import 'package:chatgpt_playground/models/chat_model.dart';
import 'package:chatgpt_playground/providers/chat_provider.dart';
import 'package:chatgpt_playground/services/ai_handler.dart';
import 'package:chatgpt_playground/services/voice_handler.dart';
import 'package:chatgpt_playground/widgets/toggle_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum InputMode {
  text,
  voice,
}

class TextAndVoiceField extends ConsumerStatefulWidget {
  const TextAndVoiceField({super.key});

  @override
  ConsumerState<TextAndVoiceField> createState() => _TextAndVoiceFieldState();
}

class _TextAndVoiceFieldState extends ConsumerState<TextAndVoiceField> {
  InputMode _inputMode = InputMode.voice;
  final _messageController = TextEditingController();
  final AIHandler _openAI = AIHandler();
  final VoiceHandler _voiceHandler = VoiceHandler();
  var _isReplying = false;
  var _isListeningSpeech = false;

  @override
  void initState() {
    _voiceHandler.initSpeech();
    super.initState();
  }

  @override
  void dispose() {
    _messageController.dispose();
    _openAI.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _messageController,
            onChanged: (value) {
              value.isNotEmpty
                  ? setInputMode(InputMode.text)
                  : setInputMode(InputMode.voice);
            },
            cursorColor: Theme.of(context).colorScheme.onPrimary,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
        const SizedBox(
          width: 10,
        ),
        ToggleButton(
          isListeningSpeech: _isListeningSpeech,
          isReplying: _isReplying,
          inputMode: _inputMode,
          sendTextMessage: () {
            final message = _messageController.text;
            sendTextMessage(message);
            _messageController.clear();
          },
          sendVoiceMessage: () {
            sendVoiceMessage();
          },
        ),
      ],
    );
  }

  void setInputMode(InputMode inputMode) {
    setState(() {
      _inputMode = inputMode;
    });
  }

  void sendTextMessage(String message) async {
    setReplyingState(true);
    addToChatList(message, true, DateTime.now().toString());
    addToChatList('Typing...', false, 'typingid');
    setInputMode(InputMode.voice);

    final aiResponse = await _openAI.getResponse(message);
    removeTypingMessage();
    addToChatList(aiResponse, false, DateTime.now().toString());

    setReplyingState(false);
  }

  void sendVoiceMessage() async {
    if (_voiceHandler.isSpeechEnabled) {
      print('not supported');
      return;
    }
    if (_voiceHandler.speechToText.isListening) {
      await _voiceHandler.stopListeningSpeech();
      setListeningSpeechState(false);
    } else {
      setListeningSpeechState(true);
      final result = await _voiceHandler.startListeningSpeech();
      setListeningSpeechState(false);
      sendTextMessage(result);
    }
  }

  void setReplyingState(bool isReplying) {
    setState(() {
      _isReplying = isReplying;
    });
  }

  void setListeningSpeechState(bool isListeningSpeech) {
    setState(() {
      _isListeningSpeech = isListeningSpeech;
    });
  }

  void removeTypingMessage() {
    final chats = ref.read(chatProvider.notifier);
    chats.removeTyping();
  }

  void addToChatList(String message, bool isMe, String id) {
    final chats = ref.read(chatProvider.notifier);
    chats.add(ChatModel(
      id: id,
      message: message,
      isMe: isMe,
    ));
  }
}
