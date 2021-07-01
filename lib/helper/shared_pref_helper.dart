import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferenceHelper {
  static String userIdKey = 'USERIDKEY';
  static String userEmailKey = 'USEREMAILKEY';
  static String userNameKey = 'USERNAMEKEY';
  static String userPhotoKey = 'USERPHOTOKEY';

  //save data
  Future<bool> saveUserName(String getUserName) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.setString(userNameKey, getUserName);
  }

  Future<bool> saveUserEmail(String getUserEmail) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.setString(userEmailKey, getUserEmail);
  }

  Future<bool> saveUserId(String getUserId) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.setString(userIdKey, getUserId);
  }

  Future<bool> saveUserPhoto(String getUserPhoto) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.setString(userPhotoKey, getUserPhoto);
  }

  //get data
  Future<String?> getUserName() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getString(userNameKey);
  }

  Future<String?> getUserId() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getString(userIdKey);
  }

  Future<String?> getUserEmail() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getString(userEmailKey);
  }

  Future<String?> getUserPhoto() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getString(userPhotoKey);
  }
}
