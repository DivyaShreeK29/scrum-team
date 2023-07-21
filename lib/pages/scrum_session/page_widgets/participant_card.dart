import 'dart:math';

import 'package:flutter/material.dart';
import 'package:badges/badges.dart' as badges;

import 'package:scrum_poker/model/scrum_session_participant_model.dart';
import 'package:scrum_poker/widgets/ui/extensions/widget_extensions.dart';
import 'package:scrum_poker/widgets/ui/style.dart';
import 'package:scrum_poker/widgets/ui/typograpy_widgets.dart';
import 'package:scrum_poker/widgets/ui/extensions/text_extensions.dart';

Widget participantCard(
    BuildContext context,
    ScrumSessionParticipant participant,
    bool showEstimates,
    bool isOfflineProgressIndicator) {
  String _participant = participant.name.isNotEmpty
      ? participant.name.substring(0, 2).toUpperCase()
      : participant.name.substring(0, 2).toUpperCase();

  return getDeviceWidth(context) < 600
      ? AnimatedContainer(
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
            tween: Tween<double>(begin: 0, end: showEstimates ? pi * 2 : 0),
            duration: Duration(seconds: 1),
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
                          replacement: CircleAvatar(
                            backgroundImage: AssetImage(
                              "assets/images/moroccan-flower.png",
                            ),
                            radius: 60.0,
                          ),
                          child: Stack(
                            children: [
                              CircleAvatar(
                                child: showEstimates
                                    ? heading3(
                                        context: context,
                                        text: participant.currentEstimate ?? '',
                                      ).color(Colors.white)
                                    : heading6(context: context, text: 'Ready')
                                        .color(Colors.white),
                                radius: 60.0,
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
                                        fontSize: 20,
                                        //backgroundColor: Colors.black,
                                        color: Colors.red[700]),
                                    child: badges.Badge(
                                      badgeContent: Text(
                                        _participant,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 25,
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
              tween: Tween<double>(begin: 0, end: showEstimates ? pi * 2 : 0),
              duration: Duration(seconds: 1),
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
                                        ? heading3(
                                                context: context,
                                                text: participant
                                                        .currentEstimate ??
                                                    '')
                                            .color(Colors.white)
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
                        body1(context: context, text: participant.name)
                            .paddingLRTB(left: 8, right: 8, top: 8, bottom: 16),
                      ],
                    ),
                  ),
                ));
              })).fadeInOut();
}
