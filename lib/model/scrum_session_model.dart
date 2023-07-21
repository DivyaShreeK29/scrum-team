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
      print("in add participant method in Scrum_Session_Model ${aParticipant.id}");
      if (aParticipant.id == participant.id) {
        found = true;
        break;
      }
    }
    if (!found) {
      this.participants.add(participant);
    }
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
