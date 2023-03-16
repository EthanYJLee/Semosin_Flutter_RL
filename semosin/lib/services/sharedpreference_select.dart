import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferenceSelect {
  Future<bool> selectStatus(String name) async {
    final pref = await SharedPreferences.getInstance();
    var result = pref.getBool(name) ?? false;
    return result;
  }

  Future<String> selectString(String name) async {
    final pref = await SharedPreferences.getInstance();
    var result = pref.getString(name) ?? "";
    return result;
  }
}
