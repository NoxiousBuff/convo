import 'package:flutter/material.dart';
import 'package:hint/api/hive.dart';
import 'package:hint/constants/app_strings.dart';
import 'package:hint/extensions/custom_color_scheme.dart';
import 'package:hint/services/nav_service.dart';
import 'package:hint/ui/shared/ui_helpers.dart';
import 'package:hint/ui/views/auth/auth_widgets.dart';
import 'package:hint/ui/views/account/edit_account/widgets/widgets.dart';
import 'package:hint/ui/views/settings/update_email/update_email_view.dart';
import 'package:hint/ui/views/settings/update_password/update_password_view.dart';
import 'package:hint/ui/views/settings/user_account/user_account_viewmodel.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:stacked/stacked.dart';

class UserAccountView extends StatefulWidget {
  const UserAccountView({Key? key}) : super(key: key);

  @override
  State<UserAccountView> createState() => _AccountState();
}

class _AccountState extends State<UserAccountView> {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<UserAccountViewModel>.reactive(
      viewModelBuilder: () => UserAccountViewModel(),
      builder: (context, model, child) {
        return Scaffold(
          backgroundColor: Theme.of(context).colorScheme.scaffoldColor,
          appBar:
              cwAuthAppBar(context, title: 'Account Details', onPressed: () {
            Navigator.pop(context);
          }),
          body: ValueListenableBuilder<Box>(
            valueListenable: hiveApi.hiveStream(HiveApi.userDataHiveBox),
            builder: (context, box, child) {
              return Column(
                children: [
                  const Divider(),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      'This is your personal information you can change here your personal details and these details are not seen in your public profile.',
                      style: Theme.of(context).textTheme.bodyText2!.copyWith(
                            color: Theme.of(context).colorScheme.mediumBlack,
                          ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const Divider(),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: [
                        verticalSpaceRegular,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            cwEADescriptionTitle(context, 'Information'),
                          ],
                        ),
                        verticalSpaceRegular,
                        cwEADetailsTile(context, 'Email',
                            subtitle: box.get(FireUserField.email), onTap: () {
                          navService.materialPageRoute(
                              context, const UpdateEmailView());
                        }),
                        cwEADetailsTile(context, 'Change Password',
                            onTap: () => navService.materialPageRoute(
                                context, const UpdatePasswordView())),
                        verticalSpaceMedium,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            cwEADescriptionTitle(context, 'Preferences'),
                          ],
                        ),
                        verticalSpaceRegular,
                        cwEADetailsTile(
                          context,
                          'Delete My User Account',
                          showTrailingIcon: false,
                          titleColor: Colors.red,
                          subtitle:
                              'If you want to delete your account, please email us at support@theconvo.in',
                          onTap: () =>
                              model.openEmailClienForAccountdDeletion(context),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }
}
