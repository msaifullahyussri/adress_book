import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class EmptyAnimation extends StatelessWidget {
  const EmptyAnimation({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Lottie.asset(
        'assets/animations/empty.json',
        width: 250,
        height: 250,
        repeat: true,
      ),
    );
  }
}
