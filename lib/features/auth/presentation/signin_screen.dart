import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:teamstreakpromo/constants/text_font_style.dart';
import 'package:teamstreakpromo/gen/colors.gen.dart';

class SigninScreen extends StatelessWidget {
  const SigninScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.c000000,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "SF Pro Rounded",
            style: TextStyle(fontSize: 20.sp, fontFamily: "SF Pro Rounded"),
          ),

          Text(
            "SoundWave Music Festival",
            style: TextFontStyle.textStyle12cFFFFFFSFPro510,
          ),
        ],
      ),
    );
  }
}
