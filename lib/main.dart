import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo/firebase/firebase_options.dart';
import 'package:todo/provider/Auth_Provider.dart';
import 'package:todo/provider/Setting_Provider.dart';
import 'package:todo/sharedPreferences/SharedPrefs.dart';
import 'package:todo/ui/edit_task/Edit_Task.dart';
import 'package:todo/ui/home/Home_Screen.dart';
import 'package:todo/ui/login/Login_Screen.dart';
import 'package:todo/ui/register/Register_Screen.dart';
import 'package:todo/ui/reset_password/Reset_Password.dart';
import 'package:todo/ui/splash/Splash_Screen.dart';
import 'package:todo/ui/theme/My_Theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  SharedPrefs.prefs = await SharedPreferences.getInstance();
  runApp(
    MultiProvider(providers: [
      ChangeNotifierProvider(
        create: (context) => AuthProvider(),
      ),
      ChangeNotifierProvider(
        create: (context) => SettingProvider()..init(),
      ),
    ], child: const MyApp()),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<SettingProvider>(context);
    return MaterialApp(
      theme: MyTheme().light,
      darkTheme: MyTheme().dark,
      themeMode: provider.currentTheme,
      routes: {
        SplashScreen.routeName: (_) => SplashScreen(),
        RegisterScreen.routeName: (_) => RegisterScreen(),
        LoginScreen.routeName: (_) => LoginScreen(),
        HomeScreen.routeName: (_) => HomeScreen(),
        EditTask.routeName: (_) => EditTask(),
        ResetPassword.routeName: (_) => ResetPassword()
      },
      initialRoute: SplashScreen.routeName,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en'), // English
        Locale('ar'), // Arabic
      ],
      locale: provider.currentLanguage,
      debugShowCheckedModeBanner: false,
    );
  }
}
