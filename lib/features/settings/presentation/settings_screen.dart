import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:teamstreakpromo/features/rewards/presentation/rewards_point_details_screen.dart';
import '../../../common_widgets/app_network_image.dart';
import '../../../common_widgets/custom_gradient_button.dart';
import '../../../common_widgets/gradient_container.dart';
import '../../../constants/text_font_style.dart';
import '../../../gen/assets.gen.dart';
import '../../../gen/colors.gen.dart';
import '../../../helpers/all_routes.dart';
import '../../../helpers/navigation_service.dart';
import '../../../helpers/ui_helpers.dart';
import '../widgets/settings_item.dart';
import '../../../constants/app_constants.dart';
import '../../../helpers/di.dart';
import '../../host_features/profile/presentation/host_edit_profile_screen.dart';
import '../../../networks/api_acess.dart';
import '../../../networks/dio/dio.dart';

import '../../../networks/endpoints.dart';
import '../model/user_profile_model.dart';
import 'package:shimmer/shimmer.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  void initState() {
    super.initState();
    _fetchProfile();
  }

  Future<void> _fetchProfile() async {
    try {
      await userProfileRxObj.fetchUserProfile();
    } catch (e) {
      debugPrint("Failed to fetch profile: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final accountType = appData.read(kAccountType)?.toString();

    return Scaffold(
      backgroundColor: AppColors.scaffoldColor,
      body: SafeArea(
        child: StreamBuilder<UserProfileModel>(
          stream: userProfileRxObj.userProfileData,
          builder: (context, snapshot) {
            final hasData = snapshot.hasData ||
                userProfileRxObj.userProfileData.valueOrNull?.data != null;
            final isWaiting = !hasData &&
                snapshot.connectionState == ConnectionState.waiting;

            final profile = snapshot.data?.data ??
                userProfileRxObj.userProfileData.valueOrNull?.data;

            // Derive role from live snapshot data, NOT stale valueOrNull cache
            final profileRole = profile?.role?.toUpperCase();
            final isHostOrBP =
                accountType == "AccountType.host" ||
                accountType == "AccountType.businessPartner" ||
                accountType == "HOST" ||
                accountType == "BUSINESS" ||
                accountType == "host" ||
                accountType == "business" ||
                profileRole == "HOST" ||
                profileRole == "BUSINESS";

            final name = profile?.name ?? "User";
            final email = profile?.email ?? "";
            final points = profile?.totalPoints ?? 0;
            String? profileImageUrl = profile?.profileImage;
            if (profileImageUrl != null &&
                profileImageUrl.isNotEmpty &&
                !profileImageUrl.startsWith('http')) {
              profileImageUrl = url + profileImageUrl;
            }

            return SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (!isHostOrBP) ...[
                    if (isWaiting)
                      Shimmer.fromColors(
                        baseColor: const Color(0xFF1E222B),
                        highlightColor: Colors.white.withValues(alpha: 0.05),
                        child: Container(
                          height: 110.h,
                          padding: EdgeInsets.all(20.w),
                          decoration: BoxDecoration(
                            color: const Color(0xFF1E222B),
                            borderRadius: BorderRadius.circular(16.r),
                          ),
                        ),
                      )
                    else
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const RewardsPointDetailsScreen(),
                            ),
                          );
                        },
                        child: Container(
                          padding: EdgeInsets.all(20.w),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16.r),
                            image: DecorationImage(
                              image: AssetImage(
                                  Assets.images.pointBackground.path),
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
                                    style: TextFontStyle
                                        .textStyle24cFFFFFFSFPro590
                                        .copyWith(
                                          fontSize: 18.sp,
                                          fontWeight: FontWeight.w600,
                                          fontFamily: "SF Pro Rounded",
                                          color: AppColors.cE8E8E8,
                                        ),
                                  ),
                                  const Spacer(),
                                  Text(
                                    "$points",
                                    style: TextFontStyle
                                        .textStyle24cFFFFFFSFPro590
                                        .copyWith(
                                          fontSize: 32.sp,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: "SF Pro Rounded",
                                          color: AppColors.cFFFFFF,
                                        ),
                                  ),
                                  Text(
                                    " pts",
                                    style: TextFontStyle
                                        .textStyle14cFFFFFFSFProRounded400
                                        .copyWith(fontSize: 14.sp),
                                  ),
                                ],
                              ),
                              UIHelper.verticalSpace(16.h),
                              Text(
                                "Earn 325 more points to unlock more rewards.",
                                style: TextFontStyle
                                    .textStyle14cFFFFFFSFProRounded400
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
                  ],

                  // Profile Card
                  if (isWaiting)
                    Shimmer.fromColors(
                      baseColor: const Color(0xFF1E222B),
                      highlightColor: Colors.white.withValues(alpha: 0.05),
                      child: Container(
                        padding: EdgeInsets.all(16.w),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1E222B),
                          borderRadius: BorderRadius.circular(16.r),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 56.w,
                              height: 56.w,
                              decoration: const BoxDecoration(
                                color: Color(0xFF1E222B),
                                shape: BoxShape.circle,
                              ),
                            ),
                            UIHelper.horizontalSpace(16.w),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: 120.w,
                                    height: 18.h,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF1E222B),
                                      borderRadius: BorderRadius.circular(4.r),
                                    ),
                                  ),
                                  UIHelper.verticalSpace(8.h),
                                  Container(
                                    width: 160.w,
                                    height: 14.h,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF1E222B),
                                      borderRadius: BorderRadius.circular(4.r),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  else
                  GradientContainer(
                    onTap: () async {
                      if (isHostOrBP) {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                const HostEditProfileScreen(),
                          ),
                        );
                      } else {
                        await NavigationService.navigateTo(
                          Routes.editProfileScreen,
                        );
                      }
                      _fetchProfile();
                    },
                    padding: EdgeInsets.all(16.w),
                    child: Row(
                      children: [
                        Container(
                          width: 56.w,
                          height: 56.w,
                          decoration:
                              const BoxDecoration(shape: BoxShape.circle),
                          child: ClipOval(
                            child: (profileImageUrl != null &&
                                    profileImageUrl.isNotEmpty)
                                ? AppNetworkImage(
                                    imageUrl: profileImageUrl,
                                    height: 56.w,
                                    width: 56.w,
                                    fit: BoxFit.cover,
                                  )
                                : Image.asset(
                                    Assets.images.placeholderImage.path,
                                    height: 56.w,
                                    width: 56.w,
                                    fit: BoxFit.cover,
                                  ),
                          ),
                        ),
                        UIHelper.horizontalSpace(16.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                name,
                                style: TextFontStyle
                                    .textStyle24cFFFFFFSFPro590
                                    .copyWith(
                                      fontSize: 18.sp,
                                      fontWeight: FontWeight.w600,
                                    ),
                              ),
                              if (email.isNotEmpty) ...[
                                UIHelper.verticalSpace(4.h),
                                Text(
                                  email,
                                  style: TextFontStyle
                                      .textStyle14cFFFFFFSFProRounded400
                                      .copyWith(
                                        color: Colors.white
                                            .withValues(alpha: 0.6),
                                        fontSize: 13.sp,
                                      ),
                                ),
                              ],
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
                    onTap: () async {
                      await NavigationService.navigateTo(
                        Routes.accountSettingsScreen,
                      );
                      _fetchProfile();
                    },
                  ),

                  _buildSectionHeader("Payments"),
                  SettingsItem(
                    iconWidget: FaIcon(
                      FontAwesomeIcons.stripe,
                      color: const Color(0xFF1B1C1A),
                      size: 20.sp,
                    ),
                    title: "Connect with Stripe",
                    onTap: () {
                      NavigationService.navigateTo(
                        Routes.stripeConnectScreen,
                      );
                    },
                  ),

                  _buildSectionHeader("App Preferences"),
                  if (isHostOrBP) ...[
                    SettingsItem(
                      iconPath: 'assets/icons/team_icon.png',
                      title: "Manage Team",
                      onTap: () {
                        NavigationService.navigateTo(Routes.manageTeamScreen);
                      },
                    ),
                  ],
                  if (!isHostOrBP) ...[
                    SettingsItem(
                      iconPath: Assets.icons.inviteIcon.path,
                      title: "Invite friend",
                      onTap: () {
                        NavigationService.navigateTo(Routes.inviteFriendScreen);
                      },
                    ),
                  ],
                  SettingsItem(
                    iconPath: Assets.icons.notificationIcon.path,
                    title: "Notification Preferences",
                    onTap: () {
                      NavigationService.navigateTo(
                        Routes.notificationSettingsScreen,
                      );
                    },
                  ),

                  _buildSectionHeader("Support"),
                  SettingsItem(
                    iconPath: Assets.icons.helpandsupportIcon.path,
                    title: "Help & Support",
                    onTap: () {
                      NavigationService.navigateTo(Routes.helpSupportScreen);
                    },
                  ),
                  SettingsItem(
                    iconPath: Assets.icons.termsConditionIcon.path,
                    title: "Terms & Condition",
                    onTap: () {
                      NavigationService.navigateTo(
                        Routes.termsConditionScreen,
                      );
                    },
                  ),

                  UIHelper.verticalSpace(32.h),

                  // Log Out Button
                  CustomGradientButton(
                    onPressed: () => _showLogOutBottomSheet(context),
                    title: "Log Out",
                    borderRadius: BorderRadius.circular(100.r),
                  ),
                  UIHelper.verticalSpace(32.h),
                ],
              ),
            );
          },
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
                        child: CustomGradientButton(
                          onPressed: isLoading
                              ? null
                              : () async {
                                  setModalState(() {
                                    isLoading = true;
                                  });
                                  bool success = await logOutRxObj.logOut();
                                  if (success) {
                                    appData.write(kKeyIsLoggedIn, false);
                                    appData.remove(kKeyAccessToken);
                                    DioSingleton.instance.update("");

                                    if (context.mounted) {
                                      Navigator.pop(context); // Close bottom sheet
                                    }
                                    NavigationService.navigateToReplacement(
                                      Routes.signInScreen,
                                    );
                                  } else {
                                    setModalState(() {
                                      isLoading = false;
                                    });
                                  }
                                },
                          height: 52.h,
                          borderRadius: BorderRadius.circular(100.r),
                          child: isLoading
                              ? const SizedBox(
                                  height: 24,
                                  width: 24,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                              : Text(
                                  "Log Out",
                                  style: TextFontStyle
                                      .textStyle14cFFFFFFSFProRounded400
                                      .copyWith(
                                        color: const Color(0xFF1E211A),
                                        fontWeight: FontWeight.w700,
                                        fontSize: 16.sp,
                                      ),
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
