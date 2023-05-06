import 'package:dartz/dartz.dart';

import '../../data/model/order/order_model.dart';
import '../../data/model/order/order_request.dart';
import '../../data/resource/remote/response/err_response.dart';

abstract class OrderRepository {
  Future<Either<ErrorResponse, OrderModel>> createOrder(
      OrderCreateRequest requestLogin);
  Future<Either<ErrorResponse, OrderModel>> getOrder(int orderId);
  Future<Either<ErrorResponse, OrderModel>> selectOrder(int orderId);
  Future<Either<ErrorResponse, List<OrderModel>>> getOrderWaiting();
  Future<Either<ErrorResponse, List<OrderModel>>> getOrderPending();
  Future<Either<ErrorResponse, List<OrderModel>>> getHistoryOrder();

  Future<Either<ErrorResponse, OrderModel>> putOrder(
      int orderId, int statusOrder);
  Future<bool> logout();
}
