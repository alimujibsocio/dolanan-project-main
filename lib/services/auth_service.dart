import 'package:ali_project_app/services/user_service.dart';
import 'package:ali_project_app/view/pages/form/sign_in_page.dart';
import 'package:ali_project_app/view/pages/home_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/user_model.dart';

class AuthService {
  FirebaseAuth auth = FirebaseAuth.instance;

  /// Register user with email and password to firebase
  Future<UserModel> signUpUser({
    required String name,
    required String email,
    required String password,
    String tanggalLahir = '',
    String alamat = '',
    String nomorHp = '',
    String hobby = '',
  }) async {
    try {
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
          email: email, password: password);

      UserModel user = UserModel(
        id: userCredential.user!.uid,
        name: name,
        email: email,
        password: password,
        tanggalLahir: tanggalLahir,
        alamat: alamat,
        nomorHp: nomorHp,
        hobby: hobby,
      );

      await UserService().setUser(user);
      return user;
    } catch (e) {
      rethrow;
    }
  }

  /// Sign in user with email and password to firebase
  Future<UserModel> signInUser({
    required String email,
    required String password,
  }) async {
    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      UserModel user =
          await UserService().getUserById(userCredential.user!.uid);
      return user;
    } catch (e) {
      rethrow;
    }
  }

  /// Sign out with email and password
  Future<void> signOut() async {
    try {
      await auth.signOut();
    } catch (e) {
      rethrow;
    }
  }

  /// Sign in with google
  Future<UserModel> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      final googleAuth = await googleUser?.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      var akunGoogle =
          await FirebaseAuth.instance.signInWithCredential(credential);

      UserModel user = UserModel(
        id: akunGoogle.user!.uid,
        name: akunGoogle.user!.displayName ?? '',
        email: akunGoogle.user!.email ?? '',
        password: akunGoogle.user!.phoneNumber ?? '',
        photoUrl: akunGoogle.user!.photoURL ?? UserModel.defaultPhoto,
      );

      await UserService().setUser(user);

      return user;
    } catch (e) {
      rethrow;
    }
  }
}
