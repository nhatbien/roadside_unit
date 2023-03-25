part of 'auth_bloc.dart';

enum AuthStatusBloc {
  initial,
  loading,
  loaded,
  authenticated,
  unauthenticated,
  expiredToken,
  failure
}

class AuthState extends Equatable {
  //final UserEntity? auth;
  final String phone;
  final UserModel? user;
  final String password;
  final Position? currentLocation;
  final String messageError;
  final AuthStatusBloc status;
  final bool isHidePassword;
  const AuthState(
      {this.phone = "",
      this.user,
      this.password = "",
      this.messageError = "",
      this.status = AuthStatusBloc.initial,
      this.isHidePassword = true,
      this.currentLocation});

  AuthState copyWith({
    AuthStatusBloc? status,
    bool? isHidePassword,
    String? phone,
    UserModel? user,
    String? password,
    String? messageError,
    Position? currentLocation,
  }) {
    return AuthState(
      status: status ?? this.status,
      phone: phone ?? this.phone,
      user: user ?? this.user,
      password: password ?? this.password,
      messageError: messageError ?? this.messageError,
      isHidePassword: isHidePassword ?? this.isHidePassword,
      currentLocation: currentLocation ?? this.currentLocation,
    );
  }

  @override
  List<Object?> get props => [
        status,
        user,
        isHidePassword,
        phone,
        messageError,
        password,
        currentLocation,
      ];
}
