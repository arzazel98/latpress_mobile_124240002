import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const String keyIsLoggedIn = 'is_logged_in';
  static const String keyUsername = 'logged_in_username';
  static const String requiredNim = '124240002';
  static const String requiredPassword = '123';

  static late SharedPreferences _prefs;

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static bool get isLoggedIn => _prefs.getBool(keyIsLoggedIn) ?? false;

  static String get username => _prefs.getString(keyUsername) ?? requiredNim;

  /// Melakukan validasi login
  /// Input username harus NIM (124240002) dan password 123
  static Future<bool> login(String inputUsername, String inputPassword) async {
    final cleanUser = inputUsername.trim();
    final cleanPass = inputPassword.trim();

    if (cleanUser == requiredNim && cleanPass == requiredPassword) {
      await _prefs.setBool(keyIsLoggedIn, true);
      await _prefs.setString(keyUsername, cleanUser);
      return true;
    }
    return false;
  }

  /// Logout: Menghapus session dari SharedPreferences
  static Future<void> logout() async {
    await _prefs.remove(keyIsLoggedIn);
    await _prefs.remove(keyUsername);
  }
}
