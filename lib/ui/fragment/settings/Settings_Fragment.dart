import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:todo/provider/Setting_Provider.dart';
import 'package:todo/ui/fragment/settings/Language_Bottom_Sheet.dart';
import 'package:todo/ui/fragment/settings/Settingd_Widget.dart';
import 'package:todo/ui/fragment/settings/Theme_Bottom_Sheet.dart';

class SettingsFragment extends StatefulWidget {
  @override
  State<SettingsFragment> createState() => _SettingsFragmentState();
}

class _SettingsFragmentState extends State<SettingsFragment> {
  @override
  Widget build(BuildContext context) {
    var settingProvider = Provider.of<SettingProvider>(context);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 38, vertical: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          GestureDetector(
              onTap: () => showLanguageBottomSheet(),
              child: SettingdWidget(
                  title: AppLocalizations.of(context)!.language,
                  selected: settingProvider.currentLanguage == Locale("en")
                      ? AppLocalizations.of(context)!.english
                      : AppLocalizations.of(context)!.arabic)),
          SizedBox(
            height: 40,
          ),
          GestureDetector(
              onTap: () => showThemeBottomSheet(),
              child: SettingdWidget(
                  title: AppLocalizations.of(context)!.theme,
                  selected: settingProvider.currentTheme == ThemeMode.light
                      ? AppLocalizations.of(context)!.light
                      : AppLocalizations.of(context)!.dark))
        ],
      ),
    );
  }

  void showLanguageBottomSheet() {
    showModalBottomSheet(
      context: context,
      builder: (context) => LanguageBottomSheet(),
    );
  }

  void showThemeBottomSheet() {
    showModalBottomSheet(
      context: context,
      builder: (context) => ThemeBottomSheet(),
    );
  }
}
