

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../widgets/ui/typograpy_widgets.dart';


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
                    heading6(
                        context: context,
                        text: "Scrum Poker",
                        color: Colors.white),
                
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
