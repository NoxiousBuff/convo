import 'package:hint/app/app_colors.dart';
import 'package:hint/app/app_logger.dart';
import 'package:hint/ui/shared/ui_helpers.dart';
import 'package:stacked/stacked.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'privacy_viewmodel.dart';

class Privacy extends StatelessWidget {
  const Privacy({Key? key}) : super(key: key);

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
              activeColor: activeBlue,
              groupValue: model.lastSeenValue,
              title: Text(
                model.dialogptions[index],
                style: Theme.of(context).textTheme.bodyText2,
              ),
              onChanged: (int? i) {
                model.currentIndex(i);
                getLogger('Privacy')
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
              activeColor: activeBlue,
              groupValue: model.profileValue,
              title: Text(
                model.dialogptions[index],
                style: Theme.of(context).textTheme.bodyText2,
              ),
              onChanged: (int? i) {
                model.photoValueIndex(i);
                getLogger('Privacy')
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
              activeColor: activeBlue,
              groupValue: model.aboutValue,
              title: Text(
                model.dialogptions[index],
                style: Theme.of(context).textTheme.bodyText2,
              ),
              onChanged: (int? i) {
                model.aboutValueIndex(i);
                getLogger('Privacy').wtf("AboutValue:${model.aboutValue}");
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
          backgroundColor: extraLightBackgroundGray,
          body: SizedBox(
            width: screenWidth(context),
            height: screenHeight(context),
            child: Column(
              children: [
                SizedBox(
                  height: screenHeightPercentage(context, percentage: 0.2),
                  child: CustomScrollView(
                    slivers: [
                      CupertinoSliverNavigationBar(
                        border: Border.all(color: Colors.transparent),
                        backgroundColor: Colors.transparent,
                        leading: IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(
                            CupertinoIcons.back,
                            color: activeBlue,
                          ),
                        ),
                        largeTitle: Text(
                          'Privacy & Safety',
                          style: Theme.of(context).textTheme.headline4,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  color: systemBackground,
                  child: Column(
                    children: [
                      widget(
                        context: context,
                        text: 'Last seen',
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
                        text: 'About',
                        subtitle: viewModel.aboutSubtitle,
                        onTap: () => aboutDialog(viewModel, context),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  color: systemBackground,
                  child: ListTile(
                    title: Text(
                      'Read receipts',
                      style: Theme.of(context).textTheme.bodyText2,
                    ),
                    subtitle: const Text(
                        'If you truned off, you won\'t send or receive Read receipts.'),
                    trailing: CupertinoSwitch(
                      value: viewModel.readReceipts,
                      onChanged: (value) => viewModel.readReceiptsBool(value),
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
                    .copyWith(color: black)),
          ),
        ),
        const Divider(height: 0.0),
      ],
    );
  }
}
