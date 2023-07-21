import 'package:flutter/material.dart';
import 'package:scrum_poker/rest/firebase_db.dart';
import 'package:scrum_poker/theme/theme.dart';
import 'package:scrum_poker/pages/navigation/navigation_router.dart';
import 'package:scrum_poker/widgets/ui/typograpy_widgets.dart';

Widget startNewSession(BuildContext context, AppRouterDelegate routerDelegate) {
  TextEditingController newSessionController = TextEditingController();
  TextEditingController participantNameController = TextEditingController();
  return Container(
    child: Card(
      child: Padding(
        padding: EdgeInsets.all(dimensions.standard_padding * 2),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            heading5(context: context, text: "Start a new Session"),
            SizedBox(
              height: 10,
            ),
            body1(
                context: context,
                text: "Provide a name for the session and press Start"),
            SizedBox(
              height: 20,
            ),
            TextField(
              controller: newSessionController,
              decoration:
                  InputDecoration(hintText: "Enter the name of the session"),
            ),
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
                      // print(RouteDirectory.homePage(sessionId: 2));
                      // Navigator.pushNamed(context,
                      //     RouteDirectory.homePage(sessionId: 20));
                      // print("pressed");
                      // print(this.onTap);
                      // this.onTap("1");
                      ScrumPokerFirebase sfpb =
                          await ScrumPokerFirebase.instance;
                      var sessionId = await sfpb.startNewScrumSession(
                          newSessionController.text,
                          participantNameController.text);
                      routerDelegate.pushRoute("/home/$sessionId");
                    },
                    child: Text("START")))
          ],
        ),
      ),
    ),
    width: 500,
  );
}
