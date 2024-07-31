import 'package:flutter/material.dart';
import 'package:shader_studio/pages/motion_blur_distortion_list/motion_blur_distortion_list.dart';
import 'package:shader_studio/pages/rgb_split_distortion/rgb_split_distortion_page.dart';

class ShaderPage extends StatefulWidget {
  const ShaderPage({
    super.key,
  });

  @override
  State<ShaderPage> createState() => _ShaderPageState();
}

class _ShaderPageState extends State<ShaderPage> {
  int index = 0;
  @override
  void initState() {
    super.initState();
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
          ],
        ),
        Positioned(
          bottom: 32,
          left: 16,
          right: 16,
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 8,
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Option(
                    title: Text('RGB Split Distortion'),
                    selected: index == 0,
                    onTap: () {
                      setState(() {
                        index = 0;
                      });
                    },
                  ),
                  Option(
                    title: Text('Motion Blur'),
                    selected: index == 1,
                    onTap: () {
                      setState(() {
                        index = 1;
                      });
                    },
                  )
                ],
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
