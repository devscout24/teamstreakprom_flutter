import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../constants/text_font_style.dart';
import '../gen/colors.gen.dart';

class CustomGradientButton extends StatelessWidget {
  const CustomGradientButton({
    super.key,
    required this.onPressed,
    this.title,
    this.child,
    this.gradient,
    this.height,
    this.width,
    this.borderRadius,
    this.textStyle,
    this.border,
  });

  final VoidCallback? onPressed;
  final String? title;
  final Widget? child;
  final Gradient? gradient;
  final double? height;
  final double? width;
  final BorderRadiusGeometry? borderRadius;
  final TextStyle? textStyle;
  final BoxBorder? border;

  @override
  Widget build(BuildContext context) {
    final effectiveBorderRadius = borderRadius ?? BorderRadius.circular(26.r);

    return SizedBox(
      width: width ?? double.infinity,
      height: height ?? 50.h,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: border != null
              ? null
              : (gradient ??
                    LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        AppColors.primaryColorFirst.withValues(alpha: 0.85),

                        AppColors.primaryColorSecond.withValues(alpha: 0.85),
                      ],
                    )),
          border: border,
          borderRadius: effectiveBorderRadius,
        ),
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            shape: RoundedRectangleBorder(borderRadius: effectiveBorderRadius),
            padding: EdgeInsets.symmetric(horizontal: 16.w),
          ),
          child:
              child ??
              Text(
                title ?? '',
                style:
                    textStyle ??
                    TextFontStyle.textStyle16c000000SFPro590.copyWith(
                      fontWeight: FontWeight.w700,
                      color: border != null ? Colors.white : AppColors.c262824,
                    ),
                textAlign: TextAlign.center,
              ),
        ),
      ),
    );
  }
}
