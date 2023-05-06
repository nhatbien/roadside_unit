import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../../../core/helper/pref_manager.dart';
import '../../../di/injector.dart';
import '../../domain/repository/order_repositoy.dart';
import '../model/order/order_model.dart';
import '../model/order/order_request.dart';
import '../resource/base_url.dart';
import '../resource/remote/client_api.dart';
import '../resource/remote/response/err_response.dart';

class OrderImpl implements OrderRepository {
  final ClientDio _clientDio;

  OrderImpl(this._clientDio);

  final _pref = injector<PrefManager>();

  @override
  Future<Either<ErrorResponse, OrderModel>> createOrder(
      OrderCreateRequest requestLogin) async {
    try {
      final response = await _clientDio.postJson(buildUrl('/order/save'),
          body: requestLogin.toJson(),
          headers: {
            "Authorization": "Bearer ${_pref.token}",
          });
      return Right(OrderResponse.fromJson(response.data).data!);
    } on DioError catch (e) {
      print(e);
      return Left(SingleMessageErrorResponse.fromJson(e.response?.data));
    }
  }

  @override
  Future<Either<ErrorResponse, OrderModel>> getOrder(int orderId) async {
    try {
      final response =
          await _clientDio.getJson(buildUrl('/order/$orderId'), headers: {
        "Authorization": "Bearer ${_pref.token}",
      });
      return Right(OrderResponse.fromJson(response.data).data!);
    } on DioError catch (e) {
      if (e.response != null) {
        return Left(SingleMessageErrorResponse.fromJson(e.response?.data));
      }
      return Left(SingleMessageErrorResponse(
        error: e.message ?? 'Error',
        status: false,
      ));
    }
  }

  @override
  Future<Either<ErrorResponse, List<OrderModel>>> getOrderWaiting() async {
    try {
      final response = await _clientDio
          .getJson(buildUrl('/rescue-unit/order/all'), headers: {
        "Authorization": "Bearer ${_pref.token}",
      });
      return Right(ListOrderWaitingResponse.fromJson(response.data).data!);
    } on DioError catch (e) {
      if (e.response != null) {
        return Left(SingleMessageErrorResponse.fromJson(e.response?.data));
      }
      return Left(SingleMessageErrorResponse(
        error: e.message ?? 'Error',
        status: false,
      ));
    }
  }

  @override
  Future<Either<ErrorResponse, List<OrderModel>>> getOrderPending() async {
    try {
      final response = await _clientDio
          .getJson(buildUrl('/rescue-unit/order/pending'), headers: {
        "Authorization": "Bearer ${_pref.token}",
      });
      return Right(ListOrderWaitingResponse.fromJson(response.data).data!);
    } on DioError catch (e) {
      if (e.response != null) {
        return Left(SingleMessageErrorResponse.fromJson(e.response?.data));
      }
      return Left(SingleMessageErrorResponse(
        error: e.message ?? 'Error',
        status: false,
      ));
    }
  }

  @override
  Future<Either<ErrorResponse, OrderModel>> selectOrder(int orderId) async {
    try {
      final response = await _clientDio
          .postJson(buildUrl('/rescue-unit/order/$orderId/select'), headers: {
        "Authorization": "Bearer ${_pref.token}",
      });
      return Right(OrderResponse.fromJson(response.data).data!);
    } on DioError catch (e) {
      if (e.response != null) {
        return Left(SingleMessageErrorResponse.fromJson(e.response?.data));
      }
      return Left(SingleMessageErrorResponse(
        error: e.message ?? 'Error',
        status: false,
      ));
    }
  }

  @override
  Future<Either<ErrorResponse, OrderModel>> putOrder(
      int orderId, int statusOrder) async {
    try {
      final response = await _clientDio.putJson(
        buildUrl('/rescue-unit/order/$orderId'),
        headers: {
          "Authorization": "Bearer ${_pref.token}",
        },
        body: {
          "status": statusOrder,
        },
      );
      return Right(OrderResponse.fromJson(response.data).data!);
    } on DioError catch (e) {
      if (e.response != null) {
        return Left(SingleMessageErrorResponse.fromJson(e.response?.data));
      }
      return Left(SingleMessageErrorResponse(
        error: e.message ?? 'Error',
        status: false,
      ));
    }
  }

  @override
  Future<bool> logout() async {
    _pref.logout();

    return true;
  }

  @override
  Future<Either<ErrorResponse, List<OrderModel>>> getHistoryOrder() async {
    try {
      final response = await _clientDio
          .getJson(buildUrl('/rescue-unit/order/history'), headers: {
        "Authorization": "Bearer ${_pref.token}",
      });
      return Right(ListOrderResponse.fromJson(response.data).data ?? []);
    } on DioError catch (e) {
      if (e.response != null) {
        return Left(SingleMessageErrorResponse.fromJson(e.response?.data));
      }
      return Left(SingleMessageErrorResponse(
        error: e.message ?? 'Error',
        status: false,
      ));
    }
  }
}
