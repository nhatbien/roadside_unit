part of 'home_bloc.dart';

enum HomeStatusBloc { initial, loading, success, expiredToken, failure }

class HomeState extends Equatable {
  //final UserEntity? home;
  final String address;
  final int count;
  final String note;
  final String messageError;
  final List<OrderModel> orderWaiting;
  final List<OrderModel> orderPending;
  final HomeStatusBloc status;
  final HomeStatusBloc loading;
  final bool isConnected;
  const HomeState({
    this.address = "",
    this.count = 0,
    this.note = "",
    this.messageError = "",
    this.orderWaiting = const [],
    this.orderPending = const [],
    this.status = HomeStatusBloc.initial,
    this.isConnected = false,
    this.loading = HomeStatusBloc.initial,
  });
  HomeState reset() {
    return const HomeState(
      status: HomeStatusBloc.initial,
      address: "",
      count: 0,
      note: "",
      messageError: "",
      orderWaiting: [],
      orderPending: [],
      isConnected: false,
      loading: HomeStatusBloc.initial,
    );
  }

  HomeState copyWith({
    HomeStatusBloc? status,
    HomeStatusBloc? statusCreatedHome,
    String? address,
    String? note,
    int? count,
    String? messageError,
    List<OrderModel>? orderWaiting,
    List<OrderModel>? orderPending,
    bool? isConnected,
    HomeStatusBloc? loading,
  }) {
    return HomeState(
      status: status ?? this.status,
      address: address ?? this.address,
      count: count ?? this.count,
      note: note ?? this.note,
      messageError: messageError ?? this.messageError,
      orderWaiting: orderWaiting ?? this.orderWaiting,
      orderPending: orderPending ?? this.orderPending,
      isConnected: isConnected ?? this.isConnected,
      loading: loading ?? this.loading,
    );
  }

  @override
  List<Object?> get props => [
        status,
        count,
        address,
        messageError,
        note,
        orderWaiting,
        orderPending,
        isConnected,
        loading,
      ];
}
