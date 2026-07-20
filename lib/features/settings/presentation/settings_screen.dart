import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:teamstreakpromo/features/rewards/presentation/rewards_point_details_screen.dart';
import '../../../common_widgets/app_network_image.dart';
import '../../../common_widgets/custom_back_button.dart';
import '../../../common_widgets/custom_gradient_button.dart';
import '../../../common_widgets/gradient_container.dart';
import '../../../constants/text_font_style.dart';
import '../../../gen/assets.gen.dart';
import '../../../gen/colors.gen.dart';
import '../../../helpers/all_routes.dart';
import '../../../helpers/navigation_service.dart';
import '../../../helpers/ui_helpers.dart';
import '../widgets/settings_item.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldColor,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: Padding(
          padding: EdgeInsets.all(8.r),
          child: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: const CustomBackButton(),
            title: Text(
              "Settings",
              style: TextFontStyle.textStyle24cFFFFFFSFPro590.copyWith(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            centerTitle: true,
            actions: [
              Image.asset(
                Assets.icons.splashLogo.path,
                height: 24.h,
                color: Colors.white,
              ),
              UIHelper.horizontalSpace(16.w),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const RewardsPointDetailsScreen(),
                  ),
                );
              },
              child: Container(
                padding: EdgeInsets.all(20.w),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16.r),
                  image: DecorationImage(
                    image: AssetImage(Assets.images.pointBackground.path),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Assets.icons.pointIcon.image(
                          color: AppColors.cFFFFFF,
                          height: 24.sp,
                          width: 24.sp,
                        ),
                        UIHelper.horizontalSpace(8.w),
                        Text(
                          "My Point",
                          style: TextFontStyle.textStyle24cFFFFFFSFPro590
                              .copyWith(
                                fontSize: 18.sp,
                                fontWeight: FontWeight.w600,
                                fontFamily: "SF Pro Rounded",
                                color: AppColors.cE8E8E8,
                              ),
                        ),
                        const Spacer(),
                        Text(
                          "95",
                          style: TextFontStyle.textStyle24cFFFFFFSFPro590
                              .copyWith(
                                fontSize: 32.sp,
                                fontWeight: FontWeight.bold,
                                fontFamily: "SF Pro Rounded",
                                color: AppColors.cFFFFFF,
                              ),
                        ),
                        Text(
                          " pts",
                          style: TextFontStyle.textStyle14cFFFFFFSFProRounded400
                              .copyWith(fontSize: 14.sp),
                        ),
                      ],
                    ),
                    UIHelper.verticalSpace(16.h),
                    Text(
                      "Earn 325 more points to unlock more rewards.",
                      style: TextFontStyle.textStyle14cFFFFFFSFProRounded400
                          .copyWith(
                            fontSize: 13.sp,
                            fontFamily: "SF Pro Rounded",
                            color: AppColors.cE8E8E8,
                          ),
                    ),
                  ],
                ),
              ),
            ),
            UIHelper.verticalSpace(16.h),

            // Profile Card
            GradientContainer(
              padding: EdgeInsets.all(16.w),
              child: Row(
                children: [
                  Container(
                    width: 56.w,
                    height: 56.w,
                    decoration: const BoxDecoration(shape: BoxShape.circle),
                    child: const AppNetworkImage(
                      imageUrl:
                          "https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&w=200&q=80",
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
                          style: TextFontStyle.textStyle24cFFFFFFSFPro590
                              .copyWith(
                                fontSize: 18.sp,
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                        UIHelper.verticalSpace(4.h),
                        Text(
                          "lilarose@example.com",
                          style: TextFontStyle.textStyle14cFFFFFFSFProRounded400
                              .copyWith(
                                color: Colors.white.withValues(alpha: 0.6),
                                fontSize: 13.sp,
                              ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            _buildSectionHeader("Profile & Security"),
            SettingsItem(
              iconPath: Assets.icons.profileIcon.path,
              title: "Account Settings",
              onTap: () {
                NavigationService.navigateTo(Routes.accountSettingsScreen);
              },
            ),

            _buildSectionHeader("App Preferences"),
            SettingsItem(
              iconPath: Assets.icons.inviteIcon.path,
              title: "Invite friend",
              onTap: () {
                NavigationService.navigateTo(Routes.inviteFriendScreen);
              },
            ),
            SettingsItem(
              iconPath: Assets.icons.notificationIcon.path,
              title: "Notification Preferences",
              onTap: () {
                NavigationService.navigateTo(Routes.notificationSettingsScreen);
              },
            ),

            _buildSectionHeader("Support"),
            SettingsItem(
              iconPath: Assets.icons.helpandsupportIcon.path,
              title: "Help & Support",
            ),
            SettingsItem(
              iconPath: Assets.icons.termsConditionIcon.path,
              title: "Terms & Condition",
              onTap: () {
                NavigationService.navigateTo(Routes.termsConditionScreen);
              },
            ),

            UIHelper.verticalSpace(32.h),

            // Log Out Button
            CustomGradientButton(
              onPressed: () => _showLogOutBottomSheet(context),
              title: "Log Out",
              height: 52.h,
              borderRadius: BorderRadius.circular(100.r),
            ),
            UIHelper.verticalSpace(32.h),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: EdgeInsets.only(top: 24.h, bottom: 12.h, left: 4.w),
      child: Text(
        title,
        style: TextFontStyle.textStyle14cFFFFFFSFProRounded400.copyWith(
          fontWeight: FontWeight.w600,
          fontSize: 14.sp,
        ),
      ),
    );
  }

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
                        Navigator.pop(context);
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
}
