import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../helpers/navigation_service.dart';
import '../gen/colors.gen.dart';
import '../constants/text_font_style.dart';

void customToastMessage(
  String title,
  String description, {
  bool isError = false,
}) {
  final context = NavigationService.navigatorKey.currentContext!;

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      behavior: SnackBarBehavior.floating,
      margin: EdgeInsets.only(bottom: 32.h, left: 16.w, right: 16.w),
      padding: EdgeInsets.zero,
      duration: const Duration(seconds: 4),
      content: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 15,
              spreadRadius: 2,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8.r),
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  width: 4.w,
                  color: isError
                      ? Colors.redAccent
                      : AppColors.primaryColorSecond,
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 12.h,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: EdgeInsets.only(top: 2.h),
                          child: Icon(
                            isError
                                ? Icons.error_outline
                                : Icons.check_circle_outline,
                            color: isError
                                ? Colors.redAccent
                                : AppColors.primaryColorSecond,
                            size: 20.sp,
                          ),
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                title,
                                style: TextFontStyle
                                    .textStyle14cFFFFFFSFProRounded400
                                    .copyWith(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14.sp,
                                      color: AppColors.c262824,
                                    ),
                              ),
                              SizedBox(height: 2.h),
                              Text(
                                description,
                                style: TextFontStyle
                                    .textStyle14cFFFFFFSFProRounded400
                                    .copyWith(
                                      fontSize: 13.sp,
                                      color: AppColors.c262824.withValues(
                                        alpha: 0.6,
                                      ),
                                    ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 12.w),
                        GestureDetector(
                          onTap: () {
                            ScaffoldMessenger.of(context).hideCurrentSnackBar();
                          },
                          child: Container(
                            margin: EdgeInsets.only(top: 2.h),
                            child: Icon(
                              Icons.close,
                              color: AppColors.c262824.withValues(alpha: 0.3),
                              size: 16.sp,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}
