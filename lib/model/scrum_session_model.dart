//import 'package:scrum_poker/main.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:scrum_poker/model/scrum_session_participant_model.dart';
import 'package:scrum_poker/model/scrum_session_summary_model.dart';
import 'package:scrum_poker/model/story_model.dart';
import 'package:uuid/uuid.dart';

///  Represents a Scrum Session

class ScrumSession {
  String? name;
  DateTime? startTime;
  ScrumSessionSummary? summary;
  List<ScrumSessionParticipant> participants = [];
  String? id;
  ScrumSessionParticipant? activeParticipant;
  String? activeParticipantKey;
  Story? activeStory;

  ScrumSession({required startTime, required name}) {
    this.id = newID();
    this.name = name;
    this.startTime = startTime;
  }

  ScrumSession.fromJson(dynamic json) {
    id = json['id'];
    name = json['name'];
    startTime = DateTime.parse(json['startTime']);
    summary = ScrumSessionSummary.fromJson(json['summary']);
    Map _participantsListJson = json['participants'];

    participants = _participantsListJson.values
        .map((participantJson) =>
            ScrumSessionParticipant.fromJSON(participantJson))
        .toList();
  }

  void addParticipant(ScrumSessionParticipant participant) {
    bool found = false;
    for (var aParticipant in this.participants) {
      if (aParticipant.id == participant.id) {
        found = true;
        break;
      }
    }
    if (!found) {
      this.participants.add(participant);
    }
  }

  void removeParticipant(ScrumSessionParticipant participant) {
    if (this.participants.length == 1) {}
    this.participants.remove(this
        .participants
        .firstWhere((element) => (element.id) == participant.id));

    //this.participants.removeWhere((element) => (element.id) == participant.id);
  }

  void updateParticipantConnectivity(BuildContext context, bool isConnected) {
    print(this.activeParticipant?.name);

    // ScrumSessionParticipant part = this.participants.elementAt(
    //     this.participants.indexWhere((p) => p.id == (participant?.id)));
    activeParticipant?.connectivityController = isConnected;
    print(
        "=====participant----------${activeParticipant?.connectivityController}");
    //part.connectivityController = isConnected;
    //print(
    //   "Inside update participant is connected ${part.connectivityController}");

    if (!activeParticipant!.connectivityController) {
      //print("Inside show dialog if block ${part.connectivityController}");
      //{**}
      showAboutDialog(context);
    } else {
      dismissDialog(context);
      //print("Inside show dialog else block ${part.connectivityController}");
    }
  }

  void showAboutDialog(
    BuildContext context,
  ) {
    showDialog<String>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) => AlertDialog(
              title: const Text('You lost your network connection'),
              content: const Text('Trying to reconnect '),
            ));
  }

  void dismissDialog(BuildContext context) {
    Navigator.of(context).pop();
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'startTime': (startTime?.toIso8601String() ?? ''),
        'summary': summary?.toJson(),
        'participants':
            participants.map((participant) => participant.toJson()).toList(),
        'activeParticant': this.activeParticipant?.toJson(),
        'activeParticipantKey': this.activeParticipantKey
      };

  static String newID() {
    String id = Uuid().v1().toString();
    return id;
  }
}












// main() {
//   ScrumSession session = ScrumSession(
//       name: "FirstSession", startTime: DateTime.now());
//   session.addParticipant(ScrumSessionParticipant("Jay", true));
//   print(session.toJson());
// }
