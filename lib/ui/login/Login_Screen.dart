import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:todo/database/Users_Dao.dart';
import 'package:todo/firebase/Firebase_Error_Codes.dart';
import 'package:todo/provider/Auth_Provider.dart' as MyAuthProvider;
import 'package:todo/provider/Setting_Provider.dart';
import 'package:todo/ui/component/Custom_FormField.dart';
import 'package:todo/ui/home/Home_Screen.dart';
import 'package:todo/ui/register/Register_Screen.dart';
import 'package:todo/utils/Dialog_Utils.dart';
import 'package:todo/utils/validation_utils.dart';

class LoginScreen extends StatefulWidget {
  static const String routeName = 'login';

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController email = TextEditingController();

  TextEditingController password = TextEditingController();

  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    var settingProvider = Provider.of<SettingProvider>(context);
    return Container(
      decoration: BoxDecoration(
          color: settingProvider.currentTheme == ThemeMode.light
              ? Color(0xffDFECDB)
              : Color(0xff060e1e),
          image: DecorationImage(
              image: AssetImage('assets/images/background.png'),
              fit: BoxFit.fill)),
      child: Container(
        child: Scaffold(
            appBar: AppBar(
              toolbarHeight: 50,
              backgroundColor: Colors.transparent,
              elevation: 0,
              actions: [
                TextButton(
                  onPressed: () {
                    settingProvider.currentLanguage == Locale('en')
                        ? settingProvider.changeLanguage(Locale('ar'))
                        : settingProvider.changeLanguage(Locale('en'));
                  },
                  child: settingProvider.currentLanguage == Locale('en')
                      ? Text(
                          "ع",
                          style: GoogleFonts.poppins(
                              textStyle: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                          )),
                        )
                      : Text(
                          "EN",
                          style: GoogleFonts.poppins(
                              textStyle:
                                  TextStyle(color: Colors.white, fontSize: 20)),
                        ),
                )
              ],
            ),
            backgroundColor: Colors.transparent,
            body: Padding(
              padding: EdgeInsets.symmetric(horizontal: 40),
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomFormField(
                      controller: email,
                      label: AppLocalizations.of(context)!.email,
                      validator: (text) {
                        if (text == null || text.trim().isEmpty) {
                          return "Please enter email";
                        }
                        if (!ValidationUtils.isValidEmail(text)) {
                          return "email bad format";
                        }
                        return null;
                      },
                      isPassword: false,
                      keyboardType: TextInputType.emailAddress,
                      lines: 1,
                    ),
                    CustomFormField(
                      controller: password,
                      label: AppLocalizations.of(context)!.password,
                      validator: (text) {
                        if (text == null || text.trim().isEmpty) {
                          return "Please enter password";
                        }
                        if (text.length < 8) {
                          return "Password should at least 8 chars";
                        }
                        return null;
                      },
                      isPassword: true,
                      keyboardType: TextInputType.visiblePassword,
                      lines: 1,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        login();
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            AppLocalizations.of(context)!.login,
                            style: GoogleFonts.poppins(
                              textStyle: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.w500),
                            ),
                          ),
                          Icon(Icons.arrow_forward_rounded)
                        ],
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xff3598DB),
                        padding:
                            EdgeInsets.symmetric(horizontal: 34, vertical: 14),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        Text(
                          AppLocalizations.of(context)!.dontHave,
                          style: TextStyle(
                              color: settingProvider.currentTheme ==
                                      ThemeMode.light
                                  ? Colors.black
                                  : Colors.white),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        GestureDetector(
                            onTap: () {
                              Navigator.pushReplacementNamed(
                                  context, RegisterScreen.routeName);
                            },
                            child: Text(
                              AppLocalizations.of(context)!.signUp,
                              style: GoogleFonts.poppins(
                                textStyle: TextStyle(
                                    color: Color(0xff5D9CEC),
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500),
                              ),
                            ))
                      ],
                    )
                  ],
                ),
              ),
            )),
      ),
    );
  }

  void login() async {
    if (formKey.currentState?.validate() == false) {
      return;
    }
    DialogUtils.showLoadingDialog(context, "Loading....");
    try {
      final result = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email.text, password: password.text);
      var user = await UsersDao.readUser(result.user!.uid);
      DialogUtils.hideDialog(context);
      if (user == null) {
        DialogUtils.showMessage(
          context,
          "error. can't find user in database",
          postActionName: 'Ok',
        );
        return;
      }
      var authProvider =
          Provider.of<MyAuthProvider.AuthProvider>(context, listen: false);
      authProvider.updateUser(user);
      DialogUtils.showMessage(
        context,
        'successful login',
        postActionName: 'Ok',
        postAction: () {
          Navigator.pushReplacementNamed(context, HomeScreen.routeName);
        },
      );
    } on FirebaseAuthException catch (e) {
      String errorMessage = "Something went wrong";
      DialogUtils.hideDialog(context);
      if (e.code == FirebaseErrorCodes.userNotFound) {
        errorMessage = 'No user found for that email.';
        DialogUtils.showMessage(context, errorMessage, postActionName: "Ok");
      } else if (e.code == FirebaseErrorCodes.wrongPassword) {
        errorMessage = 'Wrong password provided for that user.';
        DialogUtils.showMessage(context, errorMessage, postActionName: "Ok");
      } else {
        errorMessage = 'Something went wrong';
        DialogUtils.showMessage(
          context,
          errorMessage,
          postActionName: "Ok",
          negActionName: "Try Again",
          negAction: () => login(),
        );
      }
    }
  }
}
