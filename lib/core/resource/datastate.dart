import 'package:dio/dio.dart';

abstract class DataState<T> {
  final T? data;
  final DioError? error;
  final String? errorString;
  const DataState({this.data, this.error, this.errorString});
}

class DataSuccess<T> extends DataState<T> {
  const DataSuccess(T data) : super(data: data);
}

class DataFailed<T> extends DataState<T> {
  const DataFailed(DioError error) : super(error: error);
}

class DataError<T> extends DataState<T> {
  const DataError(String errorString) : super(errorString: errorString);
}
