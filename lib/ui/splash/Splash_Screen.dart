import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo/provider/Auth_Provider.dart';
import 'package:todo/ui/home/Home_Screen.dart';
import 'package:todo/ui/login/Login_Screen.dart';

class SplashScreen extends StatefulWidget {
  static const String routeName = 'splash';

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    Future.delayed(
      Duration(seconds: 3),
      () {
        checkLoggedInUser();
      },
    );
    return Scaffold(
      body: Center(
        child: Image.asset('assets/images/logo.png'),
      ),
    );
  }

  void checkLoggedInUser() async {
    var authProvider = Provider.of<AuthProvider>(context, listen: false);
    if (authProvider.isUserLoggedInBefor()) {
      await authProvider.autoLogin();
      Navigator.pushReplacementNamed(context, HomeScreen.routeName);
    } else {
      Navigator.pushReplacementNamed(context, LoginScreen.routeName);
    }
  }
}
