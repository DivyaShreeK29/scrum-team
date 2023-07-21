import 'dart:math';

import 'package:flutter/material.dart';
import 'package:scrum_poker/model/scrum_session_participant_model.dart';
import 'package:scrum_poker/widgets/ui/typograpy_widgets.dart';
import 'package:scrum_poker/widgets/ui/extensions/widget_extensions.dart';
import 'package:scrum_poker/widgets/ui/extensions/text_extensions.dart';

Widget participantCard(BuildContext context,
    ScrumSessionParticipant participant, bool showEstimates, double angle) {
  return TweenAnimationBuilder(
    tween: Tween<double>(begin: 0, end: angle),
    duration: Duration(milliseconds: 500),
    curve: Curves.easeIn,
    builder: (BuildContext context, double value, __) {
      final angle = value > (pi / 2) ? pi - value : value;

      return (Transform(
          transform: Matrix4.identity()
            ..setEntry(3, 2, 0.001)
            ..rotateY(value),
          alignment: Alignment.center,
          child: AnimatedContainer(
              duration: Duration(milliseconds: 300),
              curve: Curves.easeIn,
              height: (participant.currentEstimate != null &&
                      participant.currentEstimate != '')
                  ? 250
                  : 200,
              width: (participant.currentEstimate != null &&
                      participant.currentEstimate != '')
                  ? 175
                  : 145,
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
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(5),
                                topRight: Radius.circular(5))),
                        child: Center(
                          child: CircleAvatar(
                            child: (participant.currentEstimate == null ||
                                    participant.currentEstimate == '')
                                ? heading6(context: context, text: '')
                                : showEstimates
                                    ? heading3(
                                            context: context,
                                            text: participant.currentEstimate ??
                                                '')
                                        .color(Colors.white)
                                    : heading6(context: context, text: 'Ready')
                                        .color(Colors.white),
                            radius: ((participant.currentEstimate == null ||
                                    participant.currentEstimate == '')
                                ? 0
                                : 50),
                            backgroundColor: showEstimates
                                ? Colors.blue[900]
                                : Colors.green[900],
                          ),
                        ),
                      ),
                    ),
                    body1(context: context, text: participant.name)
                        .paddingLRTB(left: 8, right: 8, top: 8, bottom: 16)
                  ],
                ),
              ))

          // : Transform(
          //     transform: Matrix4.identity()
          //       ..setEntry(3, 2, 0.001)
          //       ..rotateY(value),
          //     alignment: Alignment.center,
          //     child: Card(
          //       child: Text("Hello"),
          //     ),
          //   ),
          ));
    },
  );
  // .fadeInOut();
}
