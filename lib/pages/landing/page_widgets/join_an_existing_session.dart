import 'package:flutter/material.dart';
import 'package:scrum_poker/model/scrum_session_model.dart';
import 'package:scrum_poker/rest/firebase_db.dart';
import 'package:scrum_poker/theme/theme.dart';
import 'package:scrum_poker/pages/navigation/navigation_router.dart';
import 'package:scrum_poker/widgets/ui/typograpy_widgets.dart';

Widget joinAnExistingSession(
    {required BuildContext context,
    required AppRouterDelegate routerDelegate,
    bool joinWithLink: false,
    ScrumSession? scrumSession}) {
  TextEditingController existingSessionController = TextEditingController();
  TextEditingController participantNameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String? processedSessionId;

  return Container(
    child: Card(
      child: Padding(
        padding: EdgeInsets.all(dimensions.standard_padding * 2),
        child: Form(
          key: _formKey,
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
              TextFormField(
                controller: existingSessionController,
                decoration: InputDecoration(hintText: "Enter the session URL"),
                validator: (value) {
                  print("++++++++++++$value");
                  if (value!.isEmpty) {
                    return 'Session link is required';
                  }
                  // } else if (value.contains(scrumSession!.id!)) {
                  //   return 'Session does not exist is required';
                  // }

                  print(value.substring(value.lastIndexOf('/') + 1));
                  processedSessionId =
                      value.substring(value.lastIndexOf('/') + 1);

                  return null;
                },
              ),
            TextFormField(
              controller: participantNameController,
              decoration:
                  InputDecoration(hintText: "Enter your name or nickname"),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'name or nickname is required';
                }
                return null;
              },
            ),
            SizedBox(
              height: 20,
            ),
            Center(
                child: TextButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        var sessionId = processedSessionId;
                        if (joinWithLink) {
                          sessionId = scrumSession!.id!;
                        }
                        if (!joinWithLink) {
                          ScrumPokerFirebase spfb =
                              await ScrumPokerFirebase.instance;
                          await spfb.joinScrumSession(
                              participantName: participantNameController.text,
                              sessionId: sessionId!,
                              owner: false);
                          print("sessionID= ${sessionId}");

                          routerDelegate.pushRoute("/home/$sessionId");
                        }
                      }
                    },
                    child: Text("JOIN"))),
          ]),
        ),
      ),
    ),
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
