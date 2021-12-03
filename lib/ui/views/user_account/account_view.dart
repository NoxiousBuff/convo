import 'package:hint/api/hive.dart';
import 'package:hint/constants/app_strings.dart';
import 'package:hint/ui/views/settings/delete_account/delete_view.dart';
import 'package:hint/ui/views/settings/privacy/privacy_view.dart';
import 'package:hint/ui/views/settings/security_view.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:stacked/stacked.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:hint/app/app_colors.dart';
import 'package:hint/services/nav_service.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';

import 'account_viewmodel.dart';

class Account extends StatefulWidget {
  const Account({Key? key}) : super(key: key);

  @override
  State<Account> createState() => _AccountState();
}

class _AccountState extends State<Account> {
  final shape = RoundedRectangleBorder(borderRadius: BorderRadius.circular(12));

  Widget heading({required BuildContext context, required String title}) {
    return ListTile(
      title: Text(
        title,
        style: Theme.of(context).textTheme.headline6,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<AccountViewModel>.reactive(
      viewModelBuilder: () => AccountViewModel(),
      builder: (context, model, child) {
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
                  'Account',
                  style: Theme.of(context).textTheme.headline6,
                ),
              ],
            ),
          ),
          body: ValueListenableBuilder<Box>(
            valueListenable: hiveApi.hiveStream(HiveApi.userdataHiveBox),
            builder: (context, box, child) {
              String countryCode = box.get(FireUserField.countryPhoneCode);
              String phoneNumber = box.get(FireUserField.phone);
              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      'This is your personal information you can change here your personal details and these details are not seen in your public profile.',
                      style: Theme.of(context)
                          .textTheme
                          .bodyText2!
                          .copyWith(color: AppColors.darkGrey),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Container(
                    color: AppColors.white,
                    child: Column(
                      children: [
                        heading(context: context, title: 'Account Information'),
                        const Divider(height: 0),
                        optionWidget(
                          context: context,
                          text: 'Email',
                          trailingText: box.get(FireUserField.email),
                        ),
                        optionWidget(
                          context: context,
                          text: 'Phone',
                          onTap: () {},
                          trailingText: 
                              '$countryCode $phoneNumber',
                        ),
                        optionWidget(
                          context: context,
                          text: 'Change Password',
                          onTap: () {},
                        ),
                        const SizedBox(height: 20),
                        ListTile(
                          title: Text(
                            'Prefrences',
                            style: Theme.of(context).textTheme.headline6,
                          ),
                        ),
                        ListTile(
                          title: const Text('Privacy'),
                          trailing: const Icon(CupertinoIcons.lock),
                          onTap: () => navService.cupertinoPageRoute(
                              context, const PrivacyView()),
                        ),
                        ListTile(
                          title: const Text('Security'),
                          trailing: const Icon(CupertinoIcons.shield),
                          onTap: () => navService.cupertinoPageRoute(
                              context, const SecurityView()),
                        ),
                        ListTile(
                          title: const Text('Delete My Account'),
                          trailing: const Icon(CupertinoIcons.delete),
                          onTap: () => navService.cupertinoPageRoute(
                              context, const DeleteMyAccount()),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            }
          ),
        );
      },
    );
  }

  Widget optionWidget({
    required BuildContext context,
    required String text,
    String? trailingText = '',
    void Function()? onTap,
  }) {
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          child: ListTile(
            title: Text(
              text,
              overflow: TextOverflow.ellipsis,
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(trailingText!),
                const Icon(
                  FeatherIcons.arrowRight,
                  size: 14.0,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}