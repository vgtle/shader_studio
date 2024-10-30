import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:shader_studio/pages/intelligence/gemini_api.dart';
import 'package:shader_studio/pages/intelligence/voice_api.dart';
import 'package:shader_studio/pages/intelligence/voice_recognizition_api.dart';
import 'package:shader_studio/pages/intelligence/widgets/background.dart';
import 'package:shader_studio/pages/intelligence/widgets/debouncer.dart';
import 'package:shader_studio/pages/intelligence/widgets/dynamic_island.dart';
import 'package:shader_studio/pages/intelligence/widgets/eq_component.dart';
import 'package:shader_studio/pages/intelligence/widgets/frequency_animation_shader.dart';
import 'package:shader_studio/pages/intelligence/widgets/shockwave_shader.dart';

class IntelligencePage extends StatefulWidget {
  const IntelligencePage({super.key});

  @override
  State<IntelligencePage> createState() => _IntelligencePageState();
}

class _IntelligencePageState extends State<IntelligencePage>
    with SingleTickerProviderStateMixin {
  double _elapsed = 0;

  late final Ticker _ticker;
  List<({FrequencySpectrum spectrum, double value})> data = [];
  List<({FrequencySpectrum spectrum, double value})> data2Animation = [];
  List<String> recognizedWords = [];
  double shockwaveAnimationStart = -10;
  bool loading = false;
  bool listening = false;
  String answer = "";
  final VoiceRecognizitionApi voiceRecognizitionApi = VoiceRecognizitionApi();

  VoiceApi voiceApi = VoiceApi();
  GeminiApi geminiApi = GeminiApi();

  @override
  void initState() {
    super.initState();

    _ticker = createTicker((elapsed) {
      _elapsed = (elapsed.inMilliseconds / 1000);

      if (data2Animation.isEmpty) {
        data2Animation = data;
      } else {
        for (int i = 0; i < data.length; i++) {
          data2Animation[i] = (
            spectrum: data2Animation[i].spectrum,
            value: lerpDouble(data2Animation[i].value, data[i].value, 0.1)!,
          );
        }
        setState(() {});
      }
      if (mounted) {}
    })
      ..start();
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }

  Future<String> getSpokenSentence() async {
    String newRecognizedWords = "";
    Completer<String> completer = Completer();
    Debouncer? debouncer;

    final stream = (await voiceRecognizitionApi.listen());

    final subscription = stream.listen((recognizedWords) {
      if (!listening) {
        completer.complete("");
        return;
      }
      setState(() {
        this.recognizedWords = recognizedWords;
        debouncer ??= Debouncer(
            delay: const Duration(seconds: 2),
            action: () {
              completer.complete(newRecognizedWords);
            });
        debouncer?.reset();
        newRecognizedWords = recognizedWords.join(' ');
      });
    });

    return completer.future.then((value) async {
      await subscription.cancel();
      await voiceRecognizitionApi.stop();
      return value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        setState(() {
          listening = false;
        });
        await voiceApi.stopRecording();
        await voiceRecognizitionApi.stop();
      },
      onLongPress: () async {
        setState(() {
          shockwaveAnimationStart = _elapsed;
          recognizedWords = [];
          answer = "";
          loading = false;
          listening = true;
        });

        await Feedback.forLongPress(context);

        await voiceApi.startRecording((data) {
          setState(() {
            this.data = data;
          });
        });
        await getSpokenSentence().then((spokenSentence) async {
          if (!listening || spokenSentence.isEmpty) {
            return;
          }
          setState(() {
            loading = true;
          });
          final newAntwort = await geminiApi.ask(spokenSentence);
          setState(() {
            answer = newAntwort;
          });
          setState(() {
            loading = false;
          });
        });
      },
      child: Scaffold(
        body: Stack(
          key: const Key("Stack"),
          children: [
            ShockwaveShader(
              elapsed: _elapsed,
              shockwaveAnimationStart: shockwaveAnimationStart,
              child: FrequencyAnimationShader(
                listening: listening,
                elapsed: _elapsed,
                data2Animation: data2Animation,
                child: Background(
                  child: Stack(
                    children: [
                      Positioned(
                        bottom: 120,
                        left: 30,
                        right: 30,
                        child: EqComponent(
                          data: data,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            DynamicIsland(
              listening: listening,
              loading: loading,
              recognizedWords: recognizedWords,
              answer: answer,
            ),
          ],
        ),
      ),
    );
  }
}
