import 'package:flutter/material.dart';
import 'package:hint/extensions/custom_color_scheme.dart';
import 'package:hint/services/nav_service.dart';
import 'package:hint/ui/views/account/edit_account/widgets/widgets.dart';
import 'package:hint/ui/views/auth/auth_widgets.dart';
import 'package:hint/ui/views/settings/help/about/about_view.dart';
import 'package:hint/ui/views/settings/help/privacy_policy/privacy_policy_view.dart';
import 'package:hint/ui/views/settings/help/terms_and_conditions/terms_and_conditions_view.dart';

class HelpView extends StatelessWidget {
  const HelpView({Key? key}) : super(key: key);

  Widget optionTile(BuildContext context, String title, IconData icon) {
    return ListTile(
      title: Text(
        title,
        style: Theme.of(context).textTheme.bodyText2!.copyWith(fontSize: 16),
      ),
      leading: Icon(icon, color: Theme.of(context).colorScheme.darkGrey),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.scaffoldColor,
      appBar: cwAuthAppBar(context, title: 'Help', onPressed: ()=> Navigator.pop(context)),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        children: [
          //cwEADetailsTile(context, 'Help Center'),
          cwEADetailsTile(context, 'Terms and Conditions',onTap: ()=> navService.materialPageRoute(context, const TermsAndConditionsView())),
          cwEADetailsTile(context, 'Privacy Policy',onTap: ()=> navService.materialPageRoute(context, const PrivacyPolicyView())),
          //cwEADetailsTile(context, 'App Updates'),
          cwEADetailsTile(context, 'About',onTap: ()=> navService.materialPageRoute(context, const AboutAppView())),
        ],
      ),
    );
  }
}