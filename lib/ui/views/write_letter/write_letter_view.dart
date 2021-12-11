import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:hint/app/app_colors.dart';
import 'package:hint/models/user_model.dart';
import 'package:hint/ui/shared/alert_dialog.dart';
import 'package:hint/ui/shared/ui_helpers.dart';
import 'package:hint/ui/views/account/edit_account/widgets/widgets.dart';
import 'package:hint/ui/views/auth/auth_widgets.dart';
import 'package:stacked/stacked.dart';

import 'write_letter_viewmodel.dart';

class WriteLetterView extends StatelessWidget {
  const WriteLetterView({Key? key, required this.fireUser}) : super(key: key);

  final FireUser fireUser;
  static const String id = '/WriteLetterView ';

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<WriteLetterViewModel>.reactive(
      viewModelBuilder: () => WriteLetterViewModel(),
      builder: (context, model, child) => WillPopScope(
        onWillPop: () async {
          if (model.isEdited) {
            final shouldPop = await showDialog(
                context: context,
                builder: (context) {
                  return DuleAlertDialog(
                    title: 'Do you want to delete this letter ?',
                    icon: FeatherIcons.trash,
                    primaryButtonText: 'Yes',
                    primaryOnPressed: () => Navigator.pop(context, true),
                    description:
                        'All the changes related to this letter will not be saved.',
                    secondaryButtontext: 'No',
                    secondaryOnPressed: () => Navigator.pop(context, false),
                  );
                });
            return shouldPop;
          } else {
            return true;
          }
        },
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: cwAuthAppBar(context,
              title: 'Write a letter',
              leadingIcon: FeatherIcons.x,
              onPressed: () => Navigator.maybePop(context)),
          body: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            children: [
              Row(
                children: [
                  const Text('To : ',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.w700)),
                  horizontalSpaceRegular,
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.black12),
                        borderRadius: BorderRadius.circular(10)),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: CachedNetworkImage(
                            imageUrl: fireUser.photoUrl,
                            height: 28,
                            width: 28,
                            fit: BoxFit.cover,
                          ),
                        ),
                        horizontalSpaceRegular,
                        Text(fireUser.username,
                            style: const TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                                fontWeight: FontWeight.w700))
                      ],
                    ),
                  ),
                ],
              ),
              verticalSpaceRegular,
              const Divider(height: 0),
              verticalSpaceRegular,
              Container(
                decoration: BoxDecoration(
                    color: AppColors.lightGrey,
                    borderRadius: BorderRadius.circular(30)),
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                child: cwEATextField(
                    context, model.letterTech, 'Type your letter here',
                    autoFocus: false, maxLength: 400, onChanged: (value) {
                  model.updateIsEdited(true);
                  model.updateLetterEmpty();
                }),
              ),
              verticalSpaceLarge,
              cwAuthProceedButton(context,
                  buttonTitle: 'Send It',
                  isActive: model.isActive,
                  isLoading: model.isBusy, onTap: () {
                model.sendLetter(context, fireUser);
              }),
              verticalSpaceLarge,
              bottomPadding(context),
            ],
          ),
        ),
      ),
    );
  }
}
