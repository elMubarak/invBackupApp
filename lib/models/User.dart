class UserModel {
  String _accessToken;

  UserModel({String accessToken}) {
    this._accessToken = accessToken;
  }

  String get accessToken => _accessToken;
  set accessToken(String accessToken) => _accessToken = accessToken;


  UserModel.fromJson(Map<String, dynamic> json) {
    _accessToken = json['access_token'];
  }

}

