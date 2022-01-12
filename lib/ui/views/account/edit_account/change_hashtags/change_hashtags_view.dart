import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:hint/api/hive.dart';
import 'package:hint/constants/app_strings.dart';
import 'package:hint/extensions/custom_color_scheme.dart';
import 'package:hint/ui/shared/custom_snackbars.dart';
import 'package:hint/ui/shared/ui_helpers.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:stacked/stacked.dart';
import 'package:flutter/material.dart';
import 'change_hashtags_viewmodel.dart';
import 'package:hint/ui/views/auth/auth_widgets.dart';
import 'package:hint/ui/views/account/edit_account/widgets/widgets.dart';

class ChangeHashtagsView extends StatelessWidget {
  const ChangeHashtagsView({Key? key}) : super(key: key);

  static const String id = '/ChangeHashtagsView';

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ChangeHashtagsViewModel>.reactive(
      viewModelBuilder: () => ChangeHashtagsViewModel(),
      builder: (context, model, child) => Scaffold(
        backgroundColor: Theme.of(context).colorScheme.scaffoldColor,
        extendBodyBehindAppBar: true,
        appBar: cwAuthAppBar(
          context,
          title: '',
          onPressed: () => Navigator.pop(context),
        ),
        body: ValueListenableBuilder<Box>(
          valueListenable: hiveApi.hiveStream(HiveApi.userDataHiveBox),
          builder: (context, box, child) {
            List<dynamic> hashList = box.get(
              FireUserField.hashTags,
              defaultValue: ['#friendly', '#new', '#available'],
            );
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: ListView(
                physics: const BouncingScrollPhysics(),
                children: [
                  cwEADetailsTile(context, 'Your HashTags'),
                  Text('Add upto 3 hashtags to describe yourself.',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        color: Theme.of(context).colorScheme.mediumBlack,
                      )),
                  verticalSpaceRegular,
                  ListView.builder(
                      shrinkWrap: true,
                      itemCount: hashList.length,
                      itemBuilder: (context, i) {
                        return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(hashList[i],
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .mediumBlack,
                                  )),
                              IconButton(
                                  onPressed: () {
                                    model.removeFromList(hashList[i]);
                                    model.updateUserProperty(
                                        context,
                                        FireUserField.hashTags,
                                        model.updatedList);
                                    model.updateIsEdited(false);
                                  },
                                  icon: const Icon(FeatherIcons.x)),
                            ]);
                      }),
                  verticalSpaceRegular,
                  const Divider(),
                  verticalSpaceRegular,
                  cwEADescriptionTitle(context, 'Add a Hashtag'),
                  verticalSpaceSmall,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(top: 8),
                        child: Text(
                          '#',
                          style: TextStyle(
                              fontSize: 28, fontWeight: FontWeight.w700),
                        ),
                      ),
                      Expanded(
                        child: cwEATextField(
                            context, model.hashTagTech, 'funny', maxLength: 30,
                            onChanged: (value) {
                          model.updateIsEdited(true);
                          model.updateHashTagEmpty();
                        }),
                      ),
                    ],
                  ),
                  verticalSpaceMedium,
                  CWAuthProceedButton(
                      buttonTitle: 'Add',
                      isActive: model.isActive,
                      isLoading: model.isBusy,
                      onTap: () {
                        if (hashList.length < 3) {
                          model.addToList('#${model.hashTagTech.text}');
                          model.updateUserProperty(context,
                              FireUserField.hashTags, model.updatedList);
                        } else {
                          customSnackbars.infoSnackbar(context,
                              title: 'You can only add uptp 3 hashtags.');
                        }
                      }),
                  verticalSpaceLarge,
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
