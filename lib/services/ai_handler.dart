import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';

final String token = "TOKEN HERE";

class AIHandler {
  final _openAI = OpenAI.instance.build(
      token: token,
      baseOption: HttpSetup(receiveTimeout: 50000),
      isLogger: true);

  void dispose() {
    _openAI.close();
  }

  Future<String> getResponse(String message) async {
    try {
      final request = CompleteText(
          prompt: message, model: kTranslateModelV3, maxTokens: 200);
      final response = await _openAI.onCompleteText(request: request);

      if (response != null) {
        return response.choices[0].text.trim();
      }
      return 'Something went wrong';
    } catch (e) {
      return e.toString();
    }
  }
}
