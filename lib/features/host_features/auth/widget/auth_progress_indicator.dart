import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:teamstreakpromo/gen/colors.gen.dart';
import 'package:teamstreakpromo/helpers/ui_helpers.dart';

class AuthProgressIndicator extends StatelessWidget {
  final int currentStep;
  final int totalSteps;

  const AuthProgressIndicator({
    super.key,
    required this.currentStep,
    required this.totalSteps,
  });

  @override
  Widget build(BuildContext context) {
    final gradient = LinearGradient(
      colors: [
        AppColors.primaryColorFirst,
        AppColors.primaryColorSecond,
      ],
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
    );

    return Row(
      children: [
        // Progress Bar Track and Filled Portion
        Expanded(
          child: Stack(
            children: [
              // Track Background
              Container(
                height: 12.h,
                decoration: BoxDecoration(
                  color: AppColors.c242A34,
                  borderRadius: BorderRadius.circular(100.r),
                ),
              ),
              // Filled Progress
              LayoutBuilder(
                builder: (context, constraints) {
                  final progressWidth =
                      constraints.maxWidth * (currentStep / totalSteps);
                  return Container(
                    height: 12.h,
                    width: progressWidth,
                    decoration: BoxDecoration(
                      gradient: gradient,
                      borderRadius: BorderRadius.circular(100.r),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
        UIHelper.horizontalSpace(12),
        // Step Indicator Pill
        Container(
          height: 28.h,
          padding: EdgeInsets.symmetric(horizontal: 14.w),
          decoration: BoxDecoration(
            gradient: gradient,
            borderRadius: BorderRadius.circular(100.r),
          ),
          alignment: Alignment.center,
          child: Text(
            "$currentStep/$totalSteps",
            style: TextStyle(
              fontFamily: "SF Pro Rounded",
              fontSize: 13.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.c262824, // Dark text matching button text style
            ),
          ),
        ),
      ],
    );
  }
}
