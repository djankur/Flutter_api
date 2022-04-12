import 'package:shared_preferences/shared_preferences.dart';

class PrefService {
  Future createCache(String token) async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    pref.setString("token", token);
  }

  Future readCache(String token) async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    var cache = pref.getString("token");
    print(cache); //read token
    return cache;
  }

  Future removeCache(String token) async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    pref.remove("token");
  }
}
