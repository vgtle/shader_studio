import 'dart:async';

import 'package:audio_session/audio_session.dart';
import 'package:fftea/fftea.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_audio_capture/flutter_audio_capture.dart';
import 'package:record/record.dart';

class VoiceApi {
  final record = AudioRecorder();

  VoiceApi() {
    _flutterAudioCapture.init().then((value) {
      if (value == false) {
        throw Exception("Failed to initialize FlutterAudioCapture");
      }
      _isInitialized.complete(true);
    });
  }

  final FlutterAudioCapture _flutterAudioCapture = FlutterAudioCapture();
  final Completer<bool> _isInitialized = Completer();

  Future<void> startRecording(
      void Function(List<({FrequencySpectrum spectrum, double value})> data)
          onData) async {
    await _isInitialized.future;
    await AudioSession.instance.then(
      (value) async {
        await value.configure(
          const AudioSessionConfiguration(
            avAudioSessionCategory: AVAudioSessionCategory.record,
            avAudioSessionCategoryOptions:
                AVAudioSessionCategoryOptions.mixWithOthers,
          ),
        );
      },
    );
    _flutterAudioCapture.start(
      (data) {
        final buffer = data;
        final fft = FFT(buffer.length);

        final freq = fft.realFft(buffer);
        final freqList = freq.discardConjugates().magnitudes().toList();
        final frequencies = [
          FrequencySpectrum(0, 20),
          FrequencySpectrum(20, 25),
          FrequencySpectrum(25, 31),
          FrequencySpectrum(31, 40),
          FrequencySpectrum(40, 50),
          FrequencySpectrum(50, 63),
          FrequencySpectrum(63, 80),
          FrequencySpectrum(80, 100),
          FrequencySpectrum(100, 125),
          FrequencySpectrum(125, 160),
          FrequencySpectrum(160, 200),
          FrequencySpectrum(200, 250),
          FrequencySpectrum(250, 315),
          FrequencySpectrum(315, 400),
          FrequencySpectrum(400, 500),
          FrequencySpectrum(500, 630),
          FrequencySpectrum(630, 800),
          FrequencySpectrum(800, 1000),
          FrequencySpectrum(1000, 1250),
          FrequencySpectrum(1250, 1600),
          FrequencySpectrum(1600, 2000),
          FrequencySpectrum(2000, 2500),
          FrequencySpectrum(2500, 3150),
          FrequencySpectrum(3150, 4000),
          FrequencySpectrum(4000, 5000),
          FrequencySpectrum(5000, 6300),
          FrequencySpectrum(6300, 8000),
          FrequencySpectrum(8000, 10000),
          FrequencySpectrum(10000, 12500),
          FrequencySpectrum(12500, 16000),
          FrequencySpectrum(16000, 22000),
        ];
        List<({FrequencySpectrum spectrum, double value})> frequencyValues =
            frequencies.map((e) {
          final min = fft.indexOfFrequency(e.min.toDouble(), 44000);
          final max = fft.indexOfFrequency(e.max.toDouble(), 44000);

          return (
            spectrum: e,
            value: freqList
                .sublist(min.floor(), max.ceil())
                .reduce((a, b) => a + b),
          );
        }).toList();
        onData(frequencyValues);
      },
      (e) {
        debugPrint(e);
      },
      sampleRate: 44000,
      bufferSize: 256,
    );
  }

  Future<void> stopRecording() async {
    return _flutterAudioCapture.stop();
  }
}

class FrequencySpectrum {
  FrequencySpectrum(this.min, this.max);

  final int min;
  final int max;
}
