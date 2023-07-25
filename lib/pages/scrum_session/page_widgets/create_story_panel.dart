import 'package:flutter/material.dart';
import 'package:scrum_poker/rest/firebase_db.dart';

import 'package:scrum_poker/widgets/ui/typograpy_widgets.dart';
import 'package:scrum_poker/widgets/ui/extensions/widget_extensions.dart';

import 'display_story_panel.dart';



Widget buildCreateStoryPanel(BuildContext context) {
  TextEditingController storyId = TextEditingController();
  TextEditingController storyTitle = TextEditingController();
  TextEditingController storyDescription = TextEditingController();

  return Card(
      elevation: 2.0,
      shape: roundedBorder(borderRadius: 5.0),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(
            width: 800,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                color: Colors.grey[100]),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  heading5(context: context, text: "New story")
                      .margin(bottom: 16),
                  textField(label: "Story ID", controller: storyId),
                  textField(label: "Story title", controller: storyTitle),
                  textField(
                      label: "Story Description", controller: storyDescription),
                  _createStoryButtonsPanel(
                      context, storyId, storyTitle, storyDescription)
                ]).paddingAll(32))
      ]));
}

Widget _createStoryButtonsPanel(
    BuildContext context, storyId, storyTitle, storyDescription) {
  return Wrap(runSpacing: 10.0, children: [
    ElevatedButton(
            onPressed: () async {
              ScrumPokerFirebase spdb = await ScrumPokerFirebase.instance;
              spdb.setActiveStory(
                  storyId.text, storyTitle.text, storyDescription.text);
            },
            child:
                Wrap(crossAxisAlignment: WrapCrossAlignment.center, children: [
              Icon(Icons.play_arrow).margin(right: 4),
              buttonText(context: context, text: "PLAY", color: Colors.white)
            ]).paddingAll(16.0))
        .margin(right: 24.0),
  ]).margin(top: 24);
}

Widget textField(
    {required String label, required TextEditingController controller}) {
  return TextField(
    controller: controller,
    decoration: InputDecoration(hintText: label),
    style: TextStyles.body1,
  ).margin(bottom: 8.0);
}
