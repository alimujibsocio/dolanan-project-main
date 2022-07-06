import 'package:equatable/equatable.dart';

class UserModel extends Equatable {
  static const String defaultPhoto =
      "https://firebasestorage.googleapis.com/v0/b/ali-mujib-project.appspot.com/o/default_username.png?alt=media&token=d722823e-ac52-4980-a5cc-f90de43ad697";

  final String id;
  final String name;
  final String email;
  final String password;
  final String tanggalLahir;
  final String alamat;
  final String nomorHp;
  final String hobby;
  final String photoUrl;

  const UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.password,
    this.tanggalLahir = '1900-01-01',
    this.alamat = 'Indonesia',
    this.nomorHp = '',
    this.hobby = '',
    this.photoUrl = defaultPhoto,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        email,
        password,
        tanggalLahir,
        alamat,
        nomorHp,
        hobby,
        photoUrl,
      ];
}
