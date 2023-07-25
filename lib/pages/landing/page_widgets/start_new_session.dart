import 'package:flutter/material.dart';
import 'package:scrum_poker/rest/firebase_db.dart';
import 'package:scrum_poker/theme/theme.dart';
import 'package:scrum_poker/pages/navigation/navigation_router.dart';
import 'package:scrum_poker/widgets/ui/typograpy_widgets.dart';

Widget startNewSession(BuildContext context, AppRouterDelegate routerDelegate) {
  final _formKey = GlobalKey<FormState>();
  TextEditingController newSessionController = TextEditingController();
  TextEditingController participantNameController = TextEditingController();

  return Container(
    child: Card(
      child: Padding(
        padding: EdgeInsets.all(dimensions.standard_padding * 2),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              heading5(context: context, text: "Start a new Session"),
              SizedBox(height: 10),
              body1(
                context: context,
                text: "Provide a name for the session and press Start",
              ),
              // SizedBox(height: 20),
              TextFormField(
                controller: newSessionController,
                decoration:
                    InputDecoration(hintText: "Enter the name of the session"),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Session name is required';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: participantNameController,
                decoration:
                    InputDecoration(hintText: "Enter your name or nickname"),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Participant name is required';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              Center(
                child: TextButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      ScrumPokerFirebase sfpb =
                          await ScrumPokerFirebase.instance;
                      var sessionId = await sfpb.startNewScrumSession(
                        newSessionController.text,
                        participantNameController.text,
                      );
                      routerDelegate.pushRoute("/home/$sessionId");
                    }
                  },
                  child: Text("START"),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
    width: 500,
  );
}
