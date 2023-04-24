import 'package:chatgpt_playground/widgets/app_bar.dart';
import 'package:chatgpt_playground/widgets/text_and_voice_field.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: 20,
              itemBuilder: (context, index) => const Text('List'),
            ),
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
