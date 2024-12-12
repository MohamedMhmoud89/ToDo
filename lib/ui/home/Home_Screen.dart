import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo/provider/Setting_Provider.dart';
import 'package:todo/ui/fragment/lists/Lists_Fragment.dart';
import 'package:todo/ui/fragment/settings/Settings_Fragment.dart';
import 'package:todo/ui/home/Add_Task_BottomSheet.dart';
import 'package:todo/ui/login/Login_Screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HomeScreen extends StatefulWidget {
  static const String routeName = 'home';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    var settingProvider = Provider.of<SettingProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Text(AppLocalizations.of(context)!.title),
        ),
        actions: [
          IconButton(
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.pushReplacementNamed(context, LoginScreen.routeName);
            },
            icon: Icon(
              Icons.login_rounded,
              size: 32,
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showAddTasksModelSheet();
        },
        child: Icon(
          Icons.add_rounded,
          size: 32,
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: settingProvider.currentTheme == ThemeMode.light
            ? Colors.white
            : Color(0xff141922),
        shape: CircularNotchedRectangle(),
        notchMargin: 12,
        child: BottomNavigationBar(
            unselectedItemColor: settingProvider.currentTheme == ThemeMode.light
                ? Color(0xffC8C9CB)
                : Color(0xffC8C9CB),
            backgroundColor: Colors.transparent,
            elevation: 0,
            onTap: (newCurrentIndex) {
              currentIndex = newCurrentIndex;
              setState(() {});
            },
            currentIndex: currentIndex,
            items: [
              BottomNavigationBarItem(
                  icon: Icon(
                    Icons.list_rounded,
                    size: 32,
                  ),
                  label: AppLocalizations.of(context)!.lists),
              BottomNavigationBarItem(
                  icon: Icon(
                    Icons.settings,
                    size: 32,
                  ),
                  label: AppLocalizations.of(context)!.setting),
            ]),
      ),
      body: fragment[currentIndex],
    );
  }

  void showAddTasksModelSheet() {
    showModalBottomSheet(
      context: context,
      builder: (context) => AddTaskBottomSheet(),
    );
  }

  List<Widget> fragment = [ListsFragment(), SettingsFragment()];
}
