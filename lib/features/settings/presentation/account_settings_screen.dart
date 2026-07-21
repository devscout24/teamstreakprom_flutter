import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../common_widgets/custom_back_button.dart';
import '../../../common_widgets/custom_button.dart';
import '../../../constants/text_font_style.dart';
import '../../../gen/assets.gen.dart';
import '../../../gen/colors.gen.dart';
import '../../../helpers/all_routes.dart';
import '../../../helpers/navigation_service.dart';
import '../../../helpers/ui_helpers.dart';
import '../widgets/settings_item.dart';

class AccountSettingsScreen extends StatelessWidget {
  const AccountSettingsScreen({super.key});

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
              "Account Settings",
              style: TextFontStyle.textStyle24cFFFFFFSFPro590.copyWith(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            centerTitle: true,
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
        child: Column(
          children: [
            SettingsItem(
              iconPath: Assets.icons.profileIcon.path, // placeholder
              title: "View Profile",
              onTap: () {
                NavigationService.navigateTo(Routes.editProfileScreen);
              },
            ),
            SettingsItem(
              iconPath: Assets.icons.lockImage.path, // placeholder
              title: "Security",
              onTap: () {
                NavigationService.navigateTo(Routes.securityScreen);
              },
            ),
            // Delete Account Button
            CustomButton(
              onPressed: () {
                _showDeleteBottomSheet(context);
              },
              height: 55.h,
              title: "Delete Account",
              backgroundColor: Colors.white,
              borderRadius: BorderRadius.circular(100.r),
              icon: Image.asset(
                Assets.icons.deleteIcon.path,
                color: const Color(0xFFC72C2C),
                width: 20.sp,
                height: 20.sp,
              ),
              textStyle: TextFontStyle.textStyle14cFFFFFFSFProRounded400
                  .copyWith(
                    color: const Color(0xFFC72C2C),
                    fontWeight: FontWeight.w700,
                    fontSize: 16.sp,
                  ),
            ),
            UIHelper.verticalSpace(32.h),
          ],
        ),
      ),
    );
  }

  void _showDeleteBottomSheet(BuildContext context) {
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
                "Delete Account",
                style: TextFontStyle.textStyle24cFFFFFFSFPro590.copyWith(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
              UIHelper.verticalSpace(16.h),
              Text(
                "Are you sure you want to delete your account?\nThis action cannot be undone.",
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
                    child: CustomButton(
                      onPressed: () {
                        // TODO: Implement actual delete logic
                        Navigator.pop(context);
                      },
                      title: "Delete",
                      height: 52.h,
                      backgroundColor: const Color(0xFFC72C2C),
                      borderRadius: BorderRadius.circular(100.r),
                      textStyle: TextFontStyle.textStyle14cFFFFFFSFProRounded400
                          .copyWith(
                            color: Colors.white,
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
