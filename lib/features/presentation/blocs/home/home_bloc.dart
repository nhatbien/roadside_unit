import 'dart:async';
import 'dart:math';

import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:just_audio/just_audio.dart';
import 'package:roadside_unit/core/routes/routes.dart';
import 'package:roadside_unit/features/data/model/order/order_model.dart';
import 'package:roadside_unit/features/domain/repository/order_repositoy.dart';

part 'home_state.dart';
part 'home_event.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final OrderRepository _orderRepository;
  HomeBloc(this._orderRepository) : super(const HomeState()) {
    on<ListenOrderWaiting>(
      listenOrderWaiting,
    );
    on<GetOrderWaiting>(
      getOrderWaiting,
    );
    on<ConnectServer>(
      connectServer,
    );
    on<StopServer>(
      stopServer,
    );
    on<SelectOrder>(
      selectionOrder,
    );
    on<GetOrderPending>(
      getOrderPending,
    );
  }
  StreamSubscription<Position>? _positionSubscription;
  Timer? timeListenLocation;
/* 
  void login(HomeEvent event, Emitter<HomeState> emit) async {
    final data = await _homeLoginUseCase
        .execute(RequestLogin(phone: state.phone, password: state.password));

    if (data is DataSuccess && data.data != null) {}
    if (data is DataFailed) {}
  } */
  final AudioPlayer _audioPlayer = AudioPlayer();

  void connectServer(ConnectServer event, Emitter<HomeState> emit) async {
    emit(state.copyWith(
      isConnected: true,
    ));
    add(ListenOrderWaiting());
  }

  void stopServer(StopServer event, Emitter<HomeState> emit) async {
    emit(state.copyWith(
      isConnected: false,
      orderPending: [],
      orderWaiting: [],
    ));
    timeListenLocation?.cancel();
  }

  void listenOrderWaiting(ListenOrderWaiting event, Emitter<HomeState> emit) {
    timeListenLocation?.cancel();
    timeListenLocation = Timer.periodic(const Duration(seconds: 5), (timer) {
      add(GetOrderWaiting());
    });
  }

  Future<void> getOrderWaiting(
      GetOrderWaiting event, Emitter<HomeState> emit) async {
    emit(state.copyWith(
      count: 0,
    ));
    final data = await _orderRepository.getOrderWaiting();

    data.fold((l) {
      print(l.error);
    }, (r) {
      print("ok${r.length}");
      if (r.isNotEmpty) {
        _audioPlayer.setAsset('assets/have.m4a');
        _audioPlayer.play();
      }
      emit(state.copyWith(orderWaiting: r, count: state.count + 1));

      print("update thanh cong");
    });
  }

  Future<void> getOrderPending(
      GetOrderPending event, Emitter<HomeState> emit) async {
    emit(state.copyWith(
      count: 0,
    ));
    final data = await _orderRepository.getOrderPending();

    data.fold((l) {
      print(l.error);
    }, (r) {
      print("ok${r.length}");
      emit(state.copyWith(
        orderPending: r,
        count: state.count + 1,
      ));

      print("update thanh cong");
    });
  }

  Future<void> selectionOrder(
      SelectOrder event, Emitter<HomeState> emit) async {
    emit(state.copyWith(
      count: 0,
      loading: HomeStatusBloc.loading,
    ));
    final data = await _orderRepository.selectOrder(event.orderId);

    data.fold((l) {
      emit(state.copyWith(
        loading: HomeStatusBloc.failure,
      ));
      print(l.error);
    }, (r) {
      print("chon don hang thanh cong");
      emit(state.copyWith(
        orderPending: List.from(state.orderPending)..add(r),
        orderWaiting: [],
        count: state.count + 1,
        loading: HomeStatusBloc.success,
      ));
      add(GetOrderWaiting());
      ScaffoldMessenger.of(AppNavigator.navigatorKey.currentContext!)
          .showSnackBar(const SnackBar(
        content: Text("Chọn đơn hàng thành công"),
      ));
      print("update thanh cong");
    });
  }
}
