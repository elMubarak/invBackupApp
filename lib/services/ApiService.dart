import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:inventory_app/models/User.dart';
import 'package:inventory_app/utils/exceptions.dart';

class ApiService {
  static ApiService _service;
  static Dio _dio;
  static const baseURL = "https://candistockapp.herokuapp.com/";

  static ApiService getInstance() {
    if (_service == null) {
      _service = ApiService();
      _dio = Dio();
      _dio.interceptors.add(LogInterceptor(
          requestHeader: false,
          responseHeader: false,
          requestBody: true,
          responseBody: true));
      _dio.options.baseUrl = baseURL;
      _dio.options.connectTimeout = 30000; //30s
      _dio.options.receiveTimeout = 100000; //100s
    }
    return _service;
  }

  Future<UserModel> login(dynamic body) async {
    final userBody = await _sendPostWithJson(url: '/auth', body: body);

    return UserModel.fromJson(userBody.data);
  }

  Future<Response> _sendPostWithJson(
      {@required String url,
      @required Map<String, dynamic> body,
      Duration sec = const Duration(seconds: 2)}) async {
    try {
      var response = await _dio.post(url, data: json.encode(body));

      return response;
    } on DioError catch (e) {
      // The request was made and the server responded with a status code
      // that falls out of the range of 2xx and is also not 304.
      if (e.response != null) {
        //print(e.response.data);
        //print(e.response.headers);
        //print(e.response.request);
        if (e.response.statusCode == 401 || e.response.statusCode == 402) {
          if ((e.response.data)['message'] != null) {
            //print((e.response.data)['message']);
            throw Api401Exception(message: (e.response.data)['message']);
          } else {
            throw Api401Exception();
          }
        } else {
          var jsonBody = json.encode({"message": (e.response.data)['message']});
          if ((e.response.data)['message'] != null) {
            throw ApiException(jsonBody: jsonBody, code: e.response.statusCode);
          } else {
            throw ApiException(
                jsonBody: json.encode({"message": e.message}),
                code: e.response.statusCode);
          }
        }
      } else {
        // Something happened in setting up or sending the request that triggered an Error
        //print(e.request);
        //print(e.message);
        throw new ApiException(
            jsonBody: '{"message":"Network Error"}', code: 400);
      }
    }
  }

  Future<Response> _sendGet(
      {@required String url,
      Duration sec = const Duration(seconds: 60)}) async {
    try {
      var response = await _dio.get(url);

      //print(response);
      return response;
    } on DioError catch (e) {
      // The request was made and the server responded with a status code
      // that falls out of the range of 2xx and is also not 304.
      if (e.response != null) {
        //print(e.response.data);
        //print(e.response.headers);
        //(e.response.request);
        if (e.response.statusCode == 401 || e.response.statusCode == 402) {
          if ((e.response.data)['message'] != null) {
            throw Api401Exception(message: (e.response.data)['message']);
          } else {
            throw Api401Exception();
          }
        } else {
          if ((e.response.data)['message'] != null) {
            throw ApiException(
                jsonBody:
                    json.encode({"message": (e.response.data)['message']}),
                code: e.response.statusCode);
          } else {
            throw ApiException(
                jsonBody: json.encode({"message": e.message}),
                code: e.response.statusCode);
          }
        }
      } else {
        // Something happened in setting up or sending the request that triggered an Error
        //print(e.request);
        //print(e.message);
        throw ApiException(jsonBody: '{"message":"Network Error"}', code: 400);
      }
    }
  }
}
