import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_shaders/flutter_shaders.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shader_studio/main.dart';

class RgbSplitDistortionPage extends StatefulWidget {
  const RgbSplitDistortionPage({super.key});

  @override
  State<RgbSplitDistortionPage> createState() => _RgbSplitDistortionPageState();
}

class _RgbSplitDistortionPageState extends State<RgbSplitDistortionPage>
    with SingleTickerProviderStateMixin {
  Offset position = Offset.zero;
  Offset desiredPosition = Offset.zero;
  Offset velocity = Offset.zero;
  late final Ticker ticker;
  Duration lastTime = Duration.zero;

  @override
  void initState() {
    super.initState();
    ticker = createTicker(onUpdate)..start();
  }

  @override
  void dispose() {
    ticker.stop();
    ticker.dispose();
    super.dispose();
  }

  void onUpdate(Duration elapsed) {
    final delta = ((elapsed.inMicroseconds - lastTime.inMicroseconds) /
            Duration.microsecondsPerSecond) *
        60;

    lastTime = elapsed;

    if (desiredPosition == position) {
      return;
    }

    setState(() {
      final distance = desiredPosition - position;
      final amplitude = 1 - max(0, 1000 - distance.distance) / 1000;
      velocity =
          distance * (0.02 + 0.2 * Curves.easeInOut.transform(amplitude));

      position += velocity * delta;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
          backgroundColor: Colors.white,
          body: GestureDetector(
            onPanStart: (details) {
              setState(() {
                desiredPosition = details.globalPosition;
                position = details.globalPosition;
              });
            },
            onPanUpdate: (event) {
              setState(() {
                desiredPosition = event.globalPosition;
              });
            },
            onPanEnd: (details) => setState(() {}),
            onPanCancel: () => setState(() {}),
            child: AnimatedSampler(
              (image, size, canvas) {
                final shader = ShaderProvider.of(context)
                    .rgbSplitDistortionShader
                    .fragmentShader();

                shader.setFloat(0, size.width);
                shader.setFloat(1, size.height);
                shader.setFloat(2, desiredPosition.dx);
                shader.setFloat(3, desiredPosition.dy);
                shader.setFloat(4, velocity.dx * 40);
                shader.setFloat(5, velocity.dy * 40);
                shader.setImageSampler(0, image);
                canvas.drawRect(
                  Rect.fromLTWH(0, 0, size.width, size.height),
                  Paint()..shader = shader,
                );
              },
              key: const Key('animated_sampler'),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(
                      height: 40,
                    ),
                    Text(
                      "Hello World! " * 21,
                      style: GoogleFonts.montserrat(
                          fontSize: 30,
                          color: const Color.fromARGB(255, 244, 247, 255),
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
          )),
    );
  }
}
