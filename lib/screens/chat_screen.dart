import 'package:chatgpt_playground/providers/chat_provider.dart';
import 'package:chatgpt_playground/widgets/app_bar.dart';
import 'package:chatgpt_playground/widgets/chat_item.dart';
import 'package:chatgpt_playground/widgets/text_and_voice_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      body: Column(
        children: [
          Expanded(
            child: Consumer(builder: (context, ref, child) {
              final chats = ref.watch(chatProvider).reversed.toList();
              return ListView.builder(
                reverse: true,
                itemCount: chats.length,
                itemBuilder: (context, index) => ChatItem(
                    text: chats[index].message, isMe: chats[index].isMe),
              );
            }),
          ),
          const Padding(
            padding: EdgeInsets.all(12.0),
            child: TextAndVoiceField(),
          ),
          const SizedBox(
            height: 10,
          )
        ],
      ),
    );
  }
}
