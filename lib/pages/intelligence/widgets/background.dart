import 'package:flutter/material.dart';

class Background extends StatelessWidget {
  const Background({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: NetworkImage(
            'https://picsum.photos/2160/3840?random}',
          ),
          fit: BoxFit.cover,
        ),
      ),
      child: child,
    );
  }
}
