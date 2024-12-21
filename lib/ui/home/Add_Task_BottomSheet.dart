import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:todo/database/Tasks_Dao.dart';
import 'package:todo/database/model/Task.dart';
import 'package:todo/provider/Auth_Provider.dart';
import 'package:todo/provider/Setting_Provider.dart';
import 'package:todo/ui/component/Custom_FormField.dart';
import 'package:todo/utils/Dialog_Utils.dart';

class AddTaskBottomSheet extends StatefulWidget {
  @override
  State<AddTaskBottomSheet> createState() => _AddTaskBottomSheetState();
}

class _AddTaskBottomSheetState extends State<AddTaskBottomSheet> {
  TextEditingController taskTitle = TextEditingController();

  TextEditingController taskDisc = TextEditingController();

  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var settingProvider = Provider.of<SettingProvider>(context);
    return SingleChildScrollView(
      child: Container(
        decoration: BoxDecoration(
          color: settingProvider.currentTheme == ThemeMode.light
              ? Colors.white
              : Color(0xff141922),
          borderRadius: new BorderRadius.only(
            topLeft: const Radius.circular(15.0),
            topRight: const Radius.circular(15.0),
          ),
        ),
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 44),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              Text(
                AppLocalizations.of(context)!.addTask,
                style: GoogleFonts.poppins(
                    textStyle: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 18,
                  color: settingProvider.currentTheme == ThemeMode.light
                      ? Colors.black
                      : Colors.white,
                )),
              ),
              SizedBox(
                height: height * 0.02,
              ),
              CustomFormField(
                  controller: taskTitle,
                  keyboardType: TextInputType.text,
                  label: AppLocalizations.of(context)!.taskTitle,
                  validator: (text) {
                    if (text == null || text.trim().isEmpty) {
                      return AppLocalizations.of(context)!.pleaseEnterTaskTitle;
                    }
                    return null;
                  }),
              CustomFormField(
                controller: taskDisc,
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
                    color: settingProvider.currentTheme == ThemeMode.light
                        ? Colors.black
                        : Colors.white,
                  ))),
              SizedBox(
                height: height * 0.02,
              ),
              GestureDetector(
                onTap: () {
                  showTaskDatePicker();
                },
                child: Text(
                    selectedDate == null
                        ? AppLocalizations.of(context)!.selectedDate
                        : "${selectedDate?.day}/${selectedDate?.month}/${selectedDate?.year}",
                    style: GoogleFonts.poppins(
                        textStyle: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 16,
                      color: settingProvider.currentTheme == ThemeMode.light
                          ? Colors.black
                          : Colors.white,
                    ))),
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
                    addTask();
                  },
                  child: Text(AppLocalizations.of(context)!.addTaskBtn,
                      style: GoogleFonts.poppins(
                          textStyle: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                      )))),
            ],
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

  void addTask() async {
    if (!isValidForm()) return;
    var authProvider = Provider.of<AuthProvider>(context, listen: false);
    Task task = Task(
      title: taskTitle.text,
      description: taskDisc.text,
      dateTime: Timestamp.fromMillisecondsSinceEpoch(
          selectedDate!.millisecondsSinceEpoch),
    );
    DialogUtils.showLoadingDialog(
        context, AppLocalizations.of(context)!.createTask);
    await TasksDao.createTask(task, authProvider.currentUser!.id!);
    DialogUtils.hideDialog(context);
    Navigator.pop(context);
  }

  DateTime? selectedDate;

  void showTaskDatePicker() async {
    var date = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 365)),
    );
    selectedDate = date;
    showDateError = false;
    setState(() {});
  }
}
