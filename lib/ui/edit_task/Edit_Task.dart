import 'package:cloud_firestore_platform_interface/src/timestamp.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:todo/database/model/Task.dart';
import 'package:todo/provider/Auth_Provider.dart';
import 'package:todo/provider/Setting_Provider.dart';
import 'package:todo/ui/component/Custom_FormField.dart';

class EditTask extends StatefulWidget {
  static const String routeName = 'editTask';

  @override
  State<EditTask> createState() => _EditTaskState();
}

class _EditTaskState extends State<EditTask> {
  TextEditingController? taskTitle;

  TextEditingController? taskDisc;

  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    Task task = ModalRoute.of(context)?.settings.arguments as Task;
    var height = MediaQuery.of(context).size.height;
    DateTime? time = task.dateTime?.toDate();
    var settingProvider = Provider.of<SettingProvider>(context);
    var authProvider = Provider.of<AuthProvider>(context);
    if (taskTitle == null || taskDisc == null) {
      taskTitle = TextEditingController(text: task.title);
      taskDisc = TextEditingController(text: task.description);
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.title),
      ),
      body: Card(
        margin: EdgeInsets.symmetric(horizontal: 25, vertical: 80),
        child: Form(
          key: formKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  AppLocalizations.of(context)!.editTaskBtn,
                  style: GoogleFonts.poppins(
                      textStyle: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 18,
                          color: settingProvider.currentTheme == ThemeMode.light
                              ? Colors.black
                              : Colors.white)),
                ),
                SizedBox(
                  height: height * 0.02,
                ),
                CustomFormField(
                    controller: taskTitle!,
                    keyboardType: TextInputType.text,
                    label: AppLocalizations.of(context)!.taskTitle,
                    validator: (text) {
                      if (text == null || text.trim().isEmpty) {
                        return AppLocalizations.of(context)!
                            .pleaseEnterTaskTitle;
                      }
                      return null;
                    }),
                CustomFormField(
                  controller: taskDisc!,
                  label: AppLocalizations.of(context)!.taskDescription,
                  keyboardType: TextInputType.text,
                  validator: (text) {
                    if (text == null || text.trim().isEmpty) {
                      return AppLocalizations.of(context)!
                          .pleaseEnterTaskDescription;
                    }
                    return null;
                  },
                  lines: 4,
                ),
                SizedBox(
                  height: height * 0.02,
                ),
                Text(AppLocalizations.of(context)!.date,
                    style: GoogleFonts.poppins(
                        textStyle: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 16,
                            color:
                                settingProvider.currentTheme == ThemeMode.light
                                    ? Colors.black
                                    : Colors.white))),
                SizedBox(
                  height: height * 0.02,
                ),
                GestureDetector(
                  onTap: () {
                    showTaskDatePicker(task, time!);
                  },
                  child: Text(
                      selectedDate == null
                          ? "${time?.day}/${time?.month}/${time?.year}"
                          : "${selectedDate?.day}/${selectedDate?.month}/${selectedDate?.year}",
                      style: GoogleFonts.poppins(
                          textStyle: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 16,
                              color: settingProvider.currentTheme ==
                                      ThemeMode.light
                                  ? Colors.black
                                  : Colors.white))),
                ),
                showDateError
                    ? Text(AppLocalizations.of(context)!.pleaseSelectTaskDate,
                        style: GoogleFonts.poppins(
                            textStyle: TextStyle(
                          color: Theme.of(context).colorScheme.error,
                          fontWeight: FontWeight.w400,
                          fontSize: 12,
                        )))
                    : Text(""),
                SizedBox(
                  height: height * 0.02,
                ),
                ElevatedButton(
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      task.title = taskTitle?.text;
                      task.description = taskDisc?.text;
                      authProvider.editTask(task);
                    }
                    Navigator.pop(context);
                  },
                  child: Text(
                    AppLocalizations.of(context)!.editTaskBtn,
                    style: GoogleFonts.poppins(
                      textStyle: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  bool showDateError = false;

  bool isValidForm() {
    bool isValid = true;
    if (formKey.currentState?.validate() == false) {
      isValid = false;
    }
    if (selectedDate == null) {
      showDateError = true;
      setState(() {});
      isValid = false;
    }
    return isValid;
  }

  DateTime? selectedDate;

  void showTaskDatePicker(Task task, DateTime taskTime) {
    showDatePicker(
      context: context,
      initialDate: taskTime,
      firstDate: taskTime,
      lastDate: taskTime.add(Duration(days: 365)),
    ).then(
      (value) {
        if (value != null) {
          Timestamp timestampTime = Timestamp.fromDate(value);
          task.dateTime = timestampTime;
        }
      },
    );
    showDateError = false;
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    taskTitle?.dispose();
    taskDisc?.dispose();
  }
}
