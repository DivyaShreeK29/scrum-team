// ignore_for_file: dead_code

//import 'dart:js_util';

import 'package:flutter/material.dart';
import 'package:scrum_poker/model/scrum_session_model.dart';
import 'package:scrum_poker/pages/navigation/navigation_router.dart';
//import 'package:scrum_poker/pages/navigation/navigation_router.dart';
import 'package:scrum_poker/rest/firebase_db.dart';
//import 'package:scrum_poker/widgets/ui/extensions/widget_extensions.dart';
import 'package:scrum_poker/widgets/ui/typograpy_widgets.dart';
import 'package:scrum_poker/pages/scrum_session/page_widgets/display_story_panel.dart';

//import '../../model/scrum_session_participant_model.dart';

import '../../model/scrum_session_participant_model.dart';

// class pageHeader extends StatefulWidget {
//   final String se
//   const pageHeader({Key? key}) : super(key: key);

//   @override
//   State<pageHeader> createState() => _pageHeaderState();
// }

// class _pageHeaderState extends State<pageHeader> {
//   @override
//   Widget build(BuildContext context) {
//     return AppBar(
//     actions: [
//       //   // IconButton(
//       //   //     onPressed: null,
//       //   //     icon: Icon(
//       //   //       Icons.cancel_sharp,
//       //   //       color: Colors.white,
//       //   //     ))

//           pillButton(context: context, text: "END SESSION", onPress: null)
//           : pillButton(context: context, text: "LEAVE SESSION", onPress: null)
//     ],
//     centerTitle: false,
//     title: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//       // AnimatedContainer(duration: Duration(milliseconds: standard_duration),
//       //        width:150,
//       //        child:Image.asset("assets/images/logo_white.png")),
//       heading6(context: context, text: "Scrum Poker", color: Colors.white),
//       //Divider()
//     ]),
//     elevation: 0.0,
//     bottomOpacity: 0.0,
//     backgroundColor: Theme.of(context).primaryColor,
//   );
//   }
// }
Widget pageHeader(BuildContext context, ScrumSession? session,
    ScrumSessionParticipant? participant, AppRouterDelegate? routerDelegate) {
  return AppBar(
    actions: [
      //   // IconButton(
      //   //     onPressed: null,
      //   //     icon: Icon(
      //   //       Icons.cancel_sharp,
      //   //       color: Colors.white,
      //   //     ))
      //SizedBox(width: 200),
      CancelButton(session, participant, routerDelegate),
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
  // bool textCheck = true;
  String returnText() {
    if (widget.participant?.isOwner ?? false)
      return "END SESSION";
    else {
      //textCheck = false;
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
    return pillButton(
      context: context,
      text: returnText(),
      onPress: removeParticipantFromScrumSession,
    );
  }
}
