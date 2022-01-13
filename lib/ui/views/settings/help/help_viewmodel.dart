import 'package:flutter/material.dart';
import 'package:hint/ui/shared/custom_snackbars.dart';
import 'package:stacked/stacked.dart';
import 'package:hint/app/app_logger.dart';
import 'package:url_launcher/url_launcher.dart';

class HelpViewModel extends BaseViewModel {
  final log = getLogger('HelpViewModel');

  String get privacyPolicyURL => 'https://sites.google.com/view/theconvo/privacy-policy';

  String get termsConditionsURL => 'https://sites.google.com/view/theconvo/terms-conditions';

  String get homeURL => 'https://sites.google.com/view/theconvo/home';

  void launchURLInBrowser(BuildContext context, String url) async {
    if (! await launch(url)) customSnackbars.errorSnackbar(context, title: 'Error in opening url "$url".');
  }

}