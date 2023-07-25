import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share/share.dart';

import 'package:scrum_poker/model/scrum_session_model.dart';
import 'package:scrum_poker/model/scrum_session_participant_model.dart';
import 'package:scrum_poker/model/story_model.dart';
import 'package:scrum_poker/rest/firebase_db.dart';
import 'package:scrum_poker/widgets/ui/extensions/text_extensions.dart';
import 'package:scrum_poker/widgets/ui/extensions/widget_extensions.dart';
import 'package:scrum_poker/widgets/ui/typograpy_widgets.dart';

import '../../../widgets/ui/style.dart';

Widget buildDisplayStoryPanel(
    BuildContext context,
    Story? story,
    dynamic newStoryPressed,
    dynamic showCardsPressed,
    ScrumSessionParticipant? participant,
    ScrumSession? session) {
  return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Row(children: [
          getHeader(context, story, newStoryPressed, showCardsPressed,
              participant, session)
        ]),
        getStoryBoard(context, story) ?? Text('')
      ]);
}

RoundedRectangleBorder roundedBorder({required double borderRadius}) {
  return RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(borderRadius));
}

Widget getHeader(
  BuildContext context,
  Story? story,
  dynamic newStoryPressed,
  dynamic showCardsPressed,
  ScrumSessionParticipant? participant,
  ScrumSession? session,
) {
  return Expanded(
    child: Container(
      color: Theme.of(context).primaryColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // Share button
              TextButton(
                child: Tooltip(
                  message: "SHARE LINK AND ENJOY THE POKER",
                  child: Wrap(
                    runSpacing: 10,
                    spacing: 10.0,
                    children: [
                      Icon(
                        Icons.share,
                        color: Colors.blue[100],
                      ),
                    ],
                    alignment: WrapAlignment.start,
                  ),
                ),
                onPressed: () {
                  shareUrl(context, session);
                  copyUrlToClipboard(context, session);
                },
              ),
              SizedBox(height: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    heading4(context: context, text: session?.name ?? '')
                        .color(Theme.of(context).scaffoldBackgroundColor),
                  ],
                ),
              ),
            ],
          ).margin(left: 20, bottom: 12),
          if ((participant?.isOwner ?? false) &&
              (getDeviceWidth(context) < 600))
            Row(
              children: [
                Wrap(
                  runSpacing: 10.0,
                  spacing: 10.0,
                  children: [
                    TextButton(
                      child: Tooltip(
                        message: "ADD NEW STORY",
                        child: Wrap(
                          runSpacing: 8,
                          spacing: 8.0,
                          children: [
                            Icon(
                              Icons.add,
                              color: Colors.blue[100],
                              size: 30,
                            )
                          ],
                        ),
                      ),
                      onPressed: newStoryPressed,
                    ),
                    TextButton(
                      child: Tooltip(
                        message: "SHOW CARD",
                        child: Wrap(
                          runSpacing: 8,
                          spacing: 8.0,
                          children: [
                            Icon(
                              Icons.preview,
                              color: Colors.blue[100],
                              size: 30,
                            )
                          ],
                        ),
                      ),
                      onPressed: showCardsPressed,
                    ),
                    TextButton(
                      child: Tooltip(
                        message: "REPLAY",
                        child: Wrap(
                          runSpacing: 8,
                          spacing: 8.0,
                          children: [
                            Icon(
                              Icons.replay,
                              color: Colors.blue[100],
                              size: 30,
                            )
                          ],
                        ),
                      ),
                      onPressed: () async {
                        ScrumPokerFirebase spdb =
                            await ScrumPokerFirebase.instance;
                        spdb.setActiveStory(
                          story?.id,
                          story?.title,
                          story?.description,
                        );
                      },
                    ),
                  ],
                ),
              ],
            ).margin(left: 20, bottom: 24),
          if ((participant?.isOwner ?? false) &&
              (getDeviceWidth(context) > 600))
            Row(
              children: [
                Wrap(
                  runSpacing: 10.0,
                  spacing: 10.0,
                  children: [
                    pillButton(
                      context: context,
                      text: "NEW STORY",
                      onPress: newStoryPressed,
                    ),
                    pillButton(
                      onPress: showCardsPressed,
                      context: context,
                      text: "SHOW CARDS",
                    ),
                    pillButton(
                      onPress: () async {
                        ScrumPokerFirebase spdb =
                            await ScrumPokerFirebase.instance;
                        spdb.setActiveStory(
                          story?.id,
                          story?.title,
                          story?.description,
                        );
                      },
                      context: context,
                      text: "REPLAY",
                    ),
                  ],
                ),
              ],
            ).margin(left: 96, bottom: 24),
        ],
      ),
    ),
  );
}

Widget? getStoryBoard(BuildContext context, Story? story) {
  if ((story?.id?.length ?? 0) > 0 ||
      (story?.title?.length ?? 0) > 0 ||
      (story?.description?.length ?? 0) > 0) {
    return Card(
        elevation: 2.0,
        shape: roundedBorder(borderRadius: 5.0),
        child: Container(
            width: 800,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5.0),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                caption(context: context, text: story?.id ?? ''),
                subtitle2(context: context, text: story?.title ?? '')
                    .margin(top: 4.0),
                body2(context: context, text: story?.description ?? '')
                    .margin(top: 4.0),
              ],
            )).paddingAll(16.0));
  }
  return null;
}

String getJoinUrl(ScrumSession? session) {
  if (session == null) {
    return '';
  } else {
    return "${Uri.base.scheme}://${Uri.base.host}${Uri.base.port != 80 && Uri.base.port != 443 ? ':${Uri.base.port}' : ''}/#/join/${session.id}";
  }
}

void copyUrlToClipboard(BuildContext context, ScrumSession? session) {
  Clipboard.setData(new ClipboardData(text: getJoinUrl(session))).then((_) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('Link to your clipboard !')));
  });
}

Widget pillButton(
    {required BuildContext context,
    required String text,
    required dynamic onPress}) {
  return TextButton(
      onPressed: () {
        onPress();
      },
      child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(16.0)),
            color: Theme.of(context).backgroundColor,
          ),
          child: buttonText(
                  context: context,
                  text: text,
                  color: Theme.of(context).primaryColor)
              .paddingLRTB(left: 16, right: 16, top: 4, bottom: 4)));
}

void shareUrl(BuildContext context, ScrumSession? session) {
  if (session == null) {
    return;
  }

  String url = getJoinUrl(session);

  Share.share(url);
}
