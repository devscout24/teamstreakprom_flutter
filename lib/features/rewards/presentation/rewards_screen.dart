import 'package:flutter/material.dart';
import '../../../gen/colors.gen.dart';
import '../../../constants/text_font_style.dart';

class RewardsScreen extends StatelessWidget {
  const RewardsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldColor,
      body: Center(
        child: Text(
          "Rewards Screen",
          style: TextFontStyle.textStyle14cFFFFFFSFProRounded400.copyWith(
            color: Colors.white70,
            fontFamily: 'SF Pro',
          ),
        ),
      ),
    );
  }
}
