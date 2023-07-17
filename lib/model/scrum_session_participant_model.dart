import 'dart:async';

class ScrumSessionParticipant {
  String id = newID();
  String name = "";
  bool isOwner = false;
  String? currentEstimate;
  late StreamController<bool> connectivityController =
      StreamController<bool>.broadcast();

  ScrumSessionParticipant(name, isOwner, id, currentEstimate) {
    this.name = name;
    this.id = id;
    this.isOwner = isOwner;
    this.currentEstimate = currentEstimate;
  }

  factory ScrumSessionParticipant.fromJSON(dynamic json) {
    return ScrumSessionParticipant(
        json['name'], json['owner'], json['id'], json['currentEstimate']);
  }

  Map<String, dynamic> toJson() => {
        'name': this.name,
        'id': id,
        'owner': isOwner,
        'currentEstimate': currentEstimate
      };

  static String newID() {
    return DateTime.now().millisecond.toString();
  }
}
