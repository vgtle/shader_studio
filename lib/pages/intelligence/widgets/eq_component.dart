import 'package:flutter/material.dart';
import 'package:shader_studio/pages/intelligence/voice_api.dart';
import 'package:shader_studio/pages/intelligence/widgets/eq.dart';

class EqComponent extends StatefulWidget {
  const EqComponent({
    super.key,
    required this.data,
  });

  final List<({FrequencySpectrum spectrum, double value})> data;

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
            isExpanded ? Size(constraints.maxWidth, 200) : const Size(80, 80);
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
