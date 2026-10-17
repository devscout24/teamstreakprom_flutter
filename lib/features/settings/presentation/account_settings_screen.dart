import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../common_widgets/custom_back_button.dart';
import '../../../common_widgets/custom_button.dart';
import '../../../common_widgets/custom_toast.dart';
import '../../../constants/text_font_style.dart';
import '../../../gen/assets.gen.dart';
import '../../../gen/colors.gen.dart';
import '../../../helpers/all_routes.dart';
import '../../../helpers/navigation_service.dart';
import '../../../helpers/ui_helpers.dart';
import '../widgets/settings_item.dart';
import '../../../constants/app_constants.dart';
import '../../../helpers/di.dart';
import '../../../networks/api_acess.dart';
import '../../../networks/dio/dio.dart';
import '../../host_features/profile/presentation/host_edit_profile_screen.dart';

class AccountSettingsScreen extends StatelessWidget {
  const AccountSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final accountType = appData.read(kAccountType)?.toString();
    final profileRole =
        userProfileRxObj.userProfileData.valueOrNull?.data?.role?.toUpperCase();

    final isHostOrBP =
        accountType == "AccountType.host" ||
        accountType == "AccountType.businessPartner" ||
        accountType == "HOST" ||
        accountType == "BUSINESS" ||
        accountType == "host" ||
        accountType == "business" ||
        profileRole == "HOST" ||
        profileRole == "BUSINESS";

    return Scaffold(
      backgroundColor: AppColors.scaffoldColor,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: const CustomBackButton(),
            centerTitle: true,
            title: Text(
              "Account & Settings",
              style: TextFontStyle.textStyle24cFFFFFFSFPro590.copyWith(
                fontSize: 18.sp,
              ),
            ),
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
        child: Column(
          children: [
            SettingsItem(
              iconPath: Assets.icons.profileIcon.path,
              title: "Personal Info",
              onTap: () {
                if (isHostOrBP) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const HostEditProfileScreen(),
                    ),
                  );
                } else {
                  NavigationService.navigateTo(Routes.editProfileScreen);
                }
              },
            ),
            SettingsItem(
              iconPath: Assets.icons.lockImage.path,
              title: "Security",
              onTap: () {
                NavigationService.navigateTo(Routes.securityScreen);
              },
            ),
            SettingsItem(
              iconPath: Assets.icons.deleteIcon.path,
              title: "Delete Account",
              onTap: () {
                _showDeleteBottomSheet(context);
              },
            ),
            UIHelper.verticalSpace(32.h),
          ],
        ),
      ),
    );
  }

  void _showDeleteBottomSheet(BuildContext context) {
    bool isLoading = false;
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
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
                    style: TextFontStyle.textStyle14cFFFFFFSFProRounded400
                        .copyWith(
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
                          onTap: isLoading
                              ? null
                              : () => Navigator.pop(context),
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
                          isLoading: isLoading,
                          onPressed: isLoading
                              ? null
                              : () async {
                                  setModalState(() {
                                    isLoading = true;
                                  });
                                  bool success =
                                      await deleteAccountRxObj.deleteAccount(
                                    hardDelete: false,
                                    reason: "Closing account",
                                  );
                                  if (success) {
                                    appData.write(kKeyIsLoggedIn, false);
                                    appData.remove(kKeyAccessToken);
                                    appData.remove(kAccountType);
                                    DioSingleton.instance.update("");

                                    if (context.mounted) {
                                      Navigator.pop(context);
                                    }
                                    customToastMessage(
                                      "Success",
                                      "Account deleted successfully",
                                    );
                                    NavigationService
                                        .navigateToUntilReplacement(
                                      Routes.signInScreen,
                                    );
                                  } else {
                                    setModalState(() {
                                      isLoading = false;
                                    });
                                  }
                                },
                          title: "Delete",
                          height: 52.h,
                          backgroundColor: const Color(0xFFC72C2C),
                          borderRadius: BorderRadius.circular(100.r),
                          textStyle: TextFontStyle
                              .textStyle14cFFFFFFSFProRounded400
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
      },
    );
  }
}
