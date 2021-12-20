import 'package:hint/app/app_logger.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionService {

  final log = getLogger("PermissionService");

  Future<bool> requestContactsPermission(Permission permission) async {
    if (await permission.isGranted) {
      return true;
    } else {
      var result = await permission.request();
      if (result == PermissionStatus.granted) {
        return true;
      }
    }
    return false;
  }
}