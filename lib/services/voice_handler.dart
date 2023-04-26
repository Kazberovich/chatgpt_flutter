import 'dart:async';
import 'package:speech_to_text/speech_to_text.dart';

class VoiceHandler {
  final SpeechToText _speechToText = SpeechToText();
  bool _speechEnabled = false;

  void initSpeech() async {
    _speechEnabled = await _speechToText.initialize();
    print(_speechEnabled ? 'speech is enabled' : 'speech is not enabled');
  }

  Future<String> startListeningSpeech() async {
    final completer = Completer<String>();
    _speechToText.listen(onResult: (result) {
      if (result.finalResult) {
        completer.complete(result.recognizedWords);
      }
    });
    return completer.future;
  }

  Future<void> stopListeningSpeech() async {
    await _speechToText.stop();
  }

  SpeechToText get speechToText => _speechToText;
  bool get isSpeechEnabled => _speechEnabled;
}
