import 'package:flutter/cupertino.dart';
import 'package:hint/ui/shared/ui_helpers.dart';
import 'package:hint/ui/views/account/edit_account/widgets/widgets.dart';
import 'package:hint/ui/views/auth/auth_widgets.dart';

Widget emptyState(
  BuildContext context, {
  String emoji = '😅',
  String heading = 'Provide a heading here',
  String? description,
  double upperGap = 0.0,
  double lowerGap = 0.0,
  CWAuthProceedButton? proceedButton,
  EdgeInsets? proceedButtonPadding,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.center,
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      SizedBox(height: upperGap),
      Text(emoji, style: const TextStyle(fontSize: 80)),
      verticalSpaceRegular,
      CWEAHeading(heading,
          mainAxisAlignment: MainAxisAlignment.center,
          textAlign: TextAlign.center),
      verticalSpaceRegular,
      if (proceedButton != null) Padding(
        padding: proceedButtonPadding ?? const EdgeInsets.symmetric(horizontal: 20),
        child: proceedButton,
      ),
      verticalSpaceLarge,
      description != null
          ? cwEADescriptionTitle(
              context,
              description,
              textAlign: TextAlign.center,
            )
          : shrinkBox,
      
      SizedBox(height: lowerGap),
    ],
  );
}
