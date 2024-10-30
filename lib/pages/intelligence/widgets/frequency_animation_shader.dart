import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_shaders/flutter_shaders.dart';
import 'package:shader_studio/main.dart';
import 'package:shader_studio/pages/intelligence/voice_api.dart';

class FrequencyAnimationShader extends StatelessWidget {
  const FrequencyAnimationShader({
    super.key,
    required this.listening,
    required this.elapsed,
    required this.data2Animation,
    required this.child,
  });

  final bool listening;
  final double elapsed;
  final List<({FrequencySpectrum spectrum, double value})> data2Animation;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return AnimatedSampler(
      key: const Key("AnimatedSampler2"),
      enabled: listening,
      (image, size, canvas) {
        final paint = Paint();
        final shader = ShaderProvider.of(context).perlinShader.fragmentShader();
        shader.setFloat(0, size.width);
        shader.setFloat(1, size.height);
        shader.setFloat(2, elapsed);
        final indexFactor = data2Animation.length ~/ 6;

        if (data2Animation.isNotEmpty) {
          shader.setFloat(
              3, getDbfromFft(data2Animation[1 * indexFactor].value));
          shader.setFloat(
              4, getDbfromFft(data2Animation[2 * indexFactor].value));
          shader.setFloat(
              5, getDbfromFft(data2Animation[3 * indexFactor].value));
          shader.setFloat(
              6, getDbfromFft(data2Animation[4 * indexFactor].value));
          shader.setFloat(
              7, getDbfromFft(data2Animation[5 * indexFactor].value));
          shader.setFloat(
              8, getDbfromFft(data2Animation[6 * indexFactor].value));
        }

        shader.setImageSampler(0, image);
        paint.shader = shader;
        canvas.drawRect(
          Rect.fromLTWH(0, 0, size.width, size.height),
          paint,
        );
      },
      child: child,
    );
  }
}

double getDbfromFft(double value) {
  return 10 * log(value) / log(10);
}
