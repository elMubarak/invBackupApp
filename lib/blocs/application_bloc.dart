import 'package:inventory_app/blocs/bloc_base.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApplicationBloc implements BlocBase {

  void saveStringLocal({String key, String value}) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, value);
  }

  void saveIntLocal({String key, int value}) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(key, value);
  }

  void saveBoolLocal({String key, bool value}) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(key, value);
  }

  void saveDoubleLocal({String key, double value}) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(key, value);
  }

  Future<dynamic> getStringLocal(String key, dynamic defaultValue) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.get(key) ?? defaultValue;
  }


  @override
  void dispose() {
  }

}