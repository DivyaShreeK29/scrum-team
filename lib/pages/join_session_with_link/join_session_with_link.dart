import 'package:flutter/material.dart';
import 'package:scrum_poker/model/scrum_session_model.dart';
import 'package:scrum_poker/pages/landing/page_widgets/join_an_existing_session.dart';
import 'package:scrum_poker/pages/navigation/navigation_router.dart';
import 'package:scrum_poker/rest/firebase_db.dart';

class JoinSessionFromLink extends StatefulWidget {
  final String id;
  final AppRouterDelegate routerDelegate;

  JoinSessionFromLink(
      {Key? key, required this.id, required this.routerDelegate})
      : super(key: key);

  _JoinSessionFromLinkState createState() => _JoinSessionFromLinkState();
}

class _JoinSessionFromLinkState extends State<JoinSessionFromLink> {
  ScrumSession? scrumSession;

  _JoinSessionFromLinkState() {
    ScrumPokerFirebase.instance.onSessionInitialized(
        scrumSessionInitializationSuccessful, scrumSessionInitializationFailed);
  }

  @override
  void initState() {
    super.initState();
    ScrumPokerFirebase.instance.getScrumSession(widget.id);
  }

  void scrumSessionInitializationSuccessful(scrumSession) {
    setState(() {
      this.scrumSession = scrumSession;
    });
  }

  void scrumSessionInitializationFailed(error) {
    // ignore: todo
    //todo: implement erro handling
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
        duration: Duration(microseconds: 300),
        color: Colors.blue[900],
        child: Center(
            child: Wrap(children: [
          joinAnExistingSession(
              context: context,
              routerDelegate: widget.routerDelegate,
              joinWithLink: true,
              scrumSession: this.scrumSession)
        ])));
  }
}
