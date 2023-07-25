
import 'package:flutter/material.dart';

import 'package:scrum_poker/model/scrum_session_model.dart';
import 'package:scrum_poker/pages/navigation/navigation_router.dart';

import 'package:scrum_poker/rest/firebase_db.dart';

import 'package:scrum_poker/widgets/ui/typograpy_widgets.dart';


import '../../model/scrum_session_participant_model.dart';
import '../../widgets/ui/style.dart';


Widget pageHeader(BuildContext context, ScrumSession? session,
    ScrumSessionParticipant? participant, AppRouterDelegate? routerDelegate) {
  return AppBar(
    actions: [
      CancelButton(session, participant, routerDelegate),
    ],
    centerTitle: false,
    title: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      heading6(context: context, text: "Scrum Poker", color: Colors.white),
    ]),
    elevation: 0.0,
    bottomOpacity: 0.0,
    backgroundColor: Theme.of(context).primaryColor,
  );
}

class CancelButton extends StatefulWidget {
  const CancelButton(this.session, this.participant, this.routerDelegate,
      {Key? key})
      : super(key: key);
  final ScrumSessionParticipant? participant;
  final ScrumSession? session;
  final AppRouterDelegate? routerDelegate;

  @override
  State<CancelButton> createState() => _CancelButtonState();
}

class _CancelButtonState extends State<CancelButton> {
  String returnText() {
    if (widget.participant?.isOwner ?? false)
      return "END SESSION";
    else {
      return "LEAVE SESSION";
    }
  }

  void removeParticipantFromScrumSession() async {
    widget.routerDelegate?.pushRoute("/join/${widget.session?.id}");

    ScrumPokerFirebase spfb = await ScrumPokerFirebase.instance;

    spfb.removeFromExistingSession();
  }

  @override

  Widget build(BuildContext context) {
    return   getDeviceWidth(context) > 600
            ? TextButton.icon(
                onPressed: () {
                  removeParticipantFromScrumSession();
                },
                icon: Icon(
                  Icons.exit_to_app,
                  color: Colors.white,
                  size: 30,
                ),
                label: Text(
                  returnText(),
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ))
            : Tooltip(
                message: returnText(),
                child: TextButton.icon(
                    onPressed: () {
                      removeParticipantFromScrumSession();
                    },
                    icon: Icon(
                      Icons.exit_to_app,
                      color: Colors.white,
                      size: 25,
                    ),
                    label: Text(
                      "",
                      style: TextStyle(fontSize: 15, color: Colors.white),
                    )),
              );
  }
}
