import 'dart:convert';
import 'typed_error.dart';

abstract class Result<T> {
  Result._();
}

class SuccessResult<T> extends Result<T> {
  final T data;

  SuccessResult(this.data) : super._();
}

class FailureResult<T> extends Result<T> {
  final TypedError error;

  FailureResult(this.error) : super._();
}

Result<T> parseResult<T>(String jsonBody, T Function(Json) resultParser) {
  final Json json = jsonDecode(jsonBody);
  final String status = json['status'];
  final Json result = json['result'];
  if (status == 'ok') {
    return SuccessResult(resultParser(result));
  } else {
    return FailureResult(parseTypedError(status, result));
  }
}

typedef Json = Map<String, dynamic>;
