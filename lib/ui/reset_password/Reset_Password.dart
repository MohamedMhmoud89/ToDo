import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:todo/provider/Setting_Provider.dart';
import 'package:todo/ui/component/Custom_FormField.dart';
import 'package:todo/utils/Dialog_Utils.dart';
import 'package:todo/utils/validation_utils.dart';

class ResetPassword extends StatelessWidget {
  static const String routeName = 'reset';
  TextEditingController email = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var settingProvider = Provider.of<SettingProvider>(context);
    var formKey = GlobalKey<FormState>();
    return Container(
      decoration: BoxDecoration(
          color: settingProvider.currentTheme == ThemeMode.light
              ? Color(0xffDFECDB)
              : Color(0xff060e1e),
          image: DecorationImage(
              image: AssetImage('assets/images/background.png'),
              fit: BoxFit.fill)),
      child: Scaffold(
        backgroundColor: Colors.transparent,
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
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 40),
          child: Form(
            key: formKey,
            child: Column(
              spacing: 40,
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
                ElevatedButton(
                  onPressed: () async {
                    DialogUtils.showLoadingDialog(
                        context, AppLocalizations.of(context)!.wait);
                    await FirebaseAuth.instance
                        .sendPasswordResetEmail(email: email.text);
                    DialogUtils.hideDialog(context);
                    DialogUtils.showMessage(
                        context, AppLocalizations.of(context)!.sucsend,
                        postActionName: AppLocalizations.of(context)!.ok,
                        postAction: () {
                      Navigator.pop(context);
                    });
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.reset,
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
                    padding: EdgeInsets.symmetric(horizontal: 34, vertical: 14),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
