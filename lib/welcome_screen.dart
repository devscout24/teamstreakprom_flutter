import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:teamstreakpromo/helpers/ui_helpers.dart';
import 'constants/text_font_style.dart';
import 'gen/assets.gen.dart';
import 'gen/colors.gen.dart';

final class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppColors.primaryColorFirst, AppColors.primaryColorSecond],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            const Spacer(flex: 6),
            Image.asset(
              Assets.icons.splashLogo.path,
              height: 120.h,
              fit: BoxFit.contain,
            ),
            UIHelper.verticalSpace(16),
            Text(
              "Rooted in community",
              style: TextFontStyle.textStyle20c232421SFPro590,
            ),
            const Spacer(flex: 1),
          ],
        ),
      ),
    );
  }
}
