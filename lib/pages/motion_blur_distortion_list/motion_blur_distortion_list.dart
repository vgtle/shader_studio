import 'dart:math';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_shaders/flutter_shaders.dart';
import 'package:shader_studio/main.dart';

const colors = [
  Colors.red,
  Colors.green,
  Colors.blue,
  Colors.yellow,
  Colors.purple,
  Colors.orange,
  Colors.pink,
  Colors.teal,
  Colors.cyan,
  Colors.indigo,
  Colors.amber,
  Colors.lime,
  Colors.brown,
  Colors.grey,
  Colors.black,
];

class MotionBlurDistortionPage extends StatefulWidget {
  const MotionBlurDistortionPage({super.key});

  @override
  State<MotionBlurDistortionPage> createState() =>
      _MotionBlurDistortionPageState();
}

class _MotionBlurDistortionPageState extends State<MotionBlurDistortionPage> {
  late final ScrollController _controller;
  ui.Image? previosImage;
  double offset = 0;
  double velocity = 0;

  @override
  void initState() {
    super.initState();
    _controller = ScrollController(
      onAttach: (position) => position.isScrollingNotifier.addListener(() {
        if (!position.isScrollingNotifier.value) {
          setState(() {
            previosImage = null;
            velocity = 0;
          });
        }
      }),
    )..addListener(scrollListener);
  }

  void scrollListener() {
    velocity = offset - _controller.offset;
    offset = _controller.offset;
  }

  @override
  void dispose() {
    _controller.removeListener(scrollListener);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: AnimatedSampler(
        enabled: true,
        (image, size, canvas) {
          final shader = ShaderProvider.of(context)
              .motionBlurDistortionShader
              .fragmentShader();

          shader.setFloat(0, size.width);
          shader.setFloat(1, size.height);
          shader.setFloat(2, 0);
          shader.setFloat(3, velocity);
          shader.setImageSampler(0, image);
          canvas.drawRect(
            Rect.fromLTWH(0, 0, size.width, size.height),
            Paint()..shader = shader,
          );
        },
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 500),
            child: ListView.builder(
              padding: const EdgeInsets.all(20),
              physics: const BouncingScrollPhysics(),
              prototypeItem: const SizedBox(height: 200),
              controller: _controller,
              itemBuilder: (context, index) => Padding(
                key: ValueKey(index),
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 10,
                        spreadRadius: 2,
                      ),
                      BoxShadow(
                        color: ui.Color.fromARGB(31, 104, 98, 37),
                        blurRadius: 20,
                        spreadRadius: 2,
                      ),
                    ],
                    borderRadius: BorderRadius.circular(28),
                    border: Border.all(
                      color: colors[index % colors.length],
                      width: 2,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(22),
                            child: Image.network(
                              "https://picsum.photos/1200/800?random=$index",
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              itemCount: 500,
            ),
          ),
        ),
      ),
    );
  }
}
