import 'package:flutter/material.dart';

class MirrorText extends StatelessWidget {
  final Text text;

  MirrorText(this.text);

  @override
  Widget build(BuildContext context) {
    return Transform(
        alignment: Alignment.center,
        transform: Matrix4.identity()
          ..scale(-1.0, 1.0, 1.0),
        child: text);
  }
}
