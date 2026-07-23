import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../common_widgets/custom_app_bar.dart';
import '../../../gen/assets.gen.dart';
import '../../../common_widgets/custom_back_button.dart';
import '../../../common_widgets/gradient_container.dart';
import '../../../constants/text_font_style.dart';
import '../../../gen/colors.gen.dart';
import '../../../helpers/ui_helpers.dart';

class NotificationSettingsScreen extends StatefulWidget {
  const NotificationSettingsScreen({super.key});

  @override
  State<NotificationSettingsScreen> createState() =>
      _NotificationSettingsScreenState();
}

class _NotificationSettingsScreenState
    extends State<NotificationSettingsScreen> {
  bool _isPushNotificationEnabled = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldColor,
      appBar: const CustomAppBar(title: "Notification Settings"),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Notification Settings",
              style: TextFontStyle.textStyle24cFFFFFFSFPro590.copyWith(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            UIHelper.verticalSpace(8.h),
            Text(
              "Choose how you'd like to stay informed.",
              style: TextFontStyle.textStyle14cFFFFFFSFProRounded400.copyWith(
                color: Colors.white.withValues(alpha: 0.6),
                fontSize: 13.sp,
              ),
            ),
            UIHelper.verticalSpace(32.h),

            // Push Notification Toggle Item
            GradientContainer(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Push Notification",
                    style: TextFontStyle.textStyle14cFFFFFFSFProRounded400
                        .copyWith(fontWeight: FontWeight.w500, fontSize: 15.sp),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _isPushNotificationEnabled =
                            !_isPushNotificationEnabled;
                      });
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: 50.w,
                      height: 28.h,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.r),
                        gradient: _isPushNotificationEnabled
                            ? const LinearGradient(
                                colors: [Color(0xFFD39A3D), Color(0xFF8DB741)],
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                              )
                            : null,
                        color: _isPushNotificationEnabled
                            ? null
                            : Colors.white.withValues(alpha: 0.2),
                      ),
                      child: AnimatedAlign(
                        duration: const Duration(milliseconds: 200),
                        curve: Curves.easeInOut,
                        alignment: _isPushNotificationEnabled
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                        child: Padding(
                          padding: EdgeInsets.all(2.w),
                          child: Container(
                            width: 24.w,
                            height: 24.w,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
