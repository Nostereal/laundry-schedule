import 'dart:convert';

/// userId : 116230
/// token : "tDj9RH7i4qZQPyKeDQNleQEKfAqTtLUWq1cKNS2xGCUJmCJs9HQq6TC61qiEtfnCKB1QjAWeLOA0b0aPIFi%2BE2KJx32sisDr3HDe5QxtfZQXMxlAA2WoMqiGznEvXlLmkHZV9tWY69lMXz6nQkoL%2FKtKQ7zQQkunEjhiyNaXCRs%3D"

AuthResponse authResponseFromJson(String str) =>
    AuthResponse.fromJson(json.decode(str));

String authResponseToJson(AuthResponse data) => json.encode(data.toJson());

class AuthResponse {
  AuthResponse({
    required int userId,
    required String token,
  }) {
    _userId = userId;
    _token = token;
  }

  AuthResponse.fromJson(dynamic json) {
    _userId = json['userId'];
    _token = json['token'];
  }

  late int _userId;
  late String _token;

  AuthResponse copyWith({
    int? userId,
    String? token,
  }) =>
      AuthResponse(
        userId: userId ?? _userId,
        token: token ?? _token,
      );

  int get userId => _userId;
  String get token => _token;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['userId'] = _userId;
    map['token'] = _token;
    return map;
  }
}
