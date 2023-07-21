import 'package:flip_card/flip_card_controller.dart';
import 'package:flutter/material.dart';
import 'package:scrum_poker/widgets/ui/animatable/fade_in_out.dart';

extension PaddingExtensions on Widget {
  Widget paddingAll(double padding) {
    return Padding(
      padding: EdgeInsets.all(padding),
      child: this,
    );
  }

  Widget paddingLRTB(
      {required double left,
      required double right,
      required double top,
      required double bottom}) {
    return Padding(
      padding: EdgeInsets.fromLTRB(left, top, right, bottom),
      child: this,
    );
  }

  Widget paddingOnly({left: 0.0, right: 0.0, top: 0.0, bottom: 0.0}) {
    return this.paddingLRTB(left: left, right: right, top: top, bottom: bottom);
  }

  Widget fadeInOut({int duration: 300}) {
    return FadeIn(duration: duration, content: this);
  }


  Widget margin({left: 0.0, right: 0.0, top: 0.0, bottom: 0.0}) {
    return this.paddingLRTB(left: left, right: right, top: top, bottom: bottom);
  }
}
