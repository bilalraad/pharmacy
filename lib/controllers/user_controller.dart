import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:pharmacy/Data/local_database.dart';
import 'package:pharmacy/Data/models/user.dart';
import 'package:pharmacy/Data/user_repo.dart';

import 'controller_state.dart';

enum AuthState {
  init,
  authenticated,
  notAuthenticated,
}

class UserContoller extends GetxController {
  late UserRepository _userRepository;

  static UserContoller get to => Get.find();

  final _user = UserModel.init().obs;
  final _authState = AuthState.init.obs;
  final _controllerState = ControllerState.init.obs;

  AuthState get authState {
    return _authState.value;
  }

  ControllerState get controllerState {
    return _controllerState.value;
  }

  UserModel get user {
    return _user.value;
  }

  @override
  void onInit() async {
    super.onInit();
    _userRepository = UserRepository();

    FirebaseAuth.instance.currentUser;

    final localUser = await LocalDatabase.getUser();

    if (localUser != null) {
      _user.value = localUser;
      _updateState(AuthState.authenticated);
    } else {
      _updateState(AuthState.notAuthenticated);
    }
  }

  Future<void> signUp(String password, UserModel newUser) async {
    _updateControllerState(ControllerState.loading);
    try {
      _user.value = await _userRepository.signUp(password, newUser);
      _updateState(AuthState.authenticated);
      _updateControllerState(ControllerState.loaded);
    } catch (e) {
      _updateState(AuthState.notAuthenticated);
      _updateControllerState(ControllerState.loaded);
      rethrow;
    }
  }

  Future<void> logIn(String password, String email) async {
    _updateControllerState(ControllerState.loading);

    try {
      _user.value = await _userRepository.login(email, password);
      _updateState(AuthState.authenticated);
      _updateControllerState(ControllerState.loaded);
    } catch (e) {
      _updateState(AuthState.notAuthenticated);
      _updateControllerState(ControllerState.loaded);
      rethrow;
    }
  }

  Future<void> signOut() async {
    _updateControllerState(ControllerState.loading);

    try {
      _updateState(AuthState.notAuthenticated);
      await _userRepository.signOut();
      _updateControllerState(ControllerState.loaded);
    } catch (e) {
      _updateControllerState(ControllerState.loaded);
      rethrow;
    }
  }

  Future<void> resetPassword(String email) async {
    try {
      _updateControllerState(ControllerState.loading);

      await _userRepository.resetPassword(email);
      _updateControllerState(ControllerState.loaded);
    } catch (e) {
      _updateControllerState(ControllerState.loaded);

      rethrow;
    }
  }

  Future<void> updateUserData({required UserModel user, File? image}) async {
    try {
      _updateControllerState(ControllerState.loading);

      _user.value =
          await _userRepository.updateUserData(user: user, image: image);
      _updateControllerState(ControllerState.loaded);
    } catch (e) {
      _updateControllerState(ControllerState.loaded);

      rethrow;
    }
  }

  void _updateControllerState(ControllerState state) {
    _controllerState.value = state;
    update();
  }

  void _updateState(AuthState state) {
    _authState.value = state;
    update();
  }
}
