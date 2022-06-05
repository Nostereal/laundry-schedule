import 'result.dart';

abstract class TypedError {
  abstract final String message;
}

class BadRequest extends TypedError {
  @override
  final String message;

  BadRequest(this.message);

  BadRequest.fromJson(Json json) : message=json['message'] ?? defaultErrorMessage;
}

class InternalError extends TypedError {
  @override
  final String message;

  InternalError(this.message);

  InternalError.fromJson(Json json) : message=json['message'] ?? defaultErrorMessage;
}

class Forbidden extends TypedError {
  @override
  final String message;

  Forbidden(this.message);

  Forbidden.fromJson(Json json) : message=json['message'] ?? defaultErrorMessage;
}

class Unknown extends TypedError {
  @override
  final String message;

  Unknown(this.message);

  Unknown.fromJson(Json json) : message=json['message'] ?? defaultErrorMessage;
}

TypedError parseTypedError(String status, Json result) {
  switch (status) {
    case 'bad-request':
      return BadRequest.fromJson(result);
    case 'internal-error':
      return InternalError.fromJson(result);
    case 'forbidden':
      return Forbidden.fromJson(result);
    default:
      return Unknown.fromJson(result);
  }

}

const String defaultErrorMessage = 'Произошла ошибка, попробуйте позже';
