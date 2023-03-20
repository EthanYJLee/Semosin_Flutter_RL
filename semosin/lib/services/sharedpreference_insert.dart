import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferenceInsert {
  insertEmail(String email, emailStatus) async {
    final pref = await SharedPreferences.getInstance();

    final prefEmailStatus = pref.getBool("saemosin-email-status") ?? false;
    final prefEmail = pref.getString("saemosinemail") ?? "0";

    if (email != prefEmail) {
      pref.setString("saemosinemail", email);
    }

    if (emailStatus != prefEmailStatus) {
      pref.setBool("saemosin-email-status", true);
    }
  }

  insertEmailAndPassword(String email, password, autoLoginStatus) async {
    final pref = await SharedPreferences.getInstance();

    final prefAutoLoginStatus =
        pref.getBool("saemosin-auto-login-status") ?? false;
    final prefEmail = pref.getString("saemosinemail") ?? "0";
    final prefPw = pref.getString("saemosinpassword") ?? "0";

    if (email != prefEmail) {
      pref.setString("saemosinemail", email);
    }

    if (password != prefPw) {
      pref.setString("saemosinpassword", password);
    }

    if (autoLoginStatus != prefAutoLoginStatus) {
      pref.setBool("saemosin-auto-login-status", true);
    }
  }
}
