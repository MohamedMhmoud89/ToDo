import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:todo/provider/Setting_Provider.dart';

class SettingdWidget extends StatelessWidget {
  String title;
  String selected;

  SettingdWidget({required this.title, required this.selected});

  @override
  Widget build(BuildContext context) {
    var settingProvider = Provider.of<SettingProvider>(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          title,
          style: GoogleFonts.poppins(
            textStyle: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 14,
                color: settingProvider.currentTheme == ThemeMode.light
                    ? Color(0xff303030)
                    : Colors.white),
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 18),
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
              color: settingProvider.currentTheme == ThemeMode.light
                  ? Colors.white
                  : Color(0xff141922),
              border: Border.all(color: Color(0xff5D9CEC), width: 2)),
          child: Text(
            selected,
            style: GoogleFonts.inter(
              textStyle: TextStyle(
                  color: Color(0xff5D9CEC),
                  fontWeight: FontWeight.w400,
                  fontSize: 14),
            ),
          ),
        ),
      ],
    );
  }
}
