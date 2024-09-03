import 'package:speech_to_text/speech_to_text.dart';

class VoiceRecognizitionApi {
  listen(void Function(List<String> recognizedWords) onResult) async {
    SpeechToText speech = SpeechToText();
    bool available = await speech.initialize(onStatus: (_) {
      print("Status: $_");
    }, onError: (_) {
      print("Error: $_");
    });
    if (available) {
      speech.listen(
        listenOptions: SpeechListenOptions(
            autoPunctuation: true, enableHapticFeedback: true),
        localeId: 'de_DE',
        onResult: (result) {
          result.toJson();
          print("Result: ${result.toFinal()}");
          onResult(result.recognizedWords.split(' '));
        },
      );
    } else {
      print("The user has denied the use of speech recognition.");
    }
  }
}
