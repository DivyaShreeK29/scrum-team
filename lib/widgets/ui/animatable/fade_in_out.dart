import 'package:flutter/material.dart';

class FadeIn extends StatefulWidget {
  final int duration;
  final Widget content;
  FadeIn({Key? key, required this.duration, required this.content})
      : super(key: key);

  @override
  _FadeInState createState() => _FadeInState();
}

class _FadeInState extends State<FadeIn> {
  double widgetOpacity = 0.0;
  @override
  void initState() {  
    super.initState();
    Future.delayed(Duration(microseconds: 300), () {
      setState(() {
        widgetOpacity = 1.0;
      });
    });
  }

  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: widgetOpacity,
      duration: Duration(milliseconds: widget.duration),
      child: widget.content,
    );
  }
}
