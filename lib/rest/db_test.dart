import 'package:firebase_database/firebase_database.dart';
import 'package:scrum_poker/rest/firebase_db.dart';

void main() async {
  ScrumPokerFirebase sfb = await ScrumPokerFirebase.instance;
  DatabaseReference ref = sfb.dbReference;
  ref.push().set({'name': 'Message', 'comment': 'a good season'});
}
