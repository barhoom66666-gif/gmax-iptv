import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mbark_iptv/repository/api/api.dart';
import 'package:mbark_iptv/repository/models/user.dart';

part 'auth_event.dart';

part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthApi authApi;

  AuthBloc(this.authApi) : super(AuthInitial()) {
    on<AuthRegister>((event, emit) async {
      emit(AuthLoading());

      final user = await authApi.registerUser(
        event.username,
        event.password,
        event.domain,
        event.accountName,
        event.typeLogin,
        event.addToPlayList,
      );

      if (user != null) {
        emit(AuthSuccess(user));
      } else {
        emit(AuthFailed("could not login!!"));
      }
    });

    on<AuthGetUser>((event, emit) async {
      emit(AuthLoading());

      final localeUser = await AuthLocale.getUser();

      if (localeUser != null) {
        emit(AuthSuccess(localeUser));
      } else {
        emit(AuthFailed("could not login!!"));
      }
    });

    on<AuthLogOut>((event, emit) async {
      await AuthLocale.logOut();
      emit(AuthFailed("LogOut"));
    });

    on<DeleteUserEvent>((event, emit) async {
      add(AuthLogOut(accountName: event.accountName));

      //TODO: delete all data user
      await AuthLocale.deleteUser(event.accountName);
      emit(AuthFailed("${event.accountName} deleted"));
    });
  }
}
