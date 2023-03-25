part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class AuthInit extends AuthEvent {}

class AuthLogout extends AuthEvent {}

class AuthUnAuthenticated extends AuthEvent {}

class ExpiredToken extends AuthEvent {}

class GetUserInfo extends AuthEvent {}

class LoginSubmitted extends AuthEvent {}

class LoginProvinceChanged extends AuthEvent {
  final String province;
  LoginProvinceChanged({required this.province});
}

class LoginPasswordChanged extends AuthEvent {
  final String password;
  LoginPasswordChanged({required this.password});
}

class LoginPhoneChanged extends AuthEvent {
  final String phone;
  LoginPhoneChanged({required this.phone});
}

class HidePasswordChanged extends AuthEvent {}

class ListenUpdateLocation extends AuthEvent {}

class UpdateLocation extends AuthEvent {}

class LocationEvent extends AuthEvent {}

class LocationChange extends AuthEvent {
  final Position position;
  LocationChange(this.position);
}
