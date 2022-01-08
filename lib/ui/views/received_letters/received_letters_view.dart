import 'package:animations/animations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hint/extensions/custom_color_scheme.dart';
import 'package:hint/models/letter_model.dart';
import 'package:hint/ui/shared/empty_state.dart';
import 'package:hint/ui/shared/ui_helpers.dart';
import 'package:hint/ui/shared/user_profile_photo.dart';
import 'package:hint/ui/views/read_letter/read_letter_view.dart';
import 'package:stacked/stacked.dart';
import 'package:timeago/timeago.dart' as timeago;

import 'received_letters_viewmodel.dart';

class ReceivedLettersView extends StatelessWidget {
  const ReceivedLettersView({Key? key}) : super(key: key);

  static const String id = '/ReceivedLettersView';

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ReceivedLettersViewModel>.reactive(
      viewModelBuilder: () => ReceivedLettersViewModel(),
      builder: (context, model, child) => Scaffold(
        backgroundColor: Theme.of(context).colorScheme.scaffoldColor,
        body: Builder(
          builder: (context) {
            if (model.hasError) {
              model.log.e(model.error());
              return const Text(
                  'Something bad happened. Please Try again later.');
            }
            if (!model.dataReady) {
              return const Center(
                  child: CircularProgressIndicator.adaptive(
                strokeWidth: 2,
              ));
            }
            final data = model.data;
            if (data != null) {
              final docs = data.docs;
              return docs.isNotEmpty
                  ? CustomScrollView(
                      scrollBehavior: const CupertinoScrollBehavior(),
                      slivers: [
                        SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (context, i) {
                              final doc = docs[i];
                              final letter = LetterModel.fromFireStore(doc);
                              final letterText =
                                  letter.letterText.replaceAll('\n', ' ');
                              final timestamp = timeago.format(
                                  letter.timestamp.toDate(),
                                  locale: 'en');
                              return OpenContainer(
                                openColor:
                                    Theme.of(context).colorScheme.scaffoldColor,
                                closedColor:
                                    Theme.of(context).colorScheme.scaffoldColor,
                                closedElevation: 0,
                                closedBuilder: (context, onPressed) {
                                  return ListTile(
                                    trailing: Text(
                                      timestamp,
                                      style: TextStyle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .mediumBlack),
                                    ),
                                    title: Text(letterText,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .black,
                                            fontSize: 18,
                                            fontWeight: FontWeight.w500)),
                                    subtitle: Text(
                                      letter.username,
                                      style: TextStyle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .mediumBlack),
                                    ),
                                    leading: userProfilePhoto(
                                      context,
                                      letter.photoUrl,
                                      width: 40,
                                      height: 40,
                                      borderRadius: BorderRadius.circular(14.2),
                                    ),
                                  );
                                },
                                transitionType: ContainerTransitionType.fade,
                                openBuilder: (context, onPressed) {
                                  return ReadLetterView(letter: letter);
                                },
                              );
                            },
                            childCount: docs.length,
                          ),
                        ),
                        sliverVerticalSpaceLarge,
                        SliverToBoxAdapter(
                          child: bottomPadding(context),
                        ),
                      ],
                    )
                  : emptyState(context,
                      heading: 'A little bit \ntoo clean.',
                      description: 'Ask your friends to drop\nletters for you to read later.');
            } else {
              return emptyState(context, emoji: '🙏', heading: 'That\'s not supposed\nto happen.', description: 'Something bad happened on our side.\nWe will be in connect with you after sometime.\nThank you for your patience.');
            }
          },
        ),
      ),
    );
  }
}
