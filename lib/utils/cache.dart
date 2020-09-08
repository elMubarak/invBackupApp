import 'package:shared_preferences/shared_preferences.dart';

class CachedStorage {

  static String _tokenKey = "user_key";

  static void saveUserKey(String key) async {
    var sharedPref = await SharedPreferences.getInstance();
    sharedPref.setString(_tokenKey, key);
  }

  static Future<String> getUserKey() async {
    var sharedPref = await SharedPreferences.getInstance();
    return sharedPref.get(_tokenKey);
  }

}