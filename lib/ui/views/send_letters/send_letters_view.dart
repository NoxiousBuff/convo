import 'package:animations/animations.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:hint/extensions/custom_color_scheme.dart';
import 'package:hint/models/letter_model.dart';
import 'package:hint/ui/shared/empty_state.dart';
import 'package:hint/ui/shared/ui_helpers.dart';
import 'package:hint/ui/views/read_letter/read_letter_view.dart';
import 'package:stacked/stacked.dart';
import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;

import 'send_letters_viewmodel.dart';

class SendLettersView extends StatelessWidget {
  const SendLettersView({Key? key}) : super(key: key);

  static const String id = '/SendLettersView';

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<SendLettersViewModel>.reactive(
      viewModelBuilder: () => SendLettersViewModel(),
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
              return const CircularProgressIndicator.adaptive(strokeWidth: 2,);
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
                                openColor: Theme.of(context).colorScheme.scaffoldColor,
                                closedColor: Theme.of(context).colorScheme.scaffoldColor,
                                closedElevation: 0,
                                closedBuilder: (context, onPressed) {
                                  return ListTile(
                                    trailing: Text(
                                      timestamp,
                                      style: TextStyle(
                                          color: Theme.of(context).colorScheme.mediumBlack),
                                    ),
                                    title: Text(letterText,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            color: Theme.of(context).colorScheme.black,
                                            fontSize: 18,
                                            fontWeight: FontWeight.w500)),
                                    subtitle: Text(
                                      letter.username,
                                      style: TextStyle(
                                          color: Theme.of(context).colorScheme.mediumBlack),
                                    ),
                                    leading: ClipRRect(
                                      borderRadius: BorderRadius.circular(14.2),
                                      child: CachedNetworkImage(
                                        imageUrl: letter.photoUrl,
                                        height: 40,
                                        width: 40,
                                        fit: BoxFit.cover,
                                      ),
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
                        SliverToBoxAdapter(child: bottomPadding(context),),
                      ],
                    ) : emptyState(context, emoji: '🙄', heading: 'No letters, hmm\nReally ??', description: 'You haven\'t sent ant letters. \nWe think you need to socialize more.');
            } else {
              return const Text(
                  'Something bad happened on our side. We will be in connect with you after sometime. Thank you for your patience.');
            }
          },
        ),
      ),
    );
  }
}
