import 'package:flutter/material.dart';
import 'package:scrum_poker/model/scrum_session_model.dart';
import 'package:scrum_poker/rest/firebase_db.dart';
import 'package:scrum_poker/theme/theme.dart';
import 'package:scrum_poker/pages/navigation/navigation_router.dart';
import 'package:scrum_poker/widgets/ui/typograpy_widgets.dart';

Widget joinAnExistingSession(
    {required BuildContext context,
    required AppRouterDelegate routerDelegate,
    bool joinWithLink = false,
    ScrumSession? scrumSession}) {
  TextEditingController existingSessionController = TextEditingController();
  TextEditingController participantNameController = TextEditingController();
  // ignore: unused_local_variable
  final _formKey = GlobalKey<FormState>();
  String? processedSessionId;

  return Container(
    child: Card(
        child: Padding(
            padding: EdgeInsets.all(dimensions.standard_padding * 2),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              heading5(context: context, text: "Join an Existing Session"),
              SizedBox(
                height: 10,
              ),
              if (joinWithLink && scrumSession != null)
                heading4(context: context, text: scrumSession.name!),
              body1(
                  context: context,
                  text: getDescription(joinWithLink, scrumSession)),
              if (!joinWithLink)
                TextField(
                  controller: existingSessionController,
                  decoration: InputDecoration(
                      hintText: "Enter the name of the session"),
                ),
              if (!joinWithLink || (joinWithLink && scrumSession != null))
                TextField(
                  controller: participantNameController,
                  decoration:
                      InputDecoration(hintText: "Enter your name or nickname"),
                ),
              Center(
                  child: TextButton(
                      onPressed: () async {
                        var sessionId = existingSessionController.text;
                        if (joinWithLink) {
                          sessionId = scrumSession!.id!;
                        }
                        ScrumPokerFirebase spfb =
                            await ScrumPokerFirebase.instance;
                        await spfb.joinScrumSession(
                            participantName: participantNameController.text,
                            sessionId: sessionId,
                            owner: false);

                        routerDelegate.pushRoute("/home/$sessionId");
                      },
                      child: Text("JOIN"))),
            ]))),
    width: 500,
  );
}

//returns the appropriate description in the header line based on the statement of the session
String getDescription(bool joinWithLink, ScrumSession? session) {
  String description = "Please enter a nick name and press join";
  if (joinWithLink && session != null) {
    description = "";
  }
  if (joinWithLink && session == null) {
    description = "Getting the session details ...";
  }
  return description;
}


