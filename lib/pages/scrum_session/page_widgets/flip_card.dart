import 'dart:math';

import 'package:flutter/material.dart';
import 'package:scrum_poker/pages/scrum_session/page_widgets/participant_card.dart';

import '../../../model/scrum_session_participant_model.dart';

Widget flipParticipantCard(
    BuildContext context,
    ScrumSessionParticipant participant,
    bool showEstimates,
    bool isOfflineProgressIndicator) {
  return TweenAnimationBuilder(
      tween: Tween<double>(begin: 0, end: showEstimates ? pi : 0),
      duration: Duration(milliseconds: 300),
      builder: (BuildContext context, double val, __) {
        return Transform(
            alignment: Alignment.center,
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.001)
              ..rotateY(val),
            child: participantCard(context, participant, showEstimates,
                isOfflineProgressIndicator));
      });
}
