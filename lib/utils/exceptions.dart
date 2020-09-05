import 'dart:convert';

import 'package:meta/meta.dart';


class Api401Exception implements Exception {

  String message = "UnAuthorized";
  int code;
  var realReason;

  Api401Exception({String message}){
    this.message = message;
  }
}


class ApiException implements Exception {

  String message;
  int code;
  var realReason;

  ApiException({@required String jsonBody, int code = 400, dynamic realReason}) {
    ErrorMessage errorMessage = ErrorMessage.fromJson(json.decode(jsonBody));
    this.message = errorMessage.message;
    this.code = code;
    this.realReason = realReason;
  }
}

class ErrorMessage {
  String _message;

  ErrorMessage.fromJson(Map<String, dynamic> parsedJson) {
    _message = parsedJson['message'];
  }

  String get message => _message;
}