import 'dart:math';

import 'package:flutter/material.dart';
//import 'package:badges/badges.dart' as badges;

import 'package:scrum_poker/model/scrum_session_participant_model.dart';
import 'package:scrum_poker/widgets/ui/extensions/widget_extensions.dart';
import 'package:scrum_poker/widgets/ui/style.dart';
import 'package:scrum_poker/widgets/ui/typograpy_widgets.dart';
import 'package:scrum_poker/widgets/ui/extensions/text_extensions.dart';

import 'mirror_image.dart';

Widget participantCard(
  BuildContext context,
  ScrumSessionParticipant participant,
  bool showEstimates,
  bool isOfflineProgressIndicator,
) {
  return getDeviceWidth(context) < 600
      ? (AnimatedContainer(
          duration: Duration(milliseconds: 300),
          curve: Curves.easeIn,
          height: (participant.currentEstimate != null &&
                  participant.currentEstimate != '')
              ? 140
              : 110,
          width: (participant.currentEstimate != null &&
                  participant.currentEstimate != '')
              ? 100
              : 80,
          child: TweenAnimationBuilder(
              tween: Tween<double>(begin: 0, end: showEstimates ? pi : 0),
              duration: Duration(milliseconds: 300),
              builder: (BuildContext context, double val, __) {
                return (Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.identity()
                    ..setEntry(3, 2, 0.001)
                    ..rotateY(val),
                  // Adjust the angle as desired
                  child: Card(
                    elevation: 3.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
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
                                fit: BoxFit.cover,
                              ),
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(5),
                                topRight: Radius.circular(5),
                              ),
                            ),
                            child: Center(
                              child: CircleAvatar(
                                child: (participant.currentEstimate == null ||
                                        participant.currentEstimate == '')
                                    ? heading6(context: context, text: '')
                                    : ((val > (pi / 2)) && showEstimates)
                                        ? MirrorText(Text(
                                            participant.currentEstimate ?? '',
                                            style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold),
                                          ).color(Colors.white))
                                        : Text(
                                            "Ready",
                                            style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold),
                                          ).color(Colors.white),
                                radius: (participant.currentEstimate == null ||
                                        participant.currentEstimate == '')
                                    ? 0
                                    : 30,
                                backgroundColor: showEstimates
                                    ? Colors.blue[900]
                                    : Colors.green[900],
                              ),
                            ),
                          ),
                        ),
                        // body1(context: context, text: participant.name)
                        //     .paddingLRTB(left: 8, right: 8, top: 8, bottom: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ((val > (pi / 2)) && showEstimates)
                                ? MirrorText(body1(
                                        context: context,
                                        text: participant.name))
                                    .paddingLRTB(
                                        left: 4, right: 4, top: 4, bottom: 8)
                                : body1(
                                        context: context,
                                        text: participant.name)
                                    .paddingLRTB(
                                        left: 4, right: 4, top: 4, bottom: 8),
                            SizedBox(
                              width: 4,
                            ),
                            isOfflineProgressIndicator
                                ? LinearProgressIndicator()
                                : Text(""),
                          ],
                        )
                      ],
                    ),
                  ),
                ));
              })).fadeInOut())
      : AnimatedContainer(
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
          child: TweenAnimationBuilder(
              tween: Tween<double>(begin: 0, end: showEstimates ? pi : 0),
              duration: Duration(milliseconds: 300),
              builder: (BuildContext context, double val, __) {
                return (Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.identity()
                    ..setEntry(3, 2, 0.001)
                    ..rotateY(val),
                  // Adjust the angle as desired
                  child: Card(
                    elevation: 3.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
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
                                fit: BoxFit.cover,
                              ),
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(5),
                                topRight: Radius.circular(5),
                              ),
                            ),
                            child: Center(
                              child: CircleAvatar(
                                child: (participant.currentEstimate == null ||
                                        participant.currentEstimate == '')
                                    ? heading6(context: context, text: '')
                                    : ((val > (pi / 2)) && showEstimates)
                                        ? MirrorText(heading3(
                                                context: context,
                                                text: participant
                                                        .currentEstimate ??
                                                    '')
                                            .color(Colors.white))
                                        : heading6(
                                                context: context, text: 'Ready')
                                            .color(Colors.white),
                                radius: (participant.currentEstimate == null ||
                                        participant.currentEstimate == '')
                                    ? 0
                                    : 50,
                                backgroundColor: showEstimates
                                    ? Colors.blue[900]
                                    : Colors.green[900],
                              ),
                            ),
                          ),
                        ),
                        // body1(context: context, text: participant.name)
                        //     .paddingLRTB(left: 8, right: 8, top: 8, bottom: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ((val > (pi / 2)) && showEstimates)
                                ? MirrorText(body1(
                                        context: context,
                                        text: participant.name))
                                    .paddingLRTB(
                                        left: 8, right: 8, top: 8, bottom: 16)
                                : body1(
                                        context: context,
                                        text: participant.name)
                                    .paddingLRTB(
                                        left: 8, right: 8, top: 8, bottom: 16),
                            SizedBox(
                              width: 4,
                            ),
                            isOfflineProgressIndicator
                                ? CircularProgressIndicator()
                                : Text(""),
                          ],
                        )
                      ],
                    ),
                  ),
                ));
              })).fadeInOut();
}

Widget buildParticipantCards(
  BuildContext context,
  List<ScrumSessionParticipant> participants,
  bool showEstimates,
  bool isOfflineProgressIndicator,
) {
  return Wrap(
    spacing: 2.0, // Adjust the horizontal spacing between cards here
    runSpacing: 2.0, // Adjust the vertical spacing between cards here
    children: participants.map((participant) {
      return participantCard(
        context,
        participant,
        showEstimates,
        isOfflineProgressIndicator,
      );
    }).toList(),
  );
}
