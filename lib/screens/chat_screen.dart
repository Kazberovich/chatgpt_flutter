import 'package:chatgpt_playground/widgets/app_bar.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: CustomAppBar(),
      body: Center(
        child: Text(
          "Chat screen",
        ),
      ),
    );
  }
}
