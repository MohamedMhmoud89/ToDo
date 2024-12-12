import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:todo/database/Users_Dao.dart';
import 'package:todo/database/model/User.dart' as MyUser;
import 'package:todo/firebase/Firebase_Error_Codes.dart';
import 'package:todo/provider/Setting_Provider.dart';
import 'package:todo/ui/component/Custom_FormField.dart';
import 'package:todo/ui/login/Login_Screen.dart';
import 'package:todo/utils/Dialog_Utils.dart';
import 'package:todo/utils/validation_utils.dart';

class RegisterScreen extends StatefulWidget {
  static const String routeName = 'register';

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  TextEditingController fullName = TextEditingController();

  TextEditingController email = TextEditingController();

  TextEditingController password = TextEditingController();

  TextEditingController confirmedPassword = TextEditingController();

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
                      controller: fullName,
                      label: AppLocalizations.of(context)!.fullName,
                      validator: (text) {
                        if (text == null || text.trim().isEmpty) {
                          return "Please enter fullName";
                        }
                        return null;
                      },
                      isPassword: false,
                      keyboardType: TextInputType.name,
                      lines: 1,
                    ),
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
                    CustomFormField(
                      controller: confirmedPassword,
                      label: AppLocalizations.of(context)!.passwordConfirm,
                      validator: (text) {
                        if (text == null || text.trim().isEmpty) {
                          return "Please enter password";
                        }
                        if (confirmedPassword.text != password.text) {
                          return "Password doesn't match";
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
                        createAccount();
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            AppLocalizations.of(context)!.createAccount,
                            style: GoogleFonts.poppins(
                              textStyle: TextStyle(
                                  color: Color(0xffBDBDBD),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                          Icon(
                            Icons.arrow_forward_rounded,
                            color: Color(0xffBDBDBD),
                          )
                        ],
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
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
                          AppLocalizations.of(context)!.alreadyHave,
                          style: GoogleFonts.poppins(
                            textStyle: TextStyle(
                                color: settingProvider.currentTheme ==
                                        ThemeMode.light
                                    ? Colors.black
                                    : Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        GestureDetector(
                            onTap: () {
                              Navigator.pushReplacementNamed(
                                  context, LoginScreen.routeName);
                            },
                            child: Text(
                              AppLocalizations.of(context)!.signIn,
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

  void createAccount() async {
    if (formKey.currentState?.validate() == false) {
      return;
    }
    DialogUtils.showLoadingDialog(context, "Loading....");
    try {
      var result = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email.text, password: password.text);
      var myUser = MyUser.User(
          id: result.user?.uid, name: fullName.text, email: email.text);
      await UsersDao.addUser(myUser);
      DialogUtils.hideDialog(context);
      DialogUtils.showMessage(
        context,
        'successful account creation',
        postActionName: 'Ok',
        postAction: () {
          Navigator.pushReplacementNamed(context, LoginScreen.routeName);
        },
      );
    } on FirebaseAuthException catch (e) {
      String errorMessage = "Something went wrong";
      DialogUtils.hideDialog(context);
      if (e.code == FirebaseErrorCodes.weakPassword) {
        errorMessage = 'The password provided is too weak.';
        DialogUtils.showMessage(context, errorMessage, postActionName: "Ok");
      } else if (e.code == FirebaseErrorCodes.emailInUse) {
        errorMessage = 'The account already exists for that email.';
        DialogUtils.showMessage(context, errorMessage, postActionName: "Ok");
      } else {
        String errorMessage = "Something went wrong";
        DialogUtils.hideDialog(context);
        DialogUtils.showMessage(context, errorMessage,
            postActionName: "Ok", negActionName: "Try Again", negAction: () {
          createAccount();
        });
      }
    } catch (e) {
      String errorMessage = "Something went wrong";
      DialogUtils.hideDialog(context);
      DialogUtils.showMessage(
        context,
        errorMessage,
        postActionName: "Ok",
        negActionName: "Try Again",
        negAction: () {
          createAccount();
        },
      );
    }
  }
}
