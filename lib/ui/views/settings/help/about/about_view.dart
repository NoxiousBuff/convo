import 'package:flutter/material.dart';
import 'package:hint/ui/shared/ui_helpers.dart';
import 'package:hint/ui/views/auth/auth_widgets.dart';
import 'package:hint/extensions/custom_color_scheme.dart';
import 'package:hint/ui/views/account/edit_account/widgets/widgets.dart';

class AboutAppView extends StatelessWidget {
  const AboutAppView({Key? key}) : super(key: key);

  static const firstPara =
      'Convo is a real-time live chat application. In Convo, users can chat in real-time.';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: cwAuthAppBar(context,
          title: 'About App', onPressed: () => Navigator.pop(context)),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverList(
            delegate: SliverChildListDelegate(
              [
                verticalSpaceRegular,
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: cwEADescriptionTitle(context, firstPara),
                ),
                verticalSpaceRegular,
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: cwAuthDescription(context,
                      title: 'Stop Waiting Around For Messages',
                      titleColor: Theme.of(context).colorScheme.black),
                ),
                verticalSpaceSmall,
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: cwEADescriptionTitle(context,
                      'In other chat applications, you need to press the send button to send a message. But in Convo, you don\'t need to tap the button because no send button is available. We skip this step for your comfort.'),
                ),
                verticalSpaceRegular,
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: cwAuthDescription(context,
                      title: 'No, Send Button',
                      titleColor: Theme.of(context).colorScheme.black),
                ),
                verticalSpaceSmall,
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: cwEADescriptionTitle(context,
                      'In other chat applications, you need to press the send button to send a message. But in Convo, you don\'t need to tap the button because no send button is available. We skip this step for your comfort.'),
                ),
                verticalSpaceRegular,
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: cwAuthDescription(context,
                      title: 'No, Chat History',
                      titleColor: Theme.of(context).colorScheme.black),
                ),
                verticalSpaceSmall,
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: cwEADescriptionTitle(context,
                      'In all chat applications, they save your messages, and as we all know. They will use your data for their profit directly or indirectly. But in Convo, we don\'t store messages. So nobody will read your messages for their profit.'),
                ),
                verticalSpaceRegular,
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: cwAuthDescription(context,
                      title: 'End-To-End Encrypted',
                      titleColor: Theme.of(context).colorScheme.black),
                ),
                verticalSpaceSmall,
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: cwEADescriptionTitle(context,
                      'We tell you, we don\'t save your messages. Nobody will read your messages, but what about those texts which you type on the keyboard. Don\'t worry real-time chat is encrypted means no one can read your live chat even we can\'t read your live chat.'),
                ),
                verticalSpaceRegular,
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: cwAuthDescription(context,
                      title: 'React in Real-Time',
                      titleColor: Theme.of(context).colorScheme.black),
                ),
                verticalSpaceSmall,
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: cwEADescriptionTitle(context,
                      'In Convo, you can read or send messages in real-time, but here is the magic, you can also react with your friends in real-time with some cool animations like confetti and balloons.'),
                ),
                verticalSpaceRegular,
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: cwAuthDescription(context,
                      title: 'Live Type',
                      titleColor: Theme.of(context).colorScheme.black),
                ),
                verticalSpaceSmall,
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: cwEADescriptionTitle(context,
                      'You can see the messages as live as what you type on the keyboard.'),
                ),
                verticalSpaceRegular,
              ],
            ),
          ),
        ],
      ),
    );
  }
}
