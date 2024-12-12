import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo/provider/Auth_Provider.dart';
import 'package:todo/ui/login/Login_Screen.dart';

class SplashScreen extends StatelessWidget {
  static const String routeName = 'splash';

  @override
  Widget build(BuildContext context) {
    var authProvider = Provider.of<AuthProvider>(context);
    Future.delayed(
      Duration(seconds: 3),
      () {
        Navigator.pushReplacementNamed(context, LoginScreen.routeName);
      },
    );
    return Scaffold(
      body: Center(
        child: Image.asset('assets/images/logo.png'),
      ),
    );
  }
}
