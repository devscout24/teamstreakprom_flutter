import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RewardWizardProgressIndicator extends StatelessWidget {
  final int currentStep; // 1 to 3
  final int totalSteps; // 3

  const RewardWizardProgressIndicator({
    super.key,
    required this.currentStep,
    this.totalSteps = 3,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(totalSteps, (index) {
        final stepIndex = index + 1;
        final isActive = stepIndex <= currentStep;

        return Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            child: Container(
              height: 12.h,
              decoration: BoxDecoration(
                color: isActive
                    ? const Color(0xFF72E84F) // Bright Green
                    : const Color(0xFFE2F0DD), // Faded green as per design
                borderRadius: BorderRadius.circular(100.r),
              ),
            ),
          ),
        );
      }),
    );
  }
}
