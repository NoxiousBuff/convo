import 'privacy_viewmodel.dart';
import 'package:hive/hive.dart';
import 'package:hint/api/hive.dart';
import 'package:stacked/stacked.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:hint/app/app_logger.dart';
import 'package:hint/app/app_colors.dart';
import 'package:hint/constants/app_keys.dart';
import 'package:hint/ui/shared/ui_helpers.dart';

class PrivacyView extends StatelessWidget {
  const PrivacyView({Key? key}) : super(key: key);

  Widget heading({required BuildContext context, required String title}) {
    return ListTile(
      title: Text(
        title,
        style: Theme.of(context).textTheme.bodyText1,
      ),
    );
  }

  Future<void> dialog({
    required String title,
    required Widget optionsList,
    required BuildContext context,
  }) {
    return showDialog(
      context: context,
      builder: (context) {
        final maxHeight = screenHeightPercentage(context, percentage: 0.3);
        final maxWidth = screenWidthPercentage(context, percentage: 0.6);
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          child: Container(
            constraints: BoxConstraints(
              maxHeight: maxHeight,
              maxWidth: maxWidth,
            ),
            child: Column(
              children: [
                Container(
                  alignment: Alignment.bottomLeft,
                  margin:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  child: Text(
                    title,
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                ),
                optionsList
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> lastSeenDialog(PrivacyViewModel model, BuildContext context) {
    return dialog(
      context: context,
      title: 'Last Seen',
      optionsList: ListView.builder(
        shrinkWrap: true,
        itemCount: model.dialogptions.length,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () => Navigator.pop(context),
            child: RadioListTile(
              value: index,
              activeColor: AppColors.blue,
              groupValue: model.lastSeenValue,
              title: Text(
                model.dialogptions[index],
                style: Theme.of(context).textTheme.bodyText2,
              ),
              onChanged: (int? i) {
                model.currentIndex(i);
                getLogger('PrivacyView')
                    .wtf("LastSeenValue:${model.lastSeenValue}");
                Navigator.pop(context);
              },
            ),
          );
        },
      ),
    );
  }

  Future<void> profilePhotoDialog(
      PrivacyViewModel model, BuildContext context) {
    return dialog(
      context: context,
      title: 'Profile Photo',
      optionsList: ListView.builder(
        shrinkWrap: true,
        itemCount: model.dialogptions.length,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () => Navigator.pop(context),
            child: RadioListTile(
              value: index,
              activeColor: AppColors.blue,
              groupValue: model.profileValue,
              title: Text(
                model.dialogptions[index],
                style: Theme.of(context).textTheme.bodyText2,
              ),
              onChanged: (int? i) {
                model.photoValueIndex(i);
                getLogger('PrivacyView')
                    .wtf("ProfilePhotValue:${model.profileValue}");
                Navigator.pop(context);
              },
            ),
          );
        },
      ),
    );
  }

  Future<void> aboutDialog(PrivacyViewModel model, BuildContext context) {
    return dialog(
      context: context,
      title: 'About',
      optionsList: ListView.builder(
        shrinkWrap: true,
        itemCount: model.dialogptions.length,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () => Navigator.pop(context),
            child: RadioListTile(
              value: index,
              activeColor: AppColors.blue,
              groupValue: model.aboutValue,
              title: Text(
                model.dialogptions[index],
                style: Theme.of(context).textTheme.bodyText2,
              ),
              onChanged: (int? i) {
                model.aboutValueIndex(i);
                getLogger('PrivacyView').wtf("AboutValue:${model.aboutValue}");
                Navigator.pop(context);
              },
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<PrivacyViewModel>.reactive(
      viewModelBuilder: () => PrivacyViewModel(),
      builder: (context, viewModel, child) {
        return Scaffold(
          appBar: CupertinoNavigationBar(
            backgroundColor: Colors.transparent,
            automaticallyImplyLeading: true,
            leading: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Icon(
                    Icons.arrow_back_ios_new,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  'PrivacyView',
                  style: Theme.of(context).textTheme.headline6,
                ),
              ],
            ),
          ),
          body: SizedBox(
            width: screenWidth(context),
            height: screenHeight(context),
            child: Column(
              children: [
                Container(
                  color: AppColors.white,
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 16, top: 16),
                          child: Text(
                            'Who can see my personal info',
                            style: Theme.of(context)
                                .textTheme
                                .bodyText1!
                                .copyWith(color: Colors.black54),
                          ),
                        ),
                      ),
                      ListTile(
                        subtitle: Text(
                          'If you dpn\'t share your username, Online status, you won\'t be able to see others people details.',
                          style: Theme.of(context).textTheme.caption,
                        ),
                      ),
                      widget(
                        context: context,
                        text: 'Online Status',
                        subtitle: viewModel.lastSeenSubtitle,
                        onTap: () => lastSeenDialog(viewModel, context),
                      ),
                      widget(
                        context: context,
                        text: 'Profile photo',
                        subtitle: viewModel.profileSubtitle,
                        onTap: () => profilePhotoDialog(viewModel, context),
                      ),
                      widget(
                        context: context,
                        text: 'Bio',
                        subtitle: viewModel.aboutSubtitle,
                        onTap: () => aboutDialog(viewModel, context),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  color: AppColors.white,
                  child: ListTile(
                    isThreeLine: true,
                    title: const Text('Incognated Mode'),
                    trailing: ValueListenableBuilder<Box>(
                      valueListenable:
                          hiveApi.hiveStream(HiveApi.appSettingsBoxName),
                      builder: (context, box, child) {
                        const boxName = HiveApi.appSettingsBoxName;
                        const key = AppSettingKeys.incognatedMode;
                        bool incognatedMode =
                            Hive.box(boxName).get(key, defaultValue: false);
                        return CupertinoSwitch(
                          value: incognatedMode,
                          onChanged: (val) {
                            box.put(
                                AppSettingKeys.incognatedMode, !incognatedMode);
                          },
                        );
                      },
                    ),
                    subtitle: Text(
                      'If you on this setting no one can see your your online status and your username in live chat',
                      style: Theme.of(context).textTheme.caption,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget widget({
    required String text,
    required Function onTap,
    String? subtitle = '',
    required BuildContext context,
  }) {
    return Column(
      children: [
        InkWell(
          onTap: onTap as void Function()?,
          child: ListTile(
            title: Text(
              text,
              style: Theme.of(context).textTheme.bodyText2,
            ),
            subtitle: Text(subtitle!,
                style: Theme.of(context)
                    .textTheme
                    .caption!
                    .copyWith(color: AppColors.black)),
          ),
        ),
        const Divider(height: 0.0),
      ],
    );
  }
}