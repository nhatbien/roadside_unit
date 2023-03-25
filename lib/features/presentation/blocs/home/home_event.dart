part of 'home_bloc.dart';

abstract class HomeEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class HomeInit extends HomeEvent {}

class HomeLogout extends HomeEvent {}

class HomeUnHomeenticated extends HomeEvent {}

class ExpiredToken extends HomeEvent {}

class ListenHome extends HomeEvent {
  final int homeId;
  ListenHome(this.homeId);
}

class CreatedHome extends HomeEvent {}

class Reset extends HomeEvent {}

class StopListen extends HomeEvent {}

class LoginProvinceChanged extends HomeEvent {
  final String province;
  LoginProvinceChanged({required this.province});
}

class AddressChanged extends HomeEvent {
  final String address;
  AddressChanged({required this.address});
}

class NoteChanged extends HomeEvent {
  final String note;
  NoteChanged({required this.note});
}

class HidePasswordChanged extends HomeEvent {}

class SelectionOrder extends HomeEvent {
  final int orderId;
  SelectionOrder(this.orderId);
}

class GetOrderWaiting extends HomeEvent {}

class GetOrderPending extends HomeEvent {}

class SelectOrder extends HomeEvent {
  final int orderId;
  SelectOrder(this.orderId);
}

class ListenOrderWaiting extends HomeEvent {}

class ConnectServer extends HomeEvent {}

class StopServer extends HomeEvent {}
