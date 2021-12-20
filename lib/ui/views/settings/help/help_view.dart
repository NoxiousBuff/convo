import 'package:flutter/material.dart';
import 'package:hint/app/app_colors.dart';
import 'package:hint/ui/views/account/edit_account/widgets/widgets.dart';
import 'package:hint/ui/views/auth/auth_widgets.dart';

class HelpView extends StatelessWidget {
  const HelpView({Key? key}) : super(key: key);

  Widget optionTile(BuildContext context, String title, IconData icon) {
    return ListTile(
      title: Text(
        title,
        style: Theme.of(context).textTheme.bodyText2!.copyWith(fontSize: 16),
      ),
      leading: Icon(icon, color: AppColors.darkGrey),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldColor,
      appBar: cwAuthAppBar(context, title: 'Help', onPressed: ()=> Navigator.pop(context)),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        children: [
          cwEADetailsTile(context, 'Help Center'),
          cwEADetailsTile(context, 'Terms and Conditions'),
          cwEADetailsTile(context, 'Privacy Policy'),
          cwEADetailsTile(context, 'App Updated'),
          cwEADetailsTile(context, 'About'),
        ],
      ),
    );
  }
}