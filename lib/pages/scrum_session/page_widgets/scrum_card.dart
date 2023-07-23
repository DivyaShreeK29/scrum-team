import 'package:flutter/material.dart';
import 'package:scrum_poker/widgets/ui/typograpy_widgets.dart';
import 'package:scrum_poker/widgets/ui/extensions/widget_extensions.dart';
import 'package:scrum_poker/widgets/ui/extensions/text_extensions.dart';

import '../../../widgets/ui/style.dart';

class ScrumCard extends StatefulWidget {
  final dynamic onCardSelected;
  final String value;
  final bool isSelected;

  ScrumCard(
      {Key? key,
      this.onCardSelected,
      required this.value,
      required this.isSelected})
      : super(key: key);

  _ScrumCardState createState() => _ScrumCardState();
}

class _ScrumCardState extends State<ScrumCard> {
  void onCardClicked() {
    widget.onCardSelected(widget.value);

    getDeviceWidth(context) < 600 ? Navigator.pop(context) : null;
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      height: (widget.isSelected ? 200 : 125),
      width: (widget.isSelected) ? 145 : 95,
      curve: Curves.linearToEaseOut,
      child: GestureDetector(
          child: Card(
              elevation: 3.0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5)),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                        child: Container(
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: AssetImage(
                                      "assets/images/moroccan-flower.png"),
                                  fit: BoxFit.cover),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5)),
                            ),
                            child: Center(
                                child: CircleAvatar(
                              child: (widget.isSelected
                                  ? heading3(
                                          context: context, text: widget.value)
                                      .color(Colors.white)
                                  : heading5(
                                          context: context, text: widget.value)
                                      .color(Colors.white)),
                              radius: widget.isSelected ? 55 : 35,
                            ))))
                  ])),
          onTap: onCardClicked),
    ).fadeInOut();
  }
}
