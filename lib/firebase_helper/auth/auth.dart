import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Auth {
  Future<void> signup(String email, String password) async {
    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      print(e);
      //showAlertDialog(context, "Invalid Input", e.code);
    } catch (e) {
      //print("something bad happened");
      //print(e.runtimeType); //this will give the type of exception that occured
      //print(e);
    } finally {}
  }

  Future<void> signin() async {}
}

class AuthService {
  static const String _loggedInKey = 'loggedIn';

  // Check if the user is logged in
  static Future<bool> isLoggedIn() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_loggedInKey) ?? false;
  }

  // Log in the user
  static Future<void> logIn() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_loggedInKey, true);
  }

  // Log out the user
  static Future<void> logOut() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_loggedInKey, false);
  }
}
