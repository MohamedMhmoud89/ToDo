import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:todo/database/Tasks_Dao.dart';
import 'package:todo/database/model/Task.dart';
import 'package:todo/provider/Auth_Provider.dart';
import 'package:todo/provider/Setting_Provider.dart';
import 'package:todo/ui/edit_task/Edit_Task.dart';
import 'package:todo/utils/Dialog_Utils.dart';

class TaskWidget extends StatefulWidget {
  @override
  State<TaskWidget> createState() => _TaskWidgetState();
  Task task;

  TaskWidget({
    required this.task,
  });
}

class _TaskWidgetState extends State<TaskWidget> {
  @override
  Widget build(BuildContext context) {
    var settingProvider = Provider.of<SettingProvider>(context);
    var authProvider = Provider.of<AuthProvider>(context);
    return Slidable(
      startActionPane: widget.task.isDone
          ? ActionPane(
              motion: const StretchMotion(),
              // All actions are defined in the children parameter.
              children: [
                // A SlidableAction can have an icon and/or a label.
                SlidableAction(
                  onPressed: (context) {
                    deleteTask();
                  },
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  icon: Icons.delete_rounded,
                  label: AppLocalizations.of(context)!.delete,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12),
                    bottomLeft: Radius.circular(12),
                    bottomRight: Radius.circular(12),
                    topRight: Radius.circular(12),
                  ),
                ),
              ],
            )
          : ActionPane(
              motion: const StretchMotion(),
              // All actions are defined in the children parameter.
              children: [
                // A SlidableAction can have an icon and/or a label.
                SlidableAction(
                  onPressed: (context) {
                    deleteTask();
                  },
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  icon: Icons.delete_rounded,
                  label: AppLocalizations.of(context)!.delete,
                  borderRadius: BorderRadius.only(
                    topLeft: settingProvider.currentLanguage == Locale('en')
                        ? Radius.circular(12)
                        : Radius.circular(0),
                    bottomLeft: settingProvider.currentLanguage == Locale('en')
                        ? Radius.circular(12)
                        : Radius.circular(0),
                    bottomRight: settingProvider.currentLanguage == Locale('en')
                        ? Radius.circular(0)
                        : Radius.circular(12),
                    topRight: settingProvider.currentLanguage == Locale('en')
                        ? Radius.circular(0)
                        : Radius.circular(12),
                  ),
                ),
                SlidableAction(
                  onPressed: (context) {
                    Navigator.pushNamed(context, EditTask.routeName,
                        arguments: widget.task);
                  },
                  backgroundColor: Colors.blueAccent,
                  foregroundColor: Colors.white,
                  icon: Icons.edit_rounded,
                  label: AppLocalizations.of(context)!.edit,
                  borderRadius: BorderRadius.only(
                    topLeft: settingProvider.currentLanguage == Locale('en')
                        ? Radius.circular(0)
                        : Radius.circular(12),
                    bottomLeft: settingProvider.currentLanguage == Locale('en')
                        ? Radius.circular(0)
                        : Radius.circular(12),
                    bottomRight: settingProvider.currentLanguage == Locale('en')
                        ? Radius.circular(12)
                        : Radius.circular(0),
                    topRight: settingProvider.currentLanguage == Locale('en')
                        ? Radius.circular(12)
                        : Radius.circular(0),
                  ),
                ),
              ],
            ),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Color(0xffCCCCCC).withOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 5,
                offset: Offset(0, 0), // changes position of shadow
              ),
            ],
            borderRadius: BorderRadius.circular(12),
            color: settingProvider.currentTheme == ThemeMode.light
                ? Colors.white
                : Color(0xff141922)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  height: 62,
                  width: 4,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: widget.task.isDone
                        ? Color(0xff61E757)
                        : Theme.of(context).primaryColor,
                  ),
                ),
                SizedBox(
                  width: 16,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.task.title ?? "",
                        style: GoogleFonts.poppins(
                          textStyle: TextStyle(
                              color: widget.task.isDone
                                  ? Color(0xff61E757)
                                  : Theme.of(context).primaryColor,
                              fontWeight: FontWeight.w700,
                              fontSize: 18),
                        )),
                    SizedBox(
                      height: 6,
                    ),
                    Text(widget.task.description ?? "",
                        style: GoogleFonts.roboto(
                          textStyle: TextStyle(
                              color: settingProvider.currentTheme ==
                                      ThemeMode.light
                                  ? Color(0xff363636)
                                  : Colors.white,
                              fontWeight: FontWeight.w400,
                              fontSize: 12),
                        ))
                  ],
                ),
              ],
            ),
            widget.task.isDone
                ? Text(
                    AppLocalizations.of(context)!.doneTask,
                    style: GoogleFonts.poppins(
                        textStyle: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 22,
                            color: Color(0xff61E757))),
                  )
                : ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                    onPressed: () {
                      widget.task.isDone = true;
                      authProvider.editTask(widget.task);
                    },
                    child: Icon(
                      Icons.check_rounded,
                      size: 32,
                    ))
          ],
        ),
      ),
    );
  }

  void deleteTask() {
    DialogUtils.showMessage(context, AppLocalizations.of(context)!.deleteTask,
        postActionName: AppLocalizations.of(context)!.yes,
        postAction: () => deleteTaskFromFireStore(),
        negActionName: AppLocalizations.of(context)!.no);
  }

  void deleteTaskFromFireStore() async {
    var authProvider = Provider.of<AuthProvider>(context, listen: false);
    await TasksDao.removeTask(widget.task.id!, authProvider.currentUser!.id!);
  }
}
