import 'package:shared_preferences/shared_preferences.dart';

class CacheHelper {
  static late SharedPreferences prefs;

  static Future<void> int() async {
    prefs = await SharedPreferences.getInstance();
  }

  static String? getToken(String key) {
    return prefs.getString(key);
  }

  static Future<bool> saveData(String key, dynamic value) async {
    if (value is String) {
      return prefs.setString(key, value);
    } else if (value is bool) {
      return prefs.setBool(key, value);
    } else if (value is double) {
      return prefs.setDouble(key, value);
    } else if (value == int) {
      return prefs.setInt(key, value);
    } else {
      return false;
    }
  }
}
