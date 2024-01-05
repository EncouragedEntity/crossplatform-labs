import 'package:flutter/material.dart';

class CrossImage extends StatelessWidget {
  const CrossImage({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 200,
      height: 200,
      child: Image.asset('assets/cross.png'),
    );
  }
}
