import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../gen/colors.gen.dart';
import '../gen/assets.gen.dart';
import '../helpers/ui_helpers.dart';
import '../constants/text_font_style.dart';

class GoogleLoginButton extends StatelessWidget {
  final VoidCallback onTap;

  const GoogleLoginButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: const Color(0xFF1E222B),
          borderRadius: BorderRadius.circular(100.r),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.05),
            width: 1.w,
          ),
        ),
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(vertical: 16.h),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100.r),
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                AppColors.primaryColorFirst.withValues(alpha: 0.1),
                AppColors.primaryColorSecond.withValues(alpha: 0.1),
              ],
              stops: const [-0.375, 1.2411],
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                Assets.icons.googleLogo.path,
                width: 20.w,
                height: 20.w,
              ),
              UIHelper.horizontalSpace(12),
              Text(
                "Continue With Google",
                style: TextFontStyle.textStyle16cFFFFFFDMSans600.copyWith(
                  fontFamily: "SF Pro",
                  color: AppColors.cFFFFFF.withValues(alpha: 0.8),
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
