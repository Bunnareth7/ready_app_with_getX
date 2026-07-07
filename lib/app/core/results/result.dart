sealed class Result<T> {
  const Result();

  bool get isSuccess => this is Success<T>;
  bool get isFailure => this is Failure<T>;

  T? get data => switch (this) {
    Success<T>(:final data) => data,
    Failure<T>() => null,
  };

  String? get error => switch (this) {
    Success<T>() => null,
    Failure<T>(:final message) => message,

  };
}

final class Success<T> extends Result<T> {
  @override //
  final T data;

  const Success(this.data);
}
final class Failure<T> extends Result<T> {
  final int? code;
  final String message;

  const Failure({this.code, required this.message});
}
