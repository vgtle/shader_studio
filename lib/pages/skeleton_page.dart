import 'package:flutter/material.dart';
import 'package:shader_studio/pages/intelligence/intelligence_page.dart';
import 'package:shader_studio/pages/motion_blur_distortion_list/motion_blur_distortion_list.dart';
import 'package:shader_studio/pages/rgb_split_distortion/rgb_split_distortion_page.dart';

class ShaderPage extends StatefulWidget {
  const ShaderPage({
    super.key,
  });

  @override
  State<ShaderPage> createState() => _ShaderPageState();
}

class _ShaderPageState extends State<ShaderPage>
    with SingleTickerProviderStateMixin {
  int index = 0;
  bool collapsed = false;
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    )..addListener(() {
        setState(() {});
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        IndexedStack(
          index: index,
          children: const [
            RgbSplitDistortionPage(),
            MotionBlurDistortionPage(),
            IntelligencePage(),
          ],
        ),
        Positioned(
          bottom: 32,
          left: 16,
          right: 16,
          child: Offstage(
            offstage: false,
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 8,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: AnimatedSize(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOutCirc,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            AnimatedSwitcher(
                              duration: const Duration(milliseconds: 200),
                              transitionBuilder: (child, animation) {
                                return FadeTransition(
                                  opacity: animation,
                                  child: child,
                                );
                              },
                              child: collapsed
                                  ? Padding(
                                      padding: const EdgeInsets.only(left: 8.0),
                                      child: Align(
                                          alignment: Alignment.centerLeft,
                                          child: switch (index) {
                                            0 => const Text(
                                                'RGB Split Distortion'),
                                            1 => const Text('Motion Blur'),
                                            2 => const Text('Intelligence'),
                                            _ =>
                                              throw Exception('Invalid index'),
                                          }),
                                    )
                                  : const SizedBox(),
                            ),
                            Align(
                              alignment: Alignment.centerRight,
                              child: IconButton(
                                icon: AnimatedRotation(
                                  turns: collapsed ? 0.25 : 0.75,
                                  duration: const Duration(milliseconds: 300),
                                  child: const Icon(
                                    Icons.chevron_left,
                                  ),
                                ),
                                onPressed: () {
                                  setState(() {
                                    collapsed = !collapsed;
                                    if (collapsed) {
                                      _controller.forward();
                                    } else {
                                      _controller.reverse();
                                    }
                                  });
                                },
                              ),
                            ),
                          ]),
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        child: collapsed
                            ? const SizedBox()
                            : Column(
                                children: [
                                  Option(
                                    title: const Text('RGB Split Distortion'),
                                    selected: index == 0,
                                    onTap: () {
                                      setState(() {
                                        index = 0;
                                      });
                                    },
                                  ),
                                  Option(
                                    title: const Text('Motion Blur'),
                                    selected: index == 1,
                                    onTap: () {
                                      setState(() {
                                        index = 1;
                                      });
                                    },
                                  ),
                                  Option(
                                    title: const Text('Intelligence'),
                                    selected: index == 2,
                                    onTap: () {
                                      setState(() {
                                        index = 2;
                                      });
                                    },
                                  )
                                ],
                              ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class Option extends StatelessWidget {
  const Option({
    super.key,
    required this.title,
    this.onTap,
    this.selected = false,
  });

  final Widget title;
  final VoidCallback? onTap;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Expanded(child: title),
            if (selected)
              const Icon(
                Icons.check,
                color: Colors.green,
              ),
          ],
        ),
      ),
    );
  }
}
