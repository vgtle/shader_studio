import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:shader_studio/pages/skeleton_page.dart';

Future<void> main() async {
  final rgbSplitDistortionShader =
      await ui.FragmentProgram.fromAsset('lib/shaders/rgb.frag');
  final motionBlurDistortionShader =
      await ui.FragmentProgram.fromAsset('lib/shaders/blur.frag');
  final perlinShader =
      await ui.FragmentProgram.fromAsset('lib/shaders/perlin.frag');
  final shockwaveShader =
      await ui.FragmentProgram.fromAsset('lib/shaders/shockwave.frag');

  runApp(
    ShaderProvider(
      shader: ShaderCollection(
        rgbSplitDistortionShader: rgbSplitDistortionShader,
        motionBlurDistortionShader: motionBlurDistortionShader,
        perlinShader: perlinShader,
        shockwaveShader: shockwaveShader,
      ),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData.dark(),
        home: const ShaderPage(),
      ),
    ),
  );
}

class ShaderProvider extends InheritedWidget {
  const ShaderProvider({
    super.key,
    required this.shader,
    required super.child,
  });

  final ShaderCollection shader;

  static ShaderCollection of(BuildContext context) {
    final provider =
        context.dependOnInheritedWidgetOfExactType<ShaderProvider>();
    return provider!.shader;
  }

  @override
  bool updateShouldNotify(covariant ShaderProvider oldWidget) {
    return oldWidget.shader != shader;
  }
}

class ShaderCollection {
  final ui.FragmentProgram rgbSplitDistortionShader;
  final ui.FragmentProgram motionBlurDistortionShader;
  final ui.FragmentProgram perlinShader;
  final ui.FragmentProgram shockwaveShader;

  ShaderCollection({
    required this.rgbSplitDistortionShader,
    required this.motionBlurDistortionShader,
    required this.perlinShader,
    required this.shockwaveShader,
  });
}
