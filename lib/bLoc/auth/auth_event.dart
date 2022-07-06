part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class AuthRegisterEvent extends AuthEvent {
  final String name;
  final String email;
  final String password;
  final String tanggalLahir;
  final String alamat;
  final String nomorHp;
  final String hobby;

  const AuthRegisterEvent({
    required this.name,
    required this.email,
    required this.password,
    this.tanggalLahir = '',
    this.alamat = '',
    this.nomorHp = '',
    this.hobby = '',
  });

  @override
  List<Object> get props => [
        name,
        email,
        password,
        tanggalLahir,
        alamat,
        nomorHp,
        hobby,
      ];
}

class AuthSignInEvent extends AuthEvent {
  final String email;
  final String password;

  const AuthSignInEvent({required this.email, required this.password});

  @override
  List<Object> get props => [email, password];
}

class AuthSignOutEvent extends AuthEvent {}

class AuthSignInWithGoogle extends AuthEvent {}

class AuthLoadDataUserEvent extends AuthEvent {
  final String idUser;
  const AuthLoadDataUserEvent(this.idUser);

  @override
  List<Object> get props => [idUser];
}
