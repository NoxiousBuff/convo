import 'package:flutter/material.dart';
import 'package:hint/app/locator.dart';
import 'package:hint/ui/shared/ui_helpers.dart';
import 'package:hint/api/replymessage_value.dart';
import 'package:hint/extensions/custom_color_scheme.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';

class ReplyMessageTile extends StatelessWidget {
  final bool sendedByMe;
  final String fireUserName;
  const ReplyMessageTile(
      {Key? key, required this.fireUserName, required this.sendedByMe})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: locator.get<GetReplyMessageValue>().isReply,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
        width: screenWidth(context),
        color: Theme.of(context).colorScheme.black.withOpacity(0.5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            /// isReply will false after pressing this
            InkWell(
              onTap: () {
                locator.get<GetReplyMessageValue>().isReplyValChanger(false);
                locator.get<GetReplyMessageValue>().clearReplyMsg();
              },
              child: CircleAvatar(
                backgroundColor: Theme.of(context).colorScheme.white,
                maxRadius: 10,
                child: const Center(child: Icon(FeatherIcons.x, size: 12)),
              ),
            ),
            horizontalSpaceRegular,
            Text('Replying to ${sendedByMe ? 'yourself' : fireUserName}'),
          ],
        ),
      ),
    );
  }
}
