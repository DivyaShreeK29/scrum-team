// import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../widgets/ui/typograpy_widgets.dart';
//import 'package:scrum_poker/pages/scrum_session/scrum_session_page.dart';

class ExitPage extends StatelessWidget {
  const ExitPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      child: AnimatedContainer(
        duration: Duration(microseconds: 300),
        color: Theme.of(context).scaffoldBackgroundColor,
        child: Column(
          children: [
            AppBar(
              centerTitle: false,
              title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // AnimatedContainer(duration: Duration(milliseconds: standard_duration),
                    //        width:150,
                    //        child:Image.asset("assets/images/logo_white.png")),
                    heading6(
                        context: context,
                        text: "Scrum Poker",
                        color: Colors.white),
                    //Divider()
                  ]),
              elevation: 0.0,
              bottomOpacity: 0.0,
              backgroundColor: Theme.of(context).primaryColor,
            ),
            SizedBox(height: 200),
            AlertDialog(
              title: Text(
                "Session expired",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              content: Text("The host has ended the session"),
              actions: <Widget>[
                TextButton(
                  child: Text('OK'),
                  onPressed: () {
                    print("asdf");
                    SystemNavigator.pop();
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
