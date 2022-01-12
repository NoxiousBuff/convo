import 'package:flutter/material.dart';
import 'package:hint/api/hive.dart';
import 'package:hint/constants/app_strings.dart';
import 'package:hint/ui/shared/custom_snackbars.dart';
import 'package:stacked/stacked.dart';
import 'package:url_launcher/url_launcher.dart';

class UserAccountViewModel extends BaseViewModel {

  Future<void> openEmailClienForAccountdDeletion(BuildContext context) async {
    String username = hiveApi.getUserData(FireUserField.username, defaultValue: '');
    final url = 'mailto:support@theconvo.in?subject=Request%20to%20delete%20my%20Convo%20Account&body=We%20are%20sorry%20to%20see%20you%20go.%20%0A%0A%0AAdd%20your%20content%20here%0A%0A%0A%0AThanks,%0A$username';
    if (! await launch(url)) customSnackbars.errorSnackbar(context, title: 'Error in opening email client.');
  }
}