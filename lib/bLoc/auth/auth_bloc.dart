import 'package:ali_project_app/services/user_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../model/user_model.dart';
import '../../services/auth_service.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitial()) {
    on<AuthRegisterEvent>((event, emit) async {
      try {
        emit(AuthLoading());
        UserModel user = await AuthService().signUpUser(
          name: event.name,
          email: event.email,
          password: event.password,
          alamat: event.alamat,
          tanggalLahir: event.tanggalLahir,
          nomorHp: event.nomorHp,
          hobby: event.hobby,
        );
        emit(AuthSuccess(user));
      } catch (e) {
        emit(AuthFailed(e.toString()));
      }
    });

    on<AuthLoadDataUserEvent>((event, emit) async {
      try {
        emit(AuthLoading());
        UserModel user = await UserService().getUserById(event.idUser);
        emit(AuthSuccess(user));
      } catch (e) {
        emit(AuthFailed(e.toString()));
      }
    });

    on<AuthSignInEvent>((event, emit) async {
      try {
        emit(AuthLoading());
        UserModel user = await AuthService().signInUser(
          email: event.email,
          password: event.password,
        );
        emit(AuthSuccess(user));
      } catch (e) {
        emit(AuthFailed(e.toString()));
      }
    });

    on<AuthSignOutEvent>((event, emit) async {
      try {
        emit(AuthLoading());
        await AuthService().signOut();
        emit(AuthInitial());
      } catch (e) {
        emit(AuthFailed(e.toString()));
      }
    });

    on<AuthSignInWithGoogle>((event, emit) async {
      try {
        emit(AuthLoadingGoogle());
        UserModel user = await AuthService().signInWithGoogle();
        emit(AuthSuccess(user));
      } catch (e) {
        emit(AuthFailed(e.toString()));
      }
    });
  }
}
