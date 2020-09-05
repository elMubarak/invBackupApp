import 'package:flutter/material.dart';
import 'package:inventory_app/models/User.dart';
import 'package:inventory_app/services/ApiService.dart';
import 'package:shared_preferences/shared_preferences.dart';

class User extends ChangeNotifier {
  dynamic _user = {};
  dynamic _userError = {'message': ''};
  bool _loading = false;

  bool get loading => _loading;

  void setUser(UserModel user) async {
    this._user['token'] = user.accessToken;
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('token', user.accessToken);
    notifyListeners();
  }

  void setError(message) {
    print(message);
    this._userError['message'] = message;
  }

  void setLoading(bool value){
    _loading = value;
    notifyListeners();
  }

  Future<bool> attemptLogin(
      {@required String username, @required String password}) async {
    setLoading(true);
    try {
      var user = await ApiService.getInstance().login({
        'username': username,
        'password': password,
      });
      setUser(user);
      return true;
      setLoading(false);
    } catch (error) {
      setError(error);
    }

    return false;
  }
}
