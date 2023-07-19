// ignore_for_file: dead_code

//import 'dart:js_util';

import 'package:flutter/material.dart';
import 'package:scrum_poker/model/scrum_session_model.dart';
import 'package:scrum_poker/rest/firebase_db.dart';
//import 'package:scrum_poker/widgets/ui/extensions/widget_extensions.dart';
import 'package:scrum_poker/widgets/ui/typograpy_widgets.dart';
import 'package:scrum_poker/pages/scrum_session/page_widgets/display_story_panel.dart';

//import '../../model/scrum_session_participant_model.dart';

import '../../model/scrum_session_participant_model.dart';

Widget pageHeader(
  BuildContext context,
  ScrumSession? session,
  ScrumSessionParticipant? participant,
) {
  return AppBar(
    actions: [
      CancelButton(session, participant),
    ],
    centerTitle: false,
    title: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      heading6(context: context, text: "Scrum Poker", color: Colors.white),
      //Divider()
    ]),
    elevation: 0.0,
    bottomOpacity: 0.0,
    backgroundColor: Theme.of(context).primaryColor,
  );
}

class CancelButton extends StatefulWidget {
  const CancelButton(this.session, this.participant, {Key? key})
      : super(key: key);
  final ScrumSessionParticipant? participant;
  final ScrumSession? session;

  @override
  State<CancelButton> createState() => _CancelButtonState();
}

class _CancelButtonState extends State<CancelButton> {
  bool textCheck = true;
  String returnText() {
    if (widget.participant?.isOwner ?? false)
      return "END SESSION";
    else {
      textCheck = false;
      return "LEAVE SESSION";
    }
  }

  void initialiseRemoval() async {
    ScrumPokerFirebase spfb = await ScrumPokerFirebase.instance;
    spfb.removeFromExistingSession();
  }

  @override
  Widget build(BuildContext context) {
    return pillButton(
      context: context,
      text: returnText(),
      onPress: initialiseRemoval,
    );
  }
}
