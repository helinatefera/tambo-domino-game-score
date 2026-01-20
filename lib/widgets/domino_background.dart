import 'package:flutter/material.dart';

class DominoBackground extends StatelessWidget {
  final Widget child;
  final double? opacity;

  const DominoBackground({super.key, required this.child, this.opacity});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/domino_background.jpeg'),
          fit: BoxFit.cover,
          opacity: opacity ?? 0.7,
        ),
      ),
      child: child,
    );
  }
}
