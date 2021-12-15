import 'package:animations/animations.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:hint/models/letter_model.dart';
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
        backgroundColor: Colors.white,
        body: Builder(
          builder: (context) {
            if (model.hasError) {
              model.log.e(model.error());
              return const Text(
                  'Something bad happened. Please Try again later.');
            }
            if (!model.dataReady) {
              return const CircularProgressIndicator.adaptive();
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
                        final timestamp = timeago.format(letter.timestamp.toDate(), locale: 'en');
                        return OpenContainer(
                          closedElevation: 0,
                          closedBuilder: (context, onPressed) {
                            return ListTile(
                              trailing: Text(timestamp),
                              title: Text(letter.letterText,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                      color: Colors.black,
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
                          transitionType: ContainerTransitionType.fadeThrough,
                          openBuilder: (context, onPressed) {
                            return ReadLetterView(letter: letter);
                          },
                        );
                      })
                  : const Text('You have not send any letters');
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
