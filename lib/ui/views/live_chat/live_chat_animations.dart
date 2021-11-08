import 'package:flutter/material.dart';
import 'package:hint/app/app_colors.dart';
import 'package:hint/constants/message_string.dart';
import 'package:hint/ui/animations/confetti.dart';
import 'package:hint/ui/animations/spotlight.dart';

class LiveChatAnimations extends StatefulWidget {
  const LiveChatAnimations({Key? key}) : super(key: key);

  @override
  _LiveChatAnimationsState createState() => _LiveChatAnimationsState();
}

class _LiveChatAnimationsState extends State<LiveChatAnimations> {
  String animationValue = AnimationType.confetti;
  PageController controller = PageController();
  List<Widget> animationsList = [
    const Confetti(),
    const SpotLight(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: transparent,
        leading: TextButton(
          onPressed: () => Navigator.pop(context, animationValue),
          child: Text(
            'Send',
            style: Theme.of(context)
                .textTheme
                .bodyText2!
                .copyWith(color: activeBlue),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: Theme.of(context).textTheme.bodyText2,
            ),
          ),
        ],
      ),
      body: PageView.builder(
        controller: controller,
        onPageChanged: (int i) {
          if (i == 1) {
            setState(() {
              animationValue = AnimationType.confetti;
            });
          } else {
            setState(() {
              animationValue = AnimationType.spotlight;
            });
          }
        },
        scrollDirection: Axis.horizontal,
        itemCount: animationsList.length,
        itemBuilder: (context, index) {
          return animationsList[index];
        },
      ),
    );
  }
}
