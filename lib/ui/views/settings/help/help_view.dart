import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:hint/extensions/custom_color_scheme.dart';
import 'package:hint/ui/views/account/edit_account/widgets/widgets.dart';
import 'package:hint/ui/views/auth/auth_widgets.dart';
import 'package:stacked/stacked.dart';

import 'help_viewmodel.dart';

class HelpView extends StatelessWidget {
  const HelpView({Key? key}) : super(key: key);

  static const String id = '/HelpView';

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<HelpViewModel>.reactive(
      viewModelBuilder: () => HelpViewModel(),
      builder: (context, model, child) => Scaffold(
        backgroundColor: Theme.of(context).colorScheme.scaffoldColor,
        appBar: cwAuthAppBar(context,
            title: 'Help', onPressed: () => Navigator.pop(context)),
        body: ListView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 20),
          children: [
            //cwEADetailsTile(context, 'Help Center'),
            cwEADetailsTile(
              context,
              'Terms and Conditions',
              onTap: () =>
                  model.launchURLInBrowser(context, model.termsConditionsURL),
              icon: FeatherIcons.externalLink,
            ),
            cwEADetailsTile(
              context,
              'Privacy Policy',
              onTap: () =>
                  model.launchURLInBrowser(context, model.privacyPolicyURL),
              icon: FeatherIcons.externalLink,
            ),
            //cwEADetailsTile(context, 'App Updates'),
            cwEADetailsTile(
              context,
              'About',
              onTap: () => model.launchURLInBrowser(context, model.homeURL),
              icon: FeatherIcons.externalLink,
            ),
          ],
        ),
      ),
    );
  }
}
