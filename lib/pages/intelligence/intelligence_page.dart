import 'dart:ui';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_shaders/flutter_shaders.dart';
import 'package:shader_studio/main.dart';
import 'package:shader_studio/pages/intelligence/voice_api.dart';
import 'package:shader_studio/pages/intelligence/voice_recognizition_api.dart';

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

  @override
  void initState() {
    super.initState();
    VoiceRecognizitionApi().listen(
      (recognizedWords) => setState(() {
        this.recognizedWords = recognizedWords;
      }),
    );
    VoiceApi().startRecording(
      (data) {
        setState(() {
          this.data = data;
        });
      },
    );
    _ticker = createTicker((elapsed) {
      _elapsed = (elapsed.inMilliseconds / 1000);
      if (data2Animation.isEmpty) {
        data2Animation = data;
      } else {
        for (int i = 0; i < data.length; i++) {
          data2Animation[i] = (
            spectrum: data2Animation[i].spectrum,
            value: lerpDouble(data2Animation[i].value, data[i].value, 0.05)!,
          );
        }
        setState(() {});
      }
      if (mounted) {}
    })
      ..start();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () async {
        await Feedback.forLongPress(context);
      },
      child: Scaffold(
        body: AnimatedSampler(
          enabled: true,
          (image, size, canvas) {
            final paint = Paint();
            final shader =
                ShaderProvider.of(context).perlinShader.fragmentShader();
            shader.setFloat(0, size.width);
            shader.setFloat(1, size.height);
            shader.setFloat(2, _elapsed);
            final indexFactor = data2Animation.length ~/ 6;
            if (data2Animation.isNotEmpty) {
              shader.setFloat(3, data2Animation[1 * indexFactor].value);
              shader.setFloat(4, data2Animation[2 * indexFactor].value);
              shader.setFloat(5, data2Animation[3 * indexFactor].value);
              shader.setFloat(6, data2Animation[4 * indexFactor].value);
              shader.setFloat(7, data2Animation[5 * indexFactor].value);
              shader.setFloat(8, data2Animation[6 * indexFactor].value);
            }

            shader.setImageSampler(0, image);
            paint.shader = shader;
            canvas.drawRect(
              Rect.fromLTWH(0, 0, size.width, size.height),
              paint,
            );
          },
          child: ColoredBox(
            color: Color.fromARGB(255, 30, 3, 66),
            child: Stack(
              children: [
                Positioned.fill(
                    child: Center(child: Text(recognizedWords.join(' ')))),
                Positioned(
                    bottom: 30,
                    left: 30,
                    right: 30,
                    child: EqComponent(
                      data: data,
                    )),
                Positioned(
                    bottom: 120,
                    left: 30,
                    right: 30,
                    child: EqComponent(
                      data: data,
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class EqComponent extends StatefulWidget {
  EqComponent({
    super.key,
    required this.data,
  });

  List<({FrequencySpectrum spectrum, double value})> data;

  @override
  State<EqComponent> createState() => _EqComponentState();
}

class _EqComponentState extends State<EqComponent> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final size =
            isExpanded ? Size(constraints.maxWidth, 200) : Size(80, 80);
        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            setState(() {
              isExpanded = !isExpanded;
            });
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 140),
                curve: Curves.easeInOutCirc,
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 49, 22, 83),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 30,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                width: size.width,
                height: size.height,
                child: !isExpanded
                    ? Center(
                        child: Icon(
                          isExpanded ? Icons.close : Icons.equalizer,
                          color: Colors.white,
                        ),
                      )
                    : Center(child: EQ(data: widget.data)),
              ),
            ],
          ),
        );
      },
    );
  }
}

class EQ extends StatelessWidget {
  final List<({FrequencySpectrum spectrum, double value})> data;

  const EQ({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: BarChart(
          BarChartData(
            titlesData: FlTitlesData(show: false),
            gridData: FlGridData(show: false),
            barTouchData: BarTouchData(enabled: false),
            borderData: FlBorderData(show: false),
            maxY: 40,
            minY: -40,
            barGroups: data.map((e) {
              return BarChartGroupData(
                x: data.indexOf(e),
                barRods: [
                  BarChartRodData(
                    width: 8,
                    gradient: const LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.purpleAccent,
                        Colors.purple,
                      ],
                    ),
                    toY: 3 * e.value.abs() * (1 - (e.value / (e.value + 15))),
                    fromY:
                        3 * -e.value.abs() * (1 - (e.value / (e.value + 15))),
                  ),
                ],
              );
            }).toList(),
          ),
          swapAnimationCurve: Curves.easeInOut,
          swapAnimationDuration: const Duration(milliseconds: 180),
        ),
      ),
    );
  }
}
