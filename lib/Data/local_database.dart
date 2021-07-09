import 'models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalDatabase {
  ///store user offline
  static Future<void> setUser({
    required UserModel user,
  }) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString('currentUser', user.toJson());
  }

  static Future<UserModel?> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey('currentUser')) {
      final userJson = prefs.getString('currentUser');
      return UserModel.fromJson(userJson!);
    } else {
      return null;
    }
  }

  static Future<void> deleteUser() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('currentUser');
  }
}
