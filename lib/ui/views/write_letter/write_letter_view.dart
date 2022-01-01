import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:hint/extensions/custom_color_scheme.dart';
import 'package:hint/models/user_model.dart';
import 'package:hint/services/nav_service.dart';
import 'package:hint/ui/shared/alert_dialog.dart';
import 'package:hint/ui/shared/ui_helpers.dart';
import 'package:hint/ui/views/account/edit_account/widgets/widgets.dart';
import 'package:hint/ui/views/auth/auth_widgets.dart';
import 'package:hint/ui/views/profile/profile_view.dart';
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
          model.log.wtf('hello');
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
          backgroundColor: Theme.of(context).colorScheme.scaffoldColor,
          appBar: cwAuthAppBar(context,
              title: 'Write a letter',
              leadingIcon: FeatherIcons.x,
              onPressed: () => Navigator.maybePop(context)),
          body: ListView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 20),
            children: [
              Row(
                children: [
                  Text('To : ',
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.black,
                          fontSize: 18,
                          fontWeight: FontWeight.w700)),
                  horizontalSpaceRegular,
                  InkWell(
                    onTap: () => navService.materialPageRoute(
                        context, ProfileView(fireUser: fireUser)),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 4),
                      decoration: BoxDecoration(
                          border: Border.all(
                              color: Theme.of(context).colorScheme.lightBlack),
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
                              style: TextStyle(
                                  color: Theme.of(context).colorScheme.black,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700))
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              verticalSpaceRegular,
              const Divider(height: 0),
              verticalSpaceRegular,
              Container(
                decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.lightGrey,
                    borderRadius: BorderRadius.circular(30)),
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                child: cwEATextField(
                  context,
                  model.writeLetterTech,
                  'Type your letter here',
                  autoFocus: false,
                  maxLength: 400,
                  onChanged: (value) {
                    model.updateIsEdited(true);
                    model.updateLetterEmpty();
                  },
                  textInputAction: TextInputAction.newline,
                ),
              ),
              verticalSpaceLarge,
              CWAuthProceedButton(
                  buttonTitle: 'Send It',
                  isActive: model.isActive,
                  isLoading: model.isBusy, onTap: () {
                model.sendLetter(context, fireUser);
                Navigator.pop(context);
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
