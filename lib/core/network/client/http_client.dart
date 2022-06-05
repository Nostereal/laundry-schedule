import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

const contentTypeHeader = {
  'Content-Type': 'application/json',
};

abstract class HttpClient {
  abstract final String baseUrl;

  Uri _getFullUrl(String path, {Map<String, dynamic>? queryParams});

  Future<http.Response> get(
    String path, {
    Map<String, String>? headers = contentTypeHeader,
    Map<String, dynamic>? queryParams,
  }) =>
      http.get(_getFullUrl(path, queryParams: queryParams), headers: headers);

  Future<http.Response> post(
    String path, {
    Map<String, String>? headers = contentTypeHeader,
    Map<String, dynamic>? queryParams,
    Object? body,
    Encoding? encoding,
  }) =>
      http.post(
        _getFullUrl(path, queryParams: queryParams),
        headers: headers,
        body: body,
        encoding: encoding,
      );

  Future<http.Response> delete(
    String path, {
    Map<String, String>? headers = contentTypeHeader,
    Map<String, dynamic>? queryParams,
    Object? body,
    Encoding? encoding,
  }) =>
      http.delete(
        _getFullUrl(path, queryParams: queryParams),
        headers: headers,
        body: body,
        encoding: encoding,
      );
}

class LocalClient extends HttpClient {
  @override
  String get baseUrl => "192.168.31.64:8080";

  @override
  Uri _getFullUrl(String path, {Map<String, dynamic>? queryParams}) {
    return Uri.http(baseUrl, "/api/" + path, queryParams);
  }
}
