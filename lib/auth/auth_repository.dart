import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:windows1251/windows1251.dart';

class AuthRequest {
  String login;
  String password;
  String? sessionId;

  AuthRequest(this.login, this.password, {this.sessionId});

  Map<String, String> toJson() {
    return {
      'ulogin': login,
      'upassword': password,
      'sessionId': sessionId ?? "",
    };
  }
}

class AuthResponse {
  String sessionId;

  AuthResponse(this.sessionId);

  static AuthResponse fromJson(Map<String, dynamic> json) {
    return AuthResponse(json['sessionId']!);
  }
}

class AuthRepository {
  static const baseUrl = "https://e.mospolytech.ru";

  Future<AuthResponse> authorize(AuthRequest request) async {
    final resp = await http.post(
      Uri.parse(baseUrl + "/old?p=login"),
      headers: {
        HttpHeaders.contentTypeHeader: "application/x-www-form-urlencoded",
      },
      encoding: windows1251,
      body: request.toJson(),
    ); 

    // todo: handle statuses
    log(resp.body);
    return AuthResponse(resp.body);
  }

  // void diooooo() {
  //   final RequestEncoder encoder = ()
  //   BaseOptions()
  //   Dio();
  // }
}
