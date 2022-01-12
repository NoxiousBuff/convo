import 'package:flutter/material.dart';
import 'package:hint/constants/app_strings.dart';
import 'package:hint/extensions/custom_color_scheme.dart';
import 'package:hint/ui/shared/ui_helpers.dart';
import 'package:hint/ui/views/auth/auth_widgets.dart';
import 'package:stacked/stacked.dart';

import 'choose_profile_photo_viewmodel.dart';

class ChooseProfilePhotoView extends StatelessWidget {
  const ChooseProfilePhotoView({Key? key}) : super(key: key);

  static const String id = '/ChooseProfilePhotoView';

  Widget userProfileImageSelector(
    BuildContext context,
    ChooseProfilePhotoViewModel model,
    String imagePath,
  ) {
    return Expanded(
      child: InkWell(
        onTap: () => model.updateUserProperty(
            context, FireUserField.photoUrl, imagePath),
        borderRadius: BorderRadius.circular(model.imageWidth(context) * 0.4),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(model.imageWidth(context) * 0.4),
          child: Image.asset(imagePath),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ChooseProfilePhotoViewModel>.reactive(
      viewModelBuilder: () => ChooseProfilePhotoViewModel(),
      builder: (context, model, child) => Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: Theme.of(context).colorScheme.scaffoldColor,
        appBar: cwAuthAppBar(context,
            title: 'Add a Profile Photo', showLeadingIcon: false),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    cwAuthDescription(context, title: 'Tap To Select Image'),
                    verticalSpaceRegular,
                    Row(
                      children: [
                        userProfileImageSelector(
                            context, model, 'assets/default1.png'),
                        horizontalSpaceRegular,
                        userProfileImageSelector(
                            context, model, 'assets/default2.png'),
                      ],
                    ),
                    verticalSpaceRegular,
                    Row(
                      children: [
                        userProfileImageSelector(
                            context, model, 'assets/default3.png'),
                        horizontalSpaceRegular,
                        userProfileImageSelector(
                            context, model, 'assets/default4.png'),
                      ],
                    ),
                  ],
                ),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  verticalSpaceRegular,
                  cwAuthDescription(context, title: 'Or Make it yours 🥳🥳'),
                  verticalSpaceSmall,
                  CWAuthProceedButton(
                    buttonTitle: 'Pick From Gallery',
                    onTap: () => model.pickImage(context),
                    isLoading: model.isBusy,
                  )
                ],
              ),
              verticalSpaceLarge,
              bottomPadding(context),
            ],
          ),
        ),
      ),
    );
  }
}
