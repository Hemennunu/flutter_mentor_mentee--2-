import 'package:shared_preferences/shared_preferences.dart';

class TokenManager {
  final SharedPreferences _prefs;
  static const String _tokenKey = 'auth_token';

  TokenManager(this._prefs);

  String? get token => _prefs.getString(_tokenKey);

  Future<String?> getToken() async {
    return _prefs.getString(_tokenKey);
  }

  Future<void> saveToken(String token) async {
    await _prefs.setString(_tokenKey, token);
  }

  Future<void> clearToken() async {
    await _prefs.remove(_tokenKey);
  }
}