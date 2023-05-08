import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:roadside_unit/service/location_service.dart';

import '../../../../core/helper/pref_manager.dart';
import '../../../../di/injector.dart';
import '../../../data/model/user/user_model.dart';
import '../../../data/resource/remote/request/login_user.dart';
import '../../../data/resource/remote/request/update_location.dart';
import '../../../domain/repository/auth_repository.dart';

part 'auth_state.dart';
part 'auth_event.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository;
  final LocationService _locationService;
  AuthBloc(
    this._authRepository,
    this._locationService,
  ) : super(const AuthState()) {
    on<AuthInit>(
      init,
    );
    /*  on<GetUserInfo>(
      getProfile,
    ); */
    on<LoginSubmitted>(
      loginSubmit,
    );
    on<LoginPasswordChanged>(
      loginPasswordChanged,
    );
    on<LoginPhoneChanged>(
      loginPhoneChanged,
    );
    on<HidePasswordChanged>(
      hidePasswordChange,
    );

    on<AuthLogout>(
      logoutSubmit,
    );
    on<AuthUnAuthenticated>(
      unauthenticated,
    );
    on<ExpiredToken>(
      expiredToken,
    );
    on<LocationEvent>(
      startTracking,
    );
    on<LocationChange>(
      locationChange,
    );
    on<GetUserInfo>(
      getProfile,
    );
  }
  StreamSubscription<Position>? _positionSubscription;
  Timer? timeListenLocation;
/* 
  void login(AuthEvent event, Emitter<AuthState> emit) async {
    final data = await _authLoginUseCase
        .execute(RequestLogin(phone: state.phone, password: state.password));

    if (data is DataSuccess && data.data != null) {}
    if (data is DataFailed) {}
  } */

  void loginSubmit(LoginSubmitted event, Emitter<AuthState> emit) async {
    emit(state.copyWith(
      status: AuthStatusBloc.loading,
    ));

    /* if (state.phone.length < 10) {
      emit(
        state.copyWith(
            status: AuthStatusBloc.failure,
            messageError: "Vui lòng kiểm tra đúng Số điện thoại"),
      );
      return;
    } */
    if (state.password.isEmpty) {
      emit(
        state.copyWith(
            status: AuthStatusBloc.failure,
            messageError: "Vui lòng điền đầy đủ mật khẩu"),
      );
      return;
    }

    final data = await _authRepository.login(LoginRequest(
      phone: state.phone,
      password: state.password,
    ));
    data.fold((l) {
      emit(state.copyWith(
        status: AuthStatusBloc.failure,
        messageError: l.error,
      ));
    }, (r) {
      injector<PrefManager>().token = r.token;
      emit(state.copyWith(
        status: AuthStatusBloc.authenticated,
        user: r,
      ));
    });
  }

  void getProfile(AuthEvent event, Emitter<AuthState> emit) async {
    emit(state.copyWith(
      status: AuthStatusBloc.loading,
    ));
    final data = await _authRepository.getProfile();
    data.fold((l) {
      emit(state.copyWith(
        status: AuthStatusBloc.failure,
        messageError: l.error,
      ));
    }, (r) {
      emit(state.copyWith(
        user: r,
      ));
    });
  }

  void unauthenticated(AuthUnAuthenticated event, Emitter<AuthState> emit) {
    emit(state.copyWith(
      status: AuthStatusBloc.unauthenticated,
    ));
  }

  void expiredToken(ExpiredToken event, Emitter<AuthState> emit) {
    emit(state.copyWith(
      status: AuthStatusBloc.expiredToken,
    ));
  }

  void logoutSubmit(AuthLogout event, Emitter<AuthState> emit) async {
    final data = await _authRepository.logout();
    print(data);
    emit(state.copyWith(
      status: AuthStatusBloc.unauthenticated,
    ));
  }

  void init(AuthInit event, Emitter<AuthState> emit) async {
    add(LocationEvent());
  }

  void loginPhoneChanged(
      LoginPhoneChanged event, Emitter<AuthState> emit) async {
    emit(
      state.copyWith(
        phone: event.phone,
      ),
    );
  }

  void hidePasswordChange(
      HidePasswordChanged event, Emitter<AuthState> emit) async {
    emit(
      state.copyWith(isHidePassword: !state.isHidePassword),
    );
  }

  void loginPasswordChanged(
      LoginPasswordChanged event, Emitter<AuthState> emit) async {
    emit(
      state.copyWith(
        password: event.password,
      ),
    );
  }

  void listenUpdateLocation(
      ListenUpdateLocation event, Emitter<AuthState> emit) {
    timeListenLocation?.cancel();
    timeListenLocation = Timer.periodic(const Duration(seconds: 5), (timer) {
      add(UpdateLocation());
    });
  }

  Future<void> updateLocation(
      UpdateLocation event, Emitter<AuthState> emit) async {
    final data = await _authRepository.updateLocation(UpdateLocationRequest(
        lat: state.currentLocation?.latitude ?? 0.0,
        lng: state.currentLocation?.longitude ?? 0.0));
    data.fold((l) {
      print(l.error);
    }, (r) {
      print(r);
      print("update thanh cong");
    });
  }

  void startTracking(LocationEvent event, Emitter<AuthState> emit) async {
    _positionSubscription?.cancel();
    _positionSubscription = await _locationService.createNumberStream();
    _positionSubscription?.onData((data) {
      if (state.currentLocation?.latitude != data.latitude &&
          state.currentLocation?.longitude != data.longitude) {
        print(data.latitude);
        add(LocationChange(data));
      }
    });
    _positionSubscription?.onError((data) {
      _positionSubscription?.cancel();
    });
  }

  void locationChange(LocationChange event, Emitter<AuthState> emit) async {
    final data = await _authRepository.updateLocation(UpdateLocationRequest(
        lat: event.position.latitude, lng: event.position.longitude));
    data.fold((l) {
      print(l.error);
    }, (r) {
      print(r);
      print("update thanh cong");
    });
    emit(state.copyWith(
      currentLocation: event.position,
    ));
  }
}
