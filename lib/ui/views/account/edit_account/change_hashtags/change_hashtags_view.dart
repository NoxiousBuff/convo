import 'package:hint/api/hive.dart';
import 'package:hint/constants/app_strings.dart';
import 'package:hint/ui/shared/ui_helpers.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:stacked/stacked.dart';
import 'package:flutter/material.dart';
import 'change_hashtags_viewmodel.dart';
import 'package:hint/ui/views/auth/auth_widgets.dart';
import 'package:hint/ui/views/account/edit_account/widgets/widgets.dart';

class ChangeHashtagsView extends StatelessWidget {
  const ChangeHashtagsView({Key? key}) : super(key: key);

  static const String id = '/ChangeHashtagsVie';

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ChangeHashtagsViewModel>.reactive(
      viewModelBuilder: () => ChangeHashtagsViewModel(),
      builder: (context, model, child) => Scaffold(
        backgroundColor: Colors.white,
        extendBodyBehindAppBar: true,
        appBar: cwAuthAppBar(
          context,
          title: 'Change Interests',
          onPressed: () => Navigator.pop(context),
          // actions: [
          //   model.isBusy
          //       ? const Center(
          //           child: SizedBox(
          //             height: 15,
          //             width: 15,
          //             child: CircularProgressIndicator(
          //               valueColor: AlwaysStoppedAnimation(
          //                 AppColors.blue,
          //               ),
          //               strokeWidth: 2,
          //             ),
          //           ),
          //         )
          //       : InkWell(
          //           child: const Icon(
          //             FeatherIcons.check,
          //             color: AppColors.blue,
          //           ),
          //           onTap: () {
          //           },
          //         ),
          //   horizontalSpaceMedium,
          // ],
        ),
        body: ValueListenableBuilder<Box>(
          valueListenable: hiveApi.hiveStream(HiveApi.userdataHiveBox),
          builder: (context, box, child) {
            List<dynamic> hashList = box.get(FireUserField.hashTags);
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: ListView(
                children: [
                  cwEADetailsTile(context, 'Your HashTags'),
                  Wrap(
                    children: hashList
                        .map((e) => Text(e.toString(),
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                              color: Colors.black54,
                            )))
                        .toList(),
                  ),
                  verticalSpaceRegular,
                  const Divider(),
                  verticalSpaceRegular,
                  cwEADescriptionTitle(context, 'First Hashtag'),
                  verticalSpaceSmall,
                  cwEATextField(context, model.firstTech, '#funny',
                      maxLength: 30),
                  cwEADescriptionTitle(context, 'Second Hashtag'),
                  verticalSpaceSmall,
                  cwEATextField(context, model.secondTech, '#creative',
                      maxLength: 30),
                  cwEADescriptionTitle(context, 'Third Hashtag'),
                  verticalSpaceSmall,
                  cwEATextField(context, model.thirdTech, '#caring',
                      maxLength: 30),
                  verticalSpaceMedium,
                  cwAuthProceedButton(context, buttonTitle: 'Save'),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
