import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo/database/Tasks_Dao.dart';
import 'package:todo/provider/Auth_Provider.dart';
import 'package:todo/provider/Setting_Provider.dart';
import 'package:todo/ui/widget/Task_Widget.dart';
import 'package:calendar_timeline/calendar_timeline.dart';

class ListsFragment extends StatefulWidget {
  @override
  State<ListsFragment> createState() => _ListsFragmentState();
}

class _ListsFragmentState extends State<ListsFragment> {
  DateTime selectedDate = DateTime.now();
  DateTime focasDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    var authProvider = Provider.of<AuthProvider>(context);
    var settingProvider = Provider.of<SettingProvider>(context);
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 25),
      child: Column(
        children: [
          CalendarTimeline(
            initialDate: focasDate,
            firstDate: DateTime.now().subtract(Duration(days: 365)),
            lastDate: DateTime.now().add(Duration(days: 365 * 4)),
            onDateSelected: (date) {
              selectedDate = date;
              focasDate = date;
              setState(() {});
            },
            leftMargin: 20,
            monthColor: settingProvider.currentTheme == ThemeMode.light
                ? Colors.black
                : Colors.white,
            dayColor: settingProvider.currentTheme == ThemeMode.light
                ? Colors.black
                : Colors.white,
            activeDayColor: Colors.white,
            activeBackgroundDayColor: Theme.of(context).primaryColor,
            locale:
                settingProvider.currentLanguage == Locale('en') ? 'en' : 'ar',
          ),
          SizedBox(
            height: 30,
          ),
          StreamBuilder(
            stream: TasksDao.listenForTasks(
                authProvider.currentUser!.id!, selectedDate),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (snapshot.hasError) {
                return Center(
                  child: Column(
                    children: [
                      Text("SomeThing went wrong. please try again"),
                      IconButton(
                          onPressed: () {}, icon: Icon(Icons.refresh_rounded))
                    ],
                  ),
                );
              }
              var tasksList = snapshot.data;
              return Expanded(
                child: ListView.separated(
                    itemBuilder: (context, index) => TaskWidget(
                          task: tasksList![index],
                        ),
                    separatorBuilder: (context, index) => SizedBox(
                          height: 20,
                        ),
                    itemCount: tasksList?.length ?? 0),
              );
            },
          )
        ],
      ),
    );
  }
}
