import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:livespeechtotext/livespeechtotext.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:speech_to_text/speech_to_text.dart';

class VoiceRecognizitionApi {
  final Livespeechtotext speech = Livespeechtotext();

  Future<Stream<List<String>>> listen() async {
    final hasPermission = await Permission.speech.request().isGranted;
    if (!hasPermission) {
      throw Exception('Permission denied');
    }
    await speech.setLocale('en-US');
    final StreamController<List<String>> controller = StreamController();
    speech.start();
    speech.addEventListener(Livespeechtotext.eventSuccess, (result) {
      if (result == null) {
        return;
      }
      controller.add(result.split(' '));
    });

    return controller.stream;
  }

  Future<void> listen2(
      void Function(List<String> recognizedWords) onResult) async {
    SpeechToText speech = SpeechToText();
    bool available = await speech.initialize(onStatus: (_) {
      debugPrint("Status: $_");
    }, onError: (_) {
      debugPrint("Error: $_");
    });
    if (available) {
      speech.listen(
        listenOptions: SpeechListenOptions(
          autoPunctuation: true,
          enableHapticFeedback: true,
          listenMode: ListenMode.search,
          onDevice: false,
        ),
        localeId: 'de_DE',
        onResult: (result) {
          result.toJson();
          onResult(result.recognizedWords.split(' '));
        },
      );
    } else {
      debugPrint("The user has denied the use of speech recognition.");
    }
  }

  Future<void> stop() async {
    await speech.stop();
  }
}
