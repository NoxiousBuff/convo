import 'package:cached_network_image/cached_network_image.dart';
import 'package:stacked/stacked.dart';
import 'package:flutter/material.dart';
import 'package:hint/constants/app_strings.dart';

import 'send_letters_viewmodel.dart';

class SendLettersView extends StatelessWidget {
  const SendLettersView({Key? key}) : super(key: key);

  static const String id = '/SendLettersView';

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<SendLettersViewModel>.reactive(
      viewModelBuilder: () => SendLettersViewModel(),
      builder: (context, model, child) => Scaffold(
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
                      itemCount: docs.length,
                      itemBuilder: (context, i) {
                        final doc = docs[i];
                        return ListTile(
                          title: Text(doc[LetterFields.username],
                              style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700)),
                          subtitle: Text(doc[LetterFields.letterText], maxLines: 1, overflow: TextOverflow.ellipsis),
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: CachedNetworkImage(
                              imageUrl: doc[LetterFields.photoUrl],
                              height: 56,
                              width: 56,
                              fit: BoxFit.cover,
                            ),
                          ),
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