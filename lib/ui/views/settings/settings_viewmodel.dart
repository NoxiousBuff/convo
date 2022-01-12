import 'package:flutter/cupertino.dart';
import 'package:hint/api/hive.dart';
import 'package:hint/constants/app_strings.dart';
import 'package:hint/ui/shared/custom_snackbars.dart';
import 'package:share_plus/share_plus.dart';
import 'package:stacked/stacked.dart';
import 'package:hint/app/app_logger.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsViewModel extends BaseViewModel {
  final log = getLogger('SettingsViewModel');

  void invitePeople() {
    String username =
        hiveApi.getUserData(FireUserField.username, defaultValue: '');
    Share.share(
        'I am on Convo as @$username. We can chat realtime and it\'s super immersive. Install the app to connect with me. https://theconvo.in');
  }

  Future<void> openEmailClient(BuildContext context) async {
    String username =
        hiveApi.getUserData(FireUserField.username, defaultValue: '');
    final url =
        'mailto:developer@theconvo.in?subject=Suggestion%20to%20improve%20Convo&body=Thanks%20for%20the%20suggestion%0A%0A%0AAdd%20your%20content%20here%0A%0A%0A%0AThanks,%0A$username';
    if (!await launch(url)) {
      customSnackbars.errorSnackbar(context,
          title: 'Error in opening email client.');
    }
  }
}
