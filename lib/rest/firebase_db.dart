import 'dart:convert';

import 'package:firebase/firebase.dart';
import 'package:scrum_poker/model/scrum_session_model.dart';
import 'package:scrum_poker/model/scrum_session_participant_model.dart';
import 'package:scrum_poker/model/story_model.dart';
import 'package:scrum_poker/model/story_participant_estimate.dart';
import 'package:scrum_poker/store/shared_preference.dart';
/*
  Singleton class to deal with connection to firebase
 */

class ScrumPokerFirebase {
  Database? _db;
  ScrumSession? scrumSession;
  //callback method to be called when the session is initialized
  dynamic sessionInitializationCallback;
  dynamic sessionInitializationFailedCallback;
  ScrumSessionParticipant? activeParticipant =
      ScrumSessionParticipant("Jay", true, "850", null);
  //key for the participant in the participants map
  String? activeParticipantkey = "0";

  static late final ScrumPokerFirebase instance = ScrumPokerFirebase._();
  ScrumPokerFirebase._() {
    if (apps.isEmpty) {
      initializeApp(
          apiKey: "AIzaSyCnhNtKNvgvP2332dsLp_1SHx7RB0RH9yI",
          authDomain: "scrum-poker-b2819.firebaseapp.com",
          projectId: "scrum-poker-b2819",
          storageBucket: "scrum-poker-b2819.appspot.com",
          messagingSenderId: "708840805223",
          appId: "1:708840805223:web:3566cd157397d6679455c2",
          measurementId: "G-CH265MWWBG",
          databaseURL:
              "https://scrum-poker-b2819-default-rtdb.asia-southeast1.firebasedatabase.app/");
    } else {
      app();
    }
    _db = database();
  }

  Database get realtimeDB => _db!;
  DatabaseReference get dbReference => _db!.ref("sessions");

  ///Starts a new scrum session [sessionName]
  ///that is owned [sessionOwnerName] . This owner gets all the control like
  ///starting a new session,replay etc
  /// Returns a unique session id that identifies the session
  String startNewScrumSession(String sessionName, String sessionOwnerName) {
    ScrumSessionParticipant participant = ScrumSessionParticipant(
        sessionOwnerName, true, ScrumSessionParticipant.newID(), null);
    String sessionId = ScrumSession.newID();
    dbReference.child(sessionId).set({
      "id": sessionId,
      "name": sessionName,
      "startTime": DateTime.now().toUtc().toIso8601String(),
      "participants": [participant.toJson()],
      "summary": {"totalPoints": 0, "totalStories": 0},
      "stories": [],
      "activeStory": null,
      "showCards": false,
    });
    this.activeParticipant = participant;
    //session being started by the scrum master hence, save the participant
    //details
    saveActiveParticipant(sessionId, participant);
    return sessionId;
  }

  void onSessionInitialized(dynamic successCallback, dynamic failedCallback) {
    this.sessionInitializationCallback = successCallback;
    this.sessionInitializationFailedCallback = failedCallback;
  }

  void getScrumSession(String sessionId) async {
    dbReference.child(sessionId).once("value").then((event) {
      dynamic jsonData = event.snapshot.toJson();
      scrumSession = ScrumSession.fromJson(jsonData);
      if (this.activeParticipant == null) {
        this.activeParticipant = getExistingActiveParticipant(sessionId);
      }
      scrumSession!.activeParticipant = this.activeParticipant;
      this.activeParticipantkey =
          getParticipantKey(activeParticipant, jsonData["participants"]);
      scrumSession!.activeParticipantKey = this.activeParticipantkey;
      this.sessionInitializationCallback(scrumSession);
    });
  }

  void joinScrumSession(
      {required String sessionId,
      required String participantName,
      bool owner: false}) {
    ScrumSessionParticipant? participant =
        getExistingActiveParticipant(sessionId);
    if (participant == null) {
      //no active participant stored for this session in shared preferences
      participant = ScrumSessionParticipant(
          participantName, owner, ScrumSessionParticipant.newID(), null);
      dbReference
          .child(sessionId)
          .child("participants")
          .push(participant.toJson());
      this.activeParticipant = participant;
      saveActiveParticipant(sessionId, participant);
    }
  }

  void onNewParticipantAdded(dynamic participantAddedCallback) {
    dbReference
        .child(scrumSession!.id!)
        .child("participants")
        .onChildAdded
        .listen((data) {
      ScrumSessionParticipant participant =
          ScrumSessionParticipant.fromJSON(data.snapshot.toJson());
      //invoke the callback
      participantAddedCallback(participant);
    });
  }

  void onNewParticipantRemoved(dynamic participantRemovedCallback) {
    dbReference
        .child(scrumSession!.id!)
        .child("participants")
        .onChildRemoved
        .listen((data) {
      ScrumSessionParticipant participant =
          ScrumSessionParticipant.fromJSON(data.snapshot.toJson());
      //invoke the callback
      participantRemovedCallback(participant);
    });
  }

  void onNewStorySet(dynamic newStorySetCallback) {
    dbReference
        .child(scrumSession!.id!)
        .child("activeStory/detail")
        .onValue
        .listen((data) {
      dynamic storyJsonMap = data.snapshot.toJson();
      Story newStory = Story.fromJSON(storyJsonMap);
      if (newStorySetCallback != null) {
        newStorySetCallback(newStory);
      }
    });
  }

  void setStoryEstimate(String estimateValue) {
    StoryParticipantEstimate estimate = StoryParticipantEstimate(
        estimate: estimateValue,
        participantId: this.activeParticipant?.id ?? '',
        participantKey: this.activeParticipantkey ?? '');
    dbReference
        .child(
            "${scrumSession!.id}/activeStory/participantEstimates/${this.activeParticipantkey}")
        .set(estimate.toJson());
  }

  void onStoryEstimateChanged(dynamic callback) {
    dbReference
        .child(scrumSession!.id!)
        .child("activeStory/participantEstimates")
        .onValue
        .listen((data) {
      var participantEstimates = data.snapshot;
      if (callback != null) {
        callback(participantEstimates.toJson());
      }
    });
  }

  void setActiveStory(id, title, description) {
    Story newStory = Story(id, title, description, []);
    dbReference
        .child(scrumSession!.id!)
        .child("activeStory/detail")
        .set(newStory.toJson());
    dbReference
        .child(scrumSession!.id!)
        .child("activeStory/participantEstimates")
        .set([]);

    dbReference.child("${scrumSession!.id}/showCards").set(false);
  }

  void showCard() {
    dbReference.child("${scrumSession!.id}/showCards").set(true);
  }

  void onShowCard(dynamic callback) {
    dbReference.child("${scrumSession!.id}/showCards").onValue.listen((data) {
      var value = data.snapshot;
      if (callback != null) {
        callback(value.val());
      }
    });
  }

  /*
  * sets the participantkey in the firbase db. needed for estimate updates
  */
  String getParticipantKey(activeParticipant, participants) {
    String participantkey = '';
    var keys = participants.keys;
    for (var key in keys) {
      if (participants[key]['id'] == activeParticipant.id) {
        participantkey = key;
        break;
      }
    }
    return participantkey;
  }
}

///returns a saved [ScrumSession] object if the [sessionId] of incoming url
///matches the existing session id stored locally else returns null object
ScrumSessionParticipant? getExistingActiveParticipant(String sessionId) {
  ScrumSession? session;
  String? existingSessionString =
      preferences?.getString(PreferenceKeys.CURRENT_SESSION);
  String? activeParticipantString =
      preferences?.getString(PreferenceKeys.ACTIVE_PARTICIPANT);
  if (existingSessionString != null) {
    ScrumSessionParticipant participant =
        ScrumSessionParticipant.fromJSON(activeParticipantString);
    dynamic existingSessionJSON = jsonDecode(existingSessionString);
    session = ScrumSession.fromJson(existingSessionJSON);
    if (session.id == sessionId) {
      return participant;
    } else {
      //if the session id does not match then the user is logging into a new
      //sessoin, so reinitialize the session to null
      return null;
    }
  }
  return null;
}

/// saves  [ScrumSessionParticipant] from shared preferences so it can be
/// retrieved in case the sessoin breaks in between

void saveActiveParticipant(
    String sessionId, ScrumSessionParticipant participant) {
  String participantJSON = participant.toJson().toString();
  preferences?.setString(PreferenceKeys.CURRENT_SESSION, sessionId);
  preferences?.setString(PreferenceKeys.ACTIVE_PARTICIPANT, participantJSON);
}

//HACK FUNCTION, NOT SURE WHY FIREBASE IS RETURNING STRING INSTEAD OF JSON NEED TO DEBUG THAT
// Map<String, dynamic> convertJSONStringtoMap({required String toConvert}) {
//    Map<String, dynamic> jsonMap = Map<String, dynamic>();
//   String onlyElementString = toConvert.substring(1, toConvert.length - 1);
//   print(onlyElementString);
//   List elementPair = onlyElementString.split(",");

//   elementPair.forEach((element) {
//     List nameValue = element.split(":");
//     print(nameValue);
//     jsonMap[nameValue.elementAt(0).trim()] = nameValue.elementAt(1).trim();
//   });
//   return jsonMap;
// }
