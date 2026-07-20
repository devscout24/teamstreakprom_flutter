import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:teamstreakpromo/gen/colors.gen.dart';

class WizardProgressIndicator extends StatelessWidget {
  final int currentStep; // 1 to 5
  final int totalSteps;  // 5

  const WizardProgressIndicator({
    super.key,
    required this.currentStep,
    this.totalSteps = 5,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(totalSteps, (index) {
        final stepIndex = index + 1;
        final isActive = stepIndex <= currentStep;

        return Expanded(
          child: Container(
            height: 6.h,
            margin: EdgeInsets.symmetric(horizontal: 3.w),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(3.r),
              color: isActive
                  ? AppColors.primaryColorSecond // Lime-Green active color
                  : const Color(0xFF242A34),    // Inactive dark gray
            ),
          ),
        );
      }),
    );
  }
}
