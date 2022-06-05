import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

const contentTypeHeader = {
  'Content-Type': 'application/json',
};

abstract class HttpClient {
  abstract final String baseUrl;

  Uri _getFullUrl(String path) => Uri.parse(baseUrl + path);

  Future<http.Response> get(
    String path, {
    Map<String, String>? headers = contentTypeHeader,
  }) =>
      http.get(_getFullUrl(path), headers: headers);

  Future<http.Response> post(
    String path, {
    Map<String, String>? headers = contentTypeHeader,
    Object? body,
    Encoding? encoding,
  }) =>
      http.post(
        _getFullUrl(path),
        headers: headers,
        body: body,
        encoding: encoding,
      );

  Future<http.Response> delete(
    String path, {
    Map<String, String>? headers = contentTypeHeader,
    Object? body,
    Encoding? encoding,
  }) =>
      http.delete(
        _getFullUrl(path),
        headers: headers,
        body: body,
        encoding: encoding,
      );
}

class LocalClient extends HttpClient {
  @override
  String get baseUrl => "https://localhost:8080/api/";
}
