import 'package:flutter/cupertino.dart';
import 'package:hint/ui/shared/ui_helpers.dart';
import 'package:hint/ui/views/account/edit_account/widgets/widgets.dart';

Widget emptyState(BuildContext context, {String emoji = '😅', String heading = 'Provide a heading here', String? description}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.center,
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Text(emoji, style: const TextStyle(fontSize: 80)),
      verticalSpaceRegular,
      CWEAHeading(heading,
          mainAxisAlignment: MainAxisAlignment.center,
          textAlign: TextAlign.center),
      verticalSpaceRegular,
      description != null ? cwEADescriptionTitle(
        context,
        description,
        textAlign: TextAlign.center,
      ) : shrinkBox
    ],
  );
}
