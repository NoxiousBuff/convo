import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:hint/extensions/custom_color_scheme.dart';
import 'package:hint/services/nav_service.dart';
import 'package:hint/ui/shared/ui_helpers.dart';
import 'package:hint/ui/views/auth/auth_widgets.dart';
import 'package:hint/ui/views/account/edit_account/widgets/widgets.dart';
import 'package:hint/ui/views/search_to_write_letter/search_to_write_letter_view.dart';

class LetterInfoView extends StatelessWidget {
  const LetterInfoView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: 'writingLetterHeroTag',
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.scaffoldColor,
        appBar: cwAuthAppBar(context,
            title: '', onPressed: () => Navigator.pop(context)),
        body: Column(
          children: [
            Expanded(
              child: ListView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.only(left: 20, right: 20, bottom: 50),
                children: [
                  Row(
                    children: [
                      Icon(
                        FeatherIcons.send,
                        size: 60,
                        color: Theme.of(context).colorScheme.black,
                      ),
                    ],
                  ),
                  verticalSpaceMedium,
                  const CWEAHeading('What are these\nletters ??'),
                  cwEADescriptionTitle(context,
                      'Letters lets you communicate with your loved ones and many more friends in a non urgent way. \n\nLetters don\'t have a read receipt so people can answer at their own pace.'),
                  verticalSpaceLarge,
                  Row(
                    children: [
                      Icon(
                        FeatherIcons.share,
                        size: 60,
                        color: Theme.of(context).colorScheme.black,
                      ),
                    ],
                  ),
                  verticalSpaceMedium,
                  const CWEAHeading('Why should you\nuse letters ??'),
                  verticalSpaceRegular,
                  Row(
                    children: [
                      Icon(
                        FeatherIcons.chevronsRight,
                        color: Theme.of(context).colorScheme.black,
                      ),
                      horizontalSpaceSmall,
                      Expanded(
                          child: cwEADetailsTile(
                              context, 'Let\'s you get off your mind.',
                              showTrailingIcon: false,
                              subtitle:
                                  'Imagine if someone isn\'t there to talk, you can leave a letter for them to read and you can just let your mind be free of that message.')),
                    ],
                  ),
                  Row(
                    children: [
                      Icon(
                        FeatherIcons.chevronsRight,
                        color: Theme.of(context).colorScheme.black,
                      ),
                      horizontalSpaceSmall,
                      Expanded(
                          child: cwEADetailsTile(context, 'Puts you first',
                              showTrailingIcon: false,
                              subtitle:
                                  'No read receipts. So send letters whenever you want.')),
                    ],
                  ),
                  Row(
                    children: [
                      Icon(
                        FeatherIcons.chevronsRight,
                        color: Theme.of(context).colorScheme.black,
                      ),
                      horizontalSpaceSmall,
                      Expanded(
                          child: cwEADetailsTile(context, 'Great Icebreaker',
                              showTrailingIcon: false,
                              subtitle:
                                  'Making friends is not hard. Send people letter when they are not online.')),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: CWAuthProceedButton( buttonTitle: 'Write a letter',
                  onTap: () {
                Navigator.pop(context);
                navService.materialPageRoute(
                    context, const SearchToWriteLetterView());
              }),
            ),
            verticalSpaceLarge,
            bottomPadding(context),
          ],
        ),
      ),
    );
  }
}
