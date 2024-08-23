import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_shaders/flutter_shaders.dart';
import 'package:shader_studio/main.dart';

class IntelligencePage extends StatefulWidget {
  const IntelligencePage({super.key});

  @override
  State<IntelligencePage> createState() => _IntelligencePageState();
}

class _IntelligencePageState extends State<IntelligencePage>
    with SingleTickerProviderStateMixin {
  double _elapsed = 0;

  late final Ticker _ticker;

  @override
  void initState() {
    super.initState();
    _ticker = createTicker((elapsed) {
      _elapsed = (elapsed.inMilliseconds / 1000);
      if (mounted) {
        setState(() {});
      }
    })
      ..start();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red,
      body: AnimatedSampler(
        (image, size, canvas) {
          final paint = Paint();
          final shader =
              ShaderProvider.of(context).perlinShader.fragmentShader();
          shader.setFloat(0, size.width);
          shader.setFloat(1, size.height);
          shader.setFloat(2, _elapsed);
          shader.setImageSampler(0, image);
          paint.shader = shader;
          canvas.drawRect(
            Rect.fromLTWH(0, 0, size.width, size.height),
            paint,
          );
        },
        child: Center(
            child: Column(
          children: [
            Expanded(
              child: ColoredBox(
                color: Color.fromARGB(255, 30, 3, 66),
                child: Center(child: SizedBox()),
              ),
            ),
          ],
        )),
      ),
    );
  }
}
