import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_shaders/flutter_shaders.dart';
import 'package:shader_studio/main.dart';

class ShockwaveShader extends StatelessWidget {
  const ShockwaveShader(
      {super.key,
      required this.elapsed,
      required this.shockwaveAnimationStart,
      required this.child});

  final double elapsed;
  final double shockwaveAnimationStart;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return AnimatedSampler(
      key: const Key("AnimatedSampler"),
      (image, size, canvas) {
        final paint = Paint();
        final shader =
            ShaderProvider.of(context).shockwaveShader.fragmentShader();
        shader.setFloat(0, size.width);
        shader.setFloat(1, size.height);
        shader.setFloat(2, min(elapsed - shockwaveAnimationStart, 1));

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
