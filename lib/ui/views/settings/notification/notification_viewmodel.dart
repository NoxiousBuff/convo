import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:stacked/stacked.dart';
import 'package:hint/app/app_logger.dart';

class NotificationViewModel extends BaseViewModel {
  final log = getLogger('NotificationViewModel');

  bool _isNotificationAllowed = true;
  bool get isNoticationAllowed => _isNotificationAllowed;

  checkIfNotificationAllowed() async {
    final isAllowed = await AwesomeNotifications().isNotificationAllowed();
    _isNotificationAllowed = isAllowed;
    notifyListeners();
  }

}