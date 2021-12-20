import 'package:animations/animations.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hint/app/app_colors.dart';
import 'package:hint/models/letter_model.dart';
import 'package:hint/ui/shared/empty_state.dart';
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
        backgroundColor: AppColors.scaffoldColor,
        body: Builder(
          builder: (context) {
            if (model.hasError) {
              model.log.e(model.error());
              return const Text(
                  'Something bad happened. Please Try again later.');
            }
            if (!model.dataReady) {
              return const Center(child: CircularProgressIndicator.adaptive(strokeWidth: 2,));
            }
            final data = model.data;
            if (data != null) {
              final docs = data.docs;
              return docs.isNotEmpty
                  ? ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      itemCount: docs.length,
                      itemBuilder: (context, i) {
                        final doc = docs[i];
                        final letter = LetterModel.fromFireStore(doc);
                        final letterText = letter.letterText.replaceAll('\n', ' ');
                        final timestamp = timeago
                            .format(letter.timestamp.toDate(), locale: 'en');
                        return OpenContainer(
                          closedElevation: 0,
                          closedBuilder: (context, onPressed) {
                            return ListTile(
                              trailing: Text(timestamp),
                              title: Text(letterText,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style:  TextStyle(
                                      color:AppColors.black,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500)),
                              subtitle: Text(letter.username),
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
                      }) : emptyState(context, heading: 'A little bit \ntoo clean.', description: 'Nobody remembers you, that\'s sad.');
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
