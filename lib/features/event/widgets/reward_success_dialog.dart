import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:teamstreakpromo/common_widgets/custom_gradient_button.dart';
import 'package:teamstreakpromo/constants/text_font_style.dart';
import 'package:teamstreakpromo/gen/colors.gen.dart';
import 'package:teamstreakpromo/helpers/ui_helpers.dart';

class RewardSuccessDialog extends StatelessWidget {
  final String rewardTitle;

  const RewardSuccessDialog({
    super.key,
    required this.rewardTitle,
  });

  @override
  Widget build(BuildContext context) {
    const gradient = LinearGradient(
      colors: [AppColors.primaryColorFirst, AppColors.primaryColorSecond],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );

    return AlertDialog(
      backgroundColor: const Color(0xFF1E222B),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.r),
      ),
      contentPadding: EdgeInsets.all(24.w),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 72.w,
            height: 72.w,
            decoration: const BoxDecoration(
              gradient: gradient,
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.check_rounded, color: Colors.black, size: 40.w),
          ),
          UIHelper.verticalSpace(24),
          Text(
            "Reward Redeemed!",
            style: TextFontStyle.textStyle24cFFFFFFSFPro590.copyWith(
              fontSize: 22.sp,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          UIHelper.verticalSpace(12),
          Text(
            "You have successfully redeemed\n$rewardTitle.",
            style: TextFontStyle.textStyle14cFFFFFFSFProRounded400.copyWith(
              color: Colors.white.withValues(alpha: 0.8),
              height: 1.4,
              fontSize: 14.sp,
            ),
            textAlign: TextAlign.center,
          ),
          UIHelper.verticalSpace(32),
          SizedBox(
            width: double.infinity,
            child: CustomGradientButton(
              onPressed: () => Navigator.pop(context),
              title: "Great!",
              borderRadius: BorderRadius.circular(100.r),
              textStyle: TextFontStyle.textStyle14cFFFFFFSFProRounded400.copyWith(
                color: const Color(0xFF262824),
                fontWeight: FontWeight.w700,
                fontSize: 16.sp,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
