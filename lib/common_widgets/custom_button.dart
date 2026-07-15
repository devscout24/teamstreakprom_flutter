// lib/widgets/buttons/custom_button.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '/constants/text_font_style.dart';
import '/gen/colors.gen.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    required this.onPressed,
    required this.title,
    this.isLoading = false,
    this.backgroundColor,
    this.foregroundColor,
    this.borderRadius,
    this.height,
    this.width,
    this.textStyle,
    this.padding,
  });

  final VoidCallback? onPressed;
  final String title;
  final bool isLoading;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final BorderRadiusGeometry? borderRadius;
  final double? height;
  final double? width;
  final TextStyle? textStyle;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? double.infinity,
      height: height ?? 50.h,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor ?? AppColors.allPrimaryColor,
          foregroundColor: foregroundColor ?? AppColors.cFFFFFF,
          disabledBackgroundColor: 
              (backgroundColor ?? AppColors.allPrimaryColor).withOpacity(0.5),
          disabledForegroundColor: 
              (foregroundColor ?? AppColors.cFFFFFF).withOpacity(0.5),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: borderRadius ?? BorderRadius.circular(12.r),
          ),
          padding: padding ?? EdgeInsets.symmetric(horizontal: 16.w),
        ),
        child: isLoading
            ? SizedBox(
                width: 20.w,
                height: 20.h,
                child: CircularProgressIndicator(
                  strokeWidth: 2.w,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    foregroundColor ?? AppColors.cFFFFFF,
                  ),
                ),
              )
            : Text(
                title,
                style: textStyle ?? TextFontStyle.textStyle16cFFFFFFDMSans600,
                textAlign: TextAlign.center,
              ),
      ),
    );
  }
}

// Alternative function-style customButton (if you prefer function over class)
Widget customButton({
  required VoidCallback? onPressed,
  required String title,
  bool isLoading = false,
  Color? backgroundColor,
  Color? foregroundColor,
  BorderRadiusGeometry? borderRadius,
  double? height,
  double? width,
  TextStyle? textStyle,
  EdgeInsetsGeometry? padding,
}) {
  return SizedBox(
    width: width ?? double.infinity,
    height: height ?? 50.h,
    child: ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor ?? AppColors.allPrimaryColor,
        foregroundColor: foregroundColor ?? AppColors.cFFFFFF,
        disabledBackgroundColor: 
            (backgroundColor ?? AppColors.allPrimaryColor).withOpacity(0.5),
        disabledForegroundColor: 
            (foregroundColor ?? AppColors.cFFFFFF).withOpacity(0.5),
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: borderRadius ?? BorderRadius.circular(12.r),
        ),
        padding: padding ?? EdgeInsets.symmetric(horizontal: 16.w),
      ),
      child: isLoading
          ? SizedBox(
              width: 20.w,
              height: 20.h,
              child: CircularProgressIndicator(
                strokeWidth: 2.w,
                valueColor: AlwaysStoppedAnimation<Color>(
                  foregroundColor ?? AppColors.cFFFFFF,
                ),
              ),
            )
          : Text(
              title,
              style: textStyle ?? TextFontStyle.textStyle16cFFFFFFDMSans600,
              textAlign: TextAlign.center,
            ),
    ),
  );
}