import 'package:hint/api/hive.dart';
import 'package:hint/constants/app_strings.dart';
import 'package:share_plus/share_plus.dart';
import 'package:stacked/stacked.dart';
import 'package:hint/app/app_logger.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsViewModel extends BaseViewModel {
  final log = getLogger('SettingsViewModel');

  void invitePeople(){
     Share.share('We can chat realtime on Convo. It\'s super immersive. Let\'s do it. Click on the link to the get the app. https://theconvo.in');
  }

  Future<void> openEmailClient() async {
    String username = hiveApi.getUserData(FireUserField.username, defaultValue: '');
    final url = 'mailto:developer@theconvo.in?subject=Suggestion%20to%20improve%20Convo&body=Thanks%20for%20the%20suggestion%0A%0A%0AAdd%20your%20content%20here%0A%0A%0A%0AThanks,%0A$username';
    if (! await launch(url)) throw 'Could not launch $url';
  }
}