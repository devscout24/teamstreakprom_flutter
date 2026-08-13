import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:teamstreakpromo/gen/colors.gen.dart';
import 'package:teamstreakpromo/helpers/ui_helpers.dart';
import 'package:teamstreakpromo/common_widgets/app_network_image.dart';
import 'package:teamstreakpromo/common_widgets/custom_app_bar.dart';
import 'package:teamstreakpromo/common_widgets/custom_gradient_button.dart';
import 'package:teamstreakpromo/common_widgets/gradient_container.dart';
import 'package:teamstreakpromo/features/host_employee_feature/profile/presentation/host_employee_profile_screen.dart';
import 'package:teamstreakpromo/constants/text_font_style.dart';
import 'package:teamstreakpromo/helpers/navigation_service.dart';
import 'package:teamstreakpromo/helpers/all_routes.dart';

class HostEmployeeSettingsScreen extends StatelessWidget {
  final VoidCallback? onBackTapped;

  const HostEmployeeSettingsScreen({super.key, this.onBackTapped});

  void _showLogOutBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return Container(
          padding: EdgeInsets.all(24.w),
          decoration: BoxDecoration(
            color: const Color(0xFF1E222B),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(24.r),
              topRight: Radius.circular(24.r),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              UIHelper.verticalSpace(8.h),
              Text(
                "Log Out",
                style: TextFontStyle.textStyle24cFFFFFFSFPro590.copyWith(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              UIHelper.verticalSpace(16.h),
              Text(
                "Are you sure you want log out from app.\nThis action cannot be undone.",
                textAlign: TextAlign.center,
                style: TextFontStyle.textStyle14cFFFFFFSFProRounded400.copyWith(
                  color: Colors.white.withValues(alpha: 0.7),
                  fontSize: 14.sp,
                  height: 1.5,
                ),
              ),
              UIHelper.verticalSpace(24.h),
              Divider(
                color: Colors.white.withValues(alpha: 0.1),
                thickness: 1.h,
              ),
              UIHelper.verticalSpace(24.h),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        height: 52.h,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(100.r),
                        ),
                        child: Center(
                          child: Text(
                            "Cancel",
                            style: TextFontStyle
                                .textStyle14cFFFFFFSFProRounded400
                                .copyWith(
                                  color: const Color(0xFF1E222B),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16.sp,
                                ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  UIHelper.horizontalSpace(16.w),
                  Expanded(
                    child: CustomGradientButton(
                      onPressed: () {
                        // TODO: Implement actual logout logic
                        NavigationService.navigateToReplacement(
                          Routes.chooseAccountTypeScreen,
                        );
                      },
                      title: "Log Out",
                      height: 52.h,
                      borderRadius: BorderRadius.circular(100.r),
                      textStyle: TextFontStyle.textStyle14cFFFFFFSFProRounded400
                          .copyWith(
                            color: const Color(0xFF1E211A),
                            fontWeight: FontWeight.w700,
                            fontSize: 16.sp,
                          ),
                    ),
                  ),
                ],
              ),
              UIHelper.verticalSpace(16.h),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldColor,
      appBar: CustomAppBar(
        title: "Profile",
        onBack: onBackTapped,
        showBackButton: onBackTapped != null,
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              UIHelper.verticalSpace(16.h),

              // Custom Container for Profile Summary
              GradientContainer(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
                borderRadius: BorderRadius.circular(20.r),
                child: Row(
                  children: [
                    Container(
                      width: 60.w,
                      height: 60.w,
                      decoration: const BoxDecoration(shape: BoxShape.circle),
                      clipBehavior: Clip.hardEdge,
                      child: const AppNetworkImage(
                        imageUrl:
                            "https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?auto=format&fit=crop&w=200&q=80",
                        borderRadius: BorderRadius.all(Radius.circular(100)),
                      ),
                    ),
                    UIHelper.horizontalSpace(16.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Lila Rose",
                            style: TextStyle(
                              fontFamily: "SF Pro Rounded",
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                          UIHelper.verticalSpace(4.h),
                          Text(
                            "lilarose@example.com",
                            style: TextStyle(
                              fontFamily: "SF Pro Rounded",
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w400,
                              color: Colors.white.withValues(alpha: 0.7),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              UIHelper.verticalSpace(24.h),

              Text(
                "Profile & Security",
                style: TextStyle(
                  fontFamily: "SF Pro Rounded",
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),

              UIHelper.verticalSpace(16.h),

              // Account Settings Button
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const HostEmployeeProfileScreen(),
                    ),
                  );
                },
                child: GradientContainer(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 16.h,
                  ),
                  borderRadius: BorderRadius.circular(20.r),
                  child: Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(8.w),
                        decoration: const BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFFF28F31), Color(0xFF72E84F)],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.person,
                          color: Colors.black.withValues(alpha: 0.8),
                          size: 20.w,
                        ),
                      ),
                      UIHelper.horizontalSpace(16.w),
                      Expanded(
                        child: Text(
                          "Account Settings",
                          style: TextStyle(
                            fontFamily: "SF Pro Rounded",
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Icon(
                        Icons.chevron_right,
                        color: Colors.white.withValues(alpha: 0.7),
                        size: 24.w,
                      ),
                    ],
                  ),
                ),
              ),

              Spacer(),

              // Log Out Button
              CustomGradientButton(
                onPressed: () => _showLogOutBottomSheet(context),
                title: "Log Out",
              ),

              UIHelper.verticalSpace(24.h),
            ],
          ),
        ),
      ),
    );
  }
}
