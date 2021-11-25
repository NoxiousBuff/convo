import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:hint/app/app_colors.dart';
import 'package:hint/models/user_model.dart';
import 'package:hint/services/nav_service.dart';
import 'package:hint/ui/views/user_account/profile_photo.dart';
import 'package:hint/ui/views/user_account/update_user.dart';

class Account extends StatefulWidget {
  final FireUser fireUser;
  const Account({Key? key, required this.fireUser}) : super(key: key);

  @override
  _AccountState createState() => _AccountState();
}

class _AccountState extends State<Account> {
  final shape = RoundedRectangleBorder(borderRadius: BorderRadius.circular(12));

  Widget heading({required BuildContext context, required String title}) {
    return ListTile(
      title: Text(
        title,
        style: Theme.of(context).textTheme.bodyText1,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CupertinoNavigationBar(
        backgroundColor: Colors.transparent,
        border: Border.all(color: Colors.transparent),
        automaticallyImplyLeading: true,
        middle: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            'My Account',
            style: Theme.of(context).textTheme.bodyText1,
          ),
        ),
      ),
      body: Column(
        children: [
          ProfilePhoto(fireUser: widget.fireUser, connection: 'Online'),
          Container(
            color: systemBackground,
            child: Column(
              children: [
                heading(context: context, title: 'Account Information'),
                const Divider(height: 0),
                optionWidget(
                  context: context,
                  text: 'Username',
                  trailingText: widget.fireUser.username,
                  onTap: () => navService.materialPageRoute(context, UpdateUser(
                        fireUser: widget.fireUser,
                        property: 'username',
                      )),
                ),
                optionWidget(
                  context: context,
                  text: 'Email',
                  trailingText: widget.fireUser.email,
                  onTap: () => navService.materialPageRoute(context, UpdateUser(
                        fireUser: widget.fireUser,
                        property: 'username',
                      )),
                ),
                optionWidget(
                  context: context,
                  text: 'Phone',
                  onTap: () {},
                  trailingText:
                      '${widget.fireUser.countryPhoneCode} ${widget.fireUser.phone}',
                ),
                optionWidget(
                  context: context,
                  text: 'Change Password',
                  onTap: () {},
                ),
              ],
            ),
          ),
          Container(
            color: systemBackground,
            margin: const EdgeInsets.symmetric(vertical: 10),
            child: ListTile(
              title: Text(
                'Blocked Users',
                style: Theme.of(context)
                    .textTheme
                    .bodyText2!
                    .copyWith(color: systemRed),
              ),
              trailing: const Icon(
                FeatherIcons.arrowRight,
                size: 14.0,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget optionWidget({
    required BuildContext context,
    required String text,
    String? trailingText = '',
    required void Function()? onTap,
  }) {
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          child: ListTile(
            title: Text(
              text,
              style: Theme.of(context).textTheme.bodyText2,
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
        const Divider(height: 0.0),
      ],
    );
  }
}
