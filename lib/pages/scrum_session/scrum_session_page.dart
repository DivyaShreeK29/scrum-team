import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
//import 'package:internet_connection_checker/internet_connection_checker.dart';
//import 'package:scrum_poker/ExitSession/exit.dart';
import 'package:scrum_poker/model/scrum_session_model.dart';
import 'package:scrum_poker/model/scrum_session_participant_model.dart';
//import 'package:scrum_poker/model/scrum_session_participant_model.dart';
import 'package:scrum_poker/model/story_model.dart';
import 'package:scrum_poker/pages/app_shell/header.dart';
import 'package:scrum_poker/pages/navigation/navigation_router.dart';
import 'package:scrum_poker/pages/scrum_session/page_widgets/create_story_panel.dart';
import 'package:scrum_poker/pages/scrum_session/page_widgets/display_story_panel.dart';
import 'package:scrum_poker/pages/scrum_session/page_widgets/scrum_cards_list.dart';
import 'package:scrum_poker/rest/firebase_db.dart';
import 'package:scrum_poker/pages/scrum_session/page_widgets/participant_card.dart';
import 'package:scrum_poker/widgets/ui/extensions/widget_extensions.dart';
import 'dart:html';

import 'package:fluttertoast/fluttertoast.dart';

//import '../connectivity/connectivity.dart';
// ignore: avoid_web_libraries_in_flutter
//import 'dart:html' as html;

//html.Element? appElement; // Reference to your app element

void showToastMessage(String msg) {
  // Replace with your own toast implementation or package

  Fluttertoast.showToast(
    msg: msg,
    toastLength:
        Toast.LENGTH_SHORT, // Duration for which the toast should be visible
    gravity: ToastGravity
        .BOTTOM_RIGHT, // Position of the toast message on the screen
    timeInSecForIosWeb:
        5, // Specific to iOS/web platforms, the duration for which the toast should be visible
    backgroundColor: Colors.black87, // Background color of the toast message
    textColor: Colors.white, // Text color of the toast message
    fontSize: 16.0, // Font size of the toast message
  );
  //print("Host has exited");
}

///✓
class ScrumSessionPage extends StatefulWidget {
  final String id;
  final AppRouterDelegate? routerDelegate;

  ScrumSessionPage({Key? key, required this.id, this.routerDelegate})
      : super(key: key);

  @override
  _ScrumSessionPageState createState() => _ScrumSessionPageState(id);
}

class _ScrumSessionPageState extends State<ScrumSessionPage> {
  String? sessionId;
  ScrumSession? scrumSession;
  Story? activeStory;
  AppRouterDelegate? routerDelegater;
  bool showNewStoryInput = false;
  bool showCards = false;
  bool resetParticipantScrumCards = false;
  bool exitPage = false;
  final scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();
  bool isOfflineProgressIndicator = false;
  //ConnectivityService connectivityService = ConnectivityService();

  _ScrumSessionPageState(String id) {
    this.sessionId = id;
  }

  void initializeScrumSession() async {
    ScrumPokerFirebase spfb = await ScrumPokerFirebase.instance;
    spfb.onSessionInitialized(
        scrumSessionInitializationSuccessful, scrumSessionInitializationFailed);
    spfb.getScrumSession(widget.id);
  }

  @override
  void initState() {
    super.initState();
    initializeScrumSession();
    // connectivityService.startMonitoring((participants) {
    //   setState(() {
    //     this.scrumSession?.participants =
    //         participants as List<ScrumSessionParticipant>;
    //     this.scrumSession?.updateParticipantConnectivity(context);
    //   });
    // });

    getConnectivity();
    browserEventListeners();
    //appElement =
    // html.querySelector('#app'); // Replace 'app' with your app element ID

    //set callbacks into the session
  }

  void getConnectivity() {
    Connectivity().onConnectivityChanged.listen((result) {
      //var _connectivityResult = result;
      bool isConnected = result != ConnectivityResult.none;
      print("=============$result");
      print("=============$isConnected");

      if (result == ConnectivityResult.none) {
        setState(() {
          isOfflineProgressIndicator = !isConnected;
        });

        showSnackbar(
            "${scrumSession?.activeParticipant?.name} lost network connection");
        Timer(Duration(seconds: 20), () {
          print("Executed after 1 minute");
          if (!isConnected) {
            print("Executed after 1 minute if olgade");
            this.onNewParticipantRemoved(scrumSession!.activeParticipant!);
          }
        });
      }
      if (result == ConnectivityResult.wifi) {
        isOfflineProgressIndicator = !isConnected;
        showSnackbar(
            "${scrumSession!.activeParticipant?.name} restored network connection");

        () async {
          ScrumPokerFirebase spfb = await ScrumPokerFirebase.instance;
          DataSnapshot participantsJson = await spfb.participants;
          Map _participantsListJson = participantsJson.value as Map;

          var listOfParticipants = _participantsListJson.values
              .map((participant) =>
                  ScrumSessionParticipant.fromJSON(participant))
              .toList();

          print("values = ${participantsJson.value}");

          listOfParticipants.forEach((element) {
            print("in for each ${element.toJson()}");
          });
          print(listOfParticipants);
          setState(() {
            scrumSession!.participants = listOfParticipants;
          });
        }();
      }
      setState(() {
        this.scrumSession?.updateParticipantConnectivity(context, isConnected);
      });
    });
  }

  void browserEventListeners() {
    window.onBeforeUnload.listen((event) async {
      print("onBeforeUnload get triggered");

      //event.preventDefault();
      // event.="Are you sure you want to leave thsis page???";
      //window.confirm();

      ScrumPokerFirebase spfb = await ScrumPokerFirebase.instance;
      spfb.removeFromExistingSession();
    });
  }

  void scrumSessionInitializationSuccessful(scrumSession) {
    setState(() {
      this.scrumSession = scrumSession;
      ScrumPokerFirebase.instance.then((ScrumPokerFirebase spfb) {
        spfb.onNewParticipantAdded(onNewParticipantAdded);
        spfb.onNewStorySet(onNewStorySet);
        spfb.onStoryEstimateChanged(onStoryEstimatesChanged);
        spfb.onShowCard(onShowCardsEventTriggered);
        spfb.onEndSession(onEndSession);
        spfb.onNewParticipantRemoved(onNewParticipantRemoved);
      });
    });
  }

  void scrumSessionInitializationFailed(error) {
    // ignore: todo
    //todo: implement erro handling
  }

  void onNewParticipantAdded(newParticipant) {
    setState(() {
      this.scrumSession?.addParticipant(newParticipant);
    });
  }

  void onNewParticipantRemoved(ScrumSessionParticipant? oldParticipant) {
    print(
        "_______________________________----------------____________________-");
    // print(scrumSession?.activeParticipant?.name);
    // print(oldParticipant?.name);

    //if (scrumSession?.activeParticipant == oldParticipant) {
    // widget.routerDelegate!.popRoute();
    // } else {
    setState(() {
      this.scrumSession?.removeParticipant(oldParticipant!);
      showSnackbar('${oldParticipant!.name} left the session');
    });
  }

  void onEndSession() {
    widget.routerDelegate!.pushRoute("/session-ended");
  }

  void onNewStorySet(story) {
    setState(() {
      this.activeStory = story;
      this.showCards = false;
      this.showNewStoryInput = false;
      this.scrumSession?.participants.forEach((participant) {
        participant.currentEstimate = '';
      });
      this.resetParticipantScrumCards = true;
    });
  }

  void onNewStoryPressed() {
    //  ScrumPokerFirebase.instance.setActiveStory(null, null, null);
    setState(() {
      this.showNewStoryInput = true;
    });
  }

  void onShowCardsButtonPressed() {
    ScrumPokerFirebase.instance
        .then((ScrumPokerFirebase spfb) => spfb.showCard());
  }

  void onShowCardsEventTriggered(bool value) {
    setState(() {
      this.showCards = value;
    });
  }

  void onCardSelected(String selectedValue) {
    this.resetParticipantScrumCards = false;
    ScrumPokerFirebase.instance.then(
        (ScrumPokerFirebase spfb) => spfb.setStoryEstimate(selectedValue));
  }

  onStoryEstimatesChanged(participantEstimates) {
    if (participantEstimates != null && participantEstimates is Map) {
      var estimateJson = participantEstimates.values;
      var participants = scrumSession?.participants ?? [];
      for (var estimate in estimateJson) {
        var index = 0;
        for (var participant in participants) {
          if (estimate["participantid"] == participant.id) {
            scrumSession?.participants[index].currentEstimate =
                estimate["estimate"];
            break;
          }
          index = index + 1;
        }
      }

      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    //onSessionExit();
    return Material(
      child: ScaffoldMessenger(
        key: scaffoldMessengerKey,
        child: Scaffold(
          body: AnimatedContainer(
            duration: Duration(microseconds: 300),
            color: Theme.of(context).scaffoldBackgroundColor,
            child: buildScrumSessionPage(context),
          ),
        ),
      ),
    );
  }

  Widget buildScrumSessionPage(BuildContext context) {
    return Column(children: [
      pageHeader(context, scrumSession, scrumSession?.activeParticipant,
          widget.routerDelegate),
      ((this.showNewStoryInput == false)
          ? buildDisplayStoryPanel(
              context,
              activeStory,
              onNewStoryPressed,
              onShowCardsButtonPressed,
              scrumSession?.activeParticipant,
              scrumSession)
          : buildCreateStoryPanel(context)),
      Expanded(
          child: SingleChildScrollView(
              child: Column(children: [
        buildParticipantsPanel(context, showCards),
        Divider(
          color: Colors.white38,
        ).margin(top: 8.0, bottom: 8.0),
        ScrumCardList(
            onCardSelected: onCardSelected,
            resetCardList: this.resetParticipantScrumCards,
            isLocked: this.showCards)
      ])))
    ]);
  }

  Widget buildParticipantsPanel(BuildContext context, showEstimates) {
    //print(" --In build of ParticipantPanel ${scrumSession!.participants}");
    return Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        children: scrumSession?.participants
                .map((participant) => participantCard(context, participant,
                    showEstimates, isOfflineProgressIndicator))
                .toList() ??
            []);
  }

  void showSnackbar(String msg) {
    scaffoldMessengerKey.currentState!.clearSnackBars();
    scaffoldMessengerKey.currentState!.showSnackBar(
      SnackBar(
        content: Text(msg),
        duration: Duration(seconds: 5),
        action: SnackBarAction(
          label: 'Close',
          onPressed: () {
            // Perform an action when the Snackbar action button is pressed
            // For example, you can dismiss the Snackbar
            scaffoldMessengerKey.currentState!.hideCurrentSnackBar();
          },
        ),
      ),
    );
  }
}
