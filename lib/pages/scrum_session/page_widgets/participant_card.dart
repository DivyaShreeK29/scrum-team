import 'dart:math';

import 'package:flutter/material.dart';
import 'package:badges/badges.dart' as badges;

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
  String _participant = participant.name.isNotEmpty
      ? participant.name.substring(0, 2).toUpperCase()
      : participant.name.substring(0, 2).toUpperCase();

  return getDeviceWidth(context) < 600
      ? AnimatedContainer(
          duration: Duration(milliseconds: 300),
          curve: Curves.easeIn,
          height: (participant.currentEstimate != null &&
                  participant.currentEstimate != '')
              ? 160
              : 160,
          width: (participant.currentEstimate != null &&
                  participant.currentEstimate != '')
              ? 155
              : 155,
          child: TweenAnimationBuilder(
            tween: Tween<double>(begin: 0, end: showEstimates ? pi : 0),
            duration: Duration(milliseconds: 300),
            builder: (BuildContext context, double val, __) {
              print(MediaQuery.of(context).size.width);
              return Transform(
                alignment: Alignment.center,
                transform: Matrix4.identity()
                  ..setEntry(3, 2, 0.001)
                  ..rotateY(val),
                child: Stack(
                  children: [
                    Container(
                      child: Center(
                        child: Visibility(
                          visible: participant.currentEstimate != null &&
                              participant.currentEstimate!.isNotEmpty,
                          replacement: Stack(
                            children: [
                              CircleAvatar(
                                backgroundImage: AssetImage(
                                  "assets/images/moroccan-flower.png",
                                ),
                                radius: 65.0,
                                backgroundColor: Colors.transparent,
                              ),
                              Positioned.fill(
                                child: Align(
                                  alignment: FractionalOffset(0.95, 0.05),
                                  child: Tooltip(
                                    message: participant.name,
                                    textStyle: TextStyle(
                                        fontSize: 30,
                                        //backgroundColor: Colors.black,
                                        color: Color.fromRGBO(14, 14, 14, 1)),
                                    child: badges.Badge(
                                      badgeContent: Text(
                                        _participant,
                                        style: TextStyle(
                                          color:
                                              Color.fromARGB(255, 22, 23, 23),
                                          fontSize: 30,
                                        ),
                                      ),
                                      badgeColor:
                                          Color.fromARGB(255, 73, 192, 203),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          child: Stack(
                            children: [
                              CircleAvatar(
                                child: showEstimates
                                    ? MirrorText(
                                        heading3(
                                          context: context,
                                          text:
                                              participant.currentEstimate ?? '',
                                        ).color(Colors.white),
                                      )
                                    : heading6(context: context, text: 'Ready')
                                        .color(Colors.white),
                                radius: 65.0,
                                backgroundColor: showEstimates
                                    ? Colors.blue[900]
                                    : Colors.green[900],
                              ),
                              Positioned.fill(
                                child: Align(
                                  alignment: FractionalOffset(0.95, 0.05),
                                  child: Tooltip(
                                    message: participant.name,
                                    textStyle: TextStyle(
                                        fontSize: 30,
                                        //backgroundColor: Colors.black,
                                        color:
                                            Color.fromARGB(255, 238, 234, 234)),
                                    child: badges.Badge(
                                      badgeContent: showEstimates
                                          ? MirrorText(
                                              Text(
                                                _participant,
                                                style: TextStyle(
                                                  color: Color.fromARGB(
                                                      255, 14, 13, 13),
                                                  fontSize: 30,
                                                ),
                                              ),
                                            )
                                          : Text(
                                              _participant,
                                              style: TextStyle(
                                                color: Color.fromARGB(
                                                    255, 14, 13, 13),
                                                fontSize: 30,
                                              ),
                                            ),
                                      badgeColor:
                                          Color.fromARGB(255, 229, 57, 41),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        )
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
                                    : showEstimates
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
                            showEstimates
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
