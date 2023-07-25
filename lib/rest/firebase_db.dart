import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:scrum_poker/model/scrum_session_model.dart';
import 'package:scrum_poker/model/scrum_session_participant_model.dart';
import 'package:scrum_poker/model/story_model.dart';
import 'package:scrum_poker/model/story_participant_estimate.dart';
import 'package:scrum_poker/store/shared_preference.dart';
//import 'package:shared_preferences/shared_preferences.dart';
/*
  Singleton class to deal with connection to firebase
 */

class ScrumPokerFirebase {
  static ScrumPokerFirebase? _scrumPokerDB;
  FirebaseDatabase? _db;
  FirebaseAuth? _auth;
  ScrumSession? scrumSession;
  //callback method to be called when the session is initialized
  dynamic sessionInitializationCallback;
  dynamic sessionInitializationFailedCallback;
  ScrumSessionParticipant? activeParticipant =
      ScrumSessionParticipant("Jay", true, "850", null);
  //key for the participant in the participants map
  String? activeParticipantkey = "0";

  //static late final ScrumPokerFirebase instance = ScrumPokerFirebase._();
  ScrumPokerFirebase._(
      {required FirebaseDatabase db, required FirebaseAuth auth}) {
    _db = db;
    _auth = auth;
  }

  static Future<ScrumPokerFirebase> get instance async {
    if (_scrumPokerDB == null) {
      FirebaseOptions appOptions = FirebaseOptions(
          apiKey: "AIzaSyCJTcgku4Cyg62svj_kCM8e1BPDlD8WPsE",
          appId: "1:315539366379:web:db33c5c6554e5c6fbcb9ae",
          messagingSenderId: "315539366379",
          projectId: "scrum-poker-devdb",
          authDomain: "scrum-poker-devdb.firebaseapp.com",
          databaseURL:
              "https://scrum-poker-devdb-default-rtdb.asia-southeast1.firebasedatabase.app/",
          // measurementId: "G-CH265MWWBG",
          storageBucket: "scrum-poker-devdb.appspot.com");
      FirebaseApp scrumPokerApp =
          await Firebase.initializeApp(options: appOptions);
      FirebaseAuth auth = FirebaseAuth.instanceFor(app: scrumPokerApp);

      FirebaseDatabase db = FirebaseDatabase.instanceFor(app: scrumPokerApp);
      _scrumPokerDB = ScrumPokerFirebase._(db: db, auth: auth);
    }
    return _scrumPokerDB!;
  }

  FirebaseDatabase get realtimeDB => _db!;
  DatabaseReference get dbReference => _db!.ref("sessions");
  FirebaseAuth get authenticate => _auth!;

  get firebase => null;

  ///Starts a new scrum session [sessionName]
  ///that is owned [sessionOwnerName] . This owner gets all the control like
  ///starting a new session,replay etc
  /// Returns a unique session id that identifies the session
  Future<String> startNewScrumSession(
      String sessionName, String sessionOwnerName) async {
    ScrumSessionParticipant participant = ScrumSessionParticipant(
        sessionOwnerName, true, ScrumSessionParticipant.newID(), null);
    await authenticate.signInWithEmailAndPassword(
        email: "jay@scrumpoker.com", password: "asdfgh");
    String sessionId = ScrumSession.newID();
    await dbReference.child(sessionId).set({
      "id": sessionId,
      "name": sessionName,
      "startTime": DateTime.now().toUtc().toIso8601String(),
      "summary": {"totalPoints": 0, "totalStories": 0},
      "stories": [],
      "activeStory": null,
      "showCards": false,
    });
    DatabaseReference partcipantRef =
        dbReference.child(sessionId).child("participants").push();
    partcipantRef.set(participant.toJson());
    this.activeParticipant = participant;
 
    saveActiveParticipant(sessionId, participant);
    return sessionId;
  }

  void onSessionInitialized(dynamic successCallback, dynamic failedCallback) {
    this.sessionInitializationCallback = successCallback;
    this.sessionInitializationFailedCallback = failedCallback;
  }

  Future<DataSnapshot> get participants {
    return dbReference.child(scrumSession!.id!).child("participants").get();
  }

  void getScrumSession(String sessionId) async {
    await authenticate.signInWithEmailAndPassword(
        email: "jay@scrumpoker.com", password: "asdfgh");
    DatabaseEvent event =
        await dbReference.child(sessionId).once(DatabaseEventType.value);

    Map<String, dynamic>? sessionData =
        event.snapshot.value as Map<String, dynamic>?;
    scrumSession = ScrumSession.fromJson(sessionData);
    if (this.activeParticipant == null) {
      this.activeParticipant = getExistingActiveParticipant(sessionId);
    }
    scrumSession!.activeParticipant = this.activeParticipant;
    this.activeParticipantkey =
        getParticipantKey(activeParticipant, sessionData!["participants"]);
    scrumSession!.activeParticipantKey = this.activeParticipantkey;
    this.sessionInitializationCallback(scrumSession);
  }

  Future<void> joinScrumSession(
      {required String sessionId,
      required String participantName,
      bool owner = false}) async {
    await authenticate.signInWithEmailAndPassword(
        email: "jay@scrumpoker.com", password: "asdfgh");
    ScrumSessionParticipant? participant =
        getExistingActiveParticipant(sessionId);

    if (participant == null) {
      
      
      participant = ScrumSessionParticipant(
          participantName, owner, ScrumSessionParticipant.newID(), null);
      DatabaseReference partcipantRef =
          dbReference.child(sessionId).child("participants").push();
      await partcipantRef.set(participant.toJson());
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
          ScrumSessionParticipant.fromJSON(data.snapshot.value);
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
          ScrumSessionParticipant.fromJSON(data.snapshot.value);
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
      dynamic storyJsonMap = data.snapshot.value;
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
        callback(participantEstimates.value);
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
      var snapshot = data.snapshot;
      if (callback != null) {
        callback(snapshot.value);
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
      print(participants[key]['id']);
      if (participants[key]['id'] == activeParticipant.id) {
        participantkey = key;
        break;
      }
    }
    return participantkey;
  }

  void removeFromExistingSession() async {
    print("Inside removeFromExistingSession");

    DatabaseEvent event = await dbReference
        .child(scrumSession!.id!)
        .once(DatabaseEventType.value);

    Map<String, dynamic>? removeSessionData =
        event.snapshot.value as Map<String, dynamic>?;

    if (scrumSession!.activeParticipant!.isOwner) {
      await dbReference.child(scrumSession!.id!).remove();
    } else {
      var participantKey = getParticipantKey(
          activeParticipant, removeSessionData!["participants"]);
      await dbReference
          .child(scrumSession!.id!)
          .child("participants")
          .child(participantKey)
          .remove();

      removeAllDataFromSharedPreferences();
    }
  }

  void onEndSession(dynamic callback) {
    dbReference.onChildRemoved.listen((event) {
      

      var E = event.snapshot.value as Map;

      if (scrumSession!.id == E['id']) {
        callback();
      }
    });
  }
}


ScrumSessionParticipant? getExistingActiveParticipant(String sessionId) {
  ScrumSession? session;
  String? existingSessionString =
      preferences?.getString(PreferenceKeys.CURRENT_SESSION);
  print("in geap");
  print(existingSessionString);
  print("in geap1");
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
      
      return null;
    }
  }
  return null;
}



void saveActiveParticipant(
    String sessionId, ScrumSessionParticipant participant) {
  String participantJSON = participant.toJson().toString();
  preferences?.setString(PreferenceKeys.CURRENT_SESSION, sessionId);
  preferences?.setString(PreferenceKeys.ACTIVE_PARTICIPANT, participantJSON);
  print("Active participant saved...");
}

//HACK FUNCTION, NOT SURE WHY FIREBASE IS RETURNING STRING INSTEAD OF JSON NEED TO DEBUG THAT
// Map<String, dynamic> convertJSONStringtoMap({required String toConvert}) {

void removeAllDataFromSharedPreferences() async {
  print("Inside removeALldata");
  await preferences?.clear();
}

