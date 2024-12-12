import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:todo/provider/Setting_Provider.dart';

class LanguageBottomSheet extends StatelessWidget {
  const LanguageBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    var settingProvider = Provider.of<SettingProvider>(context);
    return Container(
      padding: EdgeInsets.symmetric(vertical: 30, horizontal: 20),
      height: 250,
      decoration: BoxDecoration(
        color: settingProvider.currentTheme == ThemeMode.light
            ? Colors.white
            : Color(0xff141922),
        borderRadius: new BorderRadius.only(
          topLeft: const Radius.circular(15.0),
          topRight: const Radius.circular(15.0),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          GestureDetector(
              onTap: () {
                settingProvider.changeLanguage(Locale('ar'));
                Navigator.pop(context);
              },
              child: settingProvider.currentLanguage == Locale('ar')
                  ? languageSelected(AppLocalizations.of(context)!.arabic)
                  : languageUnSelected(
                      AppLocalizations.of(context)!.arabic, context)),
          SizedBox(
            height: 25,
          ),
          GestureDetector(
              onTap: () {
                settingProvider.changeLanguage(Locale('en'));
                Navigator.pop(context);
              },
              child: settingProvider.currentLanguage == Locale('en')
                  ? languageSelected(AppLocalizations.of(context)!.english)
                  : languageUnSelected(
                      AppLocalizations.of(context)!.english, context)),
        ],
      ),
    );
  }

  Widget languageSelected(String text) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          text,
          style: GoogleFonts.inter(
              textStyle: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 20,
                  color: Color(0xff5D9CEC))),
        ),
        Icon(Icons.check_rounded, size: 30, color: Color(0xff5D9CEC))
      ],
    );
  }

  Widget languageUnSelected(String text, context) {
    var settingProvider = Provider.of<SettingProvider>(context);
    return Text(
      text,
      style: GoogleFonts.inter(
          textStyle: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 20,
              color: settingProvider.currentTheme == ThemeMode.light
                  ? Color(0xff303030)
                  : Colors.white)),
    );
  }
}
