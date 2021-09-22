import 'package:flutter/material.dart';
import 'package:scrum_poker/widgets/ui/typograpy_widgets.dart';
import 'package:scrum_poker/widgets/ui/extensions/widget_extensions.dart';
import 'package:scrum_poker/model/scrum_session_model.dart';

Widget buildDisplayStoryPanel(BuildContext context, Story? story,
    dynamic newStoryPressed, dynamic showCardsPressed) {
  return Card(
    elevation: 2.0,
    shape: roundedBorder(borderRadius: 5.0),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25), color: Colors.grey[100]),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              body2(context: context, text: story?.id ?? ''),
              heading6(context: context, text: story?.title ?? '')
                  .margin(top: 4.0),
              body1(context: context, text: story?.description ?? '')
                  .margin(top: 16.0, bottom: 16.0),
            ],
          ).paddingAll(32)),
      Wrap(runSpacing: 10.0, children: [
        TextButton(
                onPressed: () {
                  newStoryPressed();
                },
                child: buttonText(
                    context: context, text: "NEW STORY", color: Colors.blue))
            .margin(right: 16.0),
        TextButton(
            onPressed: () {
              showCardsPressed();
            },
            child: buttonText(
                context: context, text: "SHOW CARDS", color: Colors.blue))
      ]).margin(top: 24)
    ]).paddingAll(24.0),
  );
}

RoundedRectangleBorder roundedBorder({required double borderRadius}) {
  return RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(borderRadius));
}