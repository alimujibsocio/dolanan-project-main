import 'package:cloud_firestore/cloud_firestore.dart';

import '../model/user_model.dart';

class UserService {
  final _userRefference = FirebaseFirestore.instance.collection("users");

  Future<void> setUser(UserModel user) async {
    try {
      _userRefference.doc(user.id).set({
        "id": user.id,
        "name": user.name,
        "email": user.email,
        "password": user.password,
        "date_birth": user.tanggalLahir,
        "address": user.alamat,
        "nomor_hp": user.nomorHp,
        "hobby": user.hobby,
        "photo_url": user.photoUrl,
      });
    } catch (e) {
      rethrow;
    }
  }

  Future<UserModel> getUserById(String id) async {
    try {
      DocumentSnapshot snapshot = await _userRefference.doc(id).get();
      return UserModel(
        id: id,
        name: snapshot["name"],
        email: snapshot["email"],
        password: snapshot["password"],
        tanggalLahir: snapshot["date_birth"],
        alamat: snapshot["address"],
        nomorHp: snapshot["nomor_hp"],
        hobby: snapshot["hobby"],
        photoUrl: snapshot["photo_url"],
      );
    } catch (e) {
      rethrow;
    }
  }
}
