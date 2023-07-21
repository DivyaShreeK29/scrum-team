import 'package:flutter/material.dart';
import 'package:scrum_poker/model/scrum_session_model.dart';
import 'package:scrum_poker/rest/firebase_db.dart';
import 'package:scrum_poker/theme/theme.dart';
import 'package:scrum_poker/pages/navigation/navigation_router.dart';
import 'package:scrum_poker/widgets/ui/typograpy_widgets.dart';

Widget joinAnExistingSession(
    {required BuildContext context,
    required AppRouterDelegate routerDelegate,
    bool joinWithLink= false,
    ScrumSession? scrumSession}) {
  TextEditingController existingSessionController = TextEditingController();
  TextEditingController participantNameController = TextEditingController();
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
                  SizedBox(
                height: 20,
              ),

              if (!joinWithLink)
                TextField(
                  controller: existingSessionController,
                  decoration: InputDecoration(
                      hintText: "Enter the session url"),
                ),

              if (!joinWithLink || (joinWithLink && scrumSession != null))
                TextField(
                  controller: participantNameController,
                  decoration:
                      InputDecoration(hintText: "Enter your name or nickname"),
                ),
              SizedBox(
                height: 40,
              ),
              Center(
                  child: TextButton(
                      onPressed: () async {
                        await joinSSession(joinWithLink,scrumSession,existingSessionController,participantNameController,routerDelegate);
                      },
                      child: Text("JOIN"))),
            ]))),
    width: 500,
  );
}


Future<void> joinSSession(bool joinWithLink,ScrumSession? scrumSession,TextEditingController existingSessionController,TextEditingController participantNameController,AppRouterDelegate? routerDelegate)async
  {
                        print("inside onScrumsession");
                        var sessionId = existingSessionController.text;

                        if (joinWithLink) {
                          sessionId = scrumSession!.id!;
                        }
                        if(!joinWithLink || (joinWithLink && scrumSession != null)){
                        ScrumPokerFirebase spfb =
                            await ScrumPokerFirebase.instance;
                         spfb.joinScrumSession(
                            participantName: participantNameController.text,
                            sessionId: sessionId,
                            owner: false);

                        routerDelegate?.pushRoute("/home/$sessionId");
                        }
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


