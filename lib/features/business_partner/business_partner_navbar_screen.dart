import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:teamstreakpromo/features/settings/presentation/settings_screen.dart';
import 'package:teamstreakpromo/gen/colors.gen.dart';
import 'package:teamstreakpromo/helpers/ui_helpers.dart';
import 'package:teamstreakpromo/common_widgets/host_app_bar.dart';

import 'business_partner_home/presentation/business_partner_home_screen.dart';
import 'business_partner_rewards/presentation/business_partner_rewards_screen.dart';
import 'business_partner_claim/presentation/business_partner_claim_screen.dart';

class BusinessPartnerNavbarScreen extends StatefulWidget {
  const BusinessPartnerNavbarScreen({super.key});

  @override
  State<BusinessPartnerNavbarScreen> createState() =>
      _BusinessPartnerNavbarScreenState();
}

class _BusinessPartnerNavbarScreenState
    extends State<BusinessPartnerNavbarScreen> {
  int _currentIndex = 0;
  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      const BusinessPartnerHomeScreen(), // Dashboard Screen
      const BusinessPartnerRewardsScreen(), // Rewards Screen
      const BusinessPartnerClaimScreen(), // Claim Screen
      const SettingsScreen(), // Settings Screen
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,

      body: _pages[_currentIndex],
      bottomNavigationBar: BottomAppBar(
        color: const Color(0xFF2A313C),
        elevation: 10,
        padding: EdgeInsets.zero,
        height: 72.h,
        child: SafeArea(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildTabItem(
                index: 0,
                iconPath: "assets/icons/dashboard_icon.png",
                label: "Dashboard",
              ),
              _buildTabItem(
                index: 1,
                iconPath: "assets/icons/rewards_icon.png",
                label: "Rewards",
              ),
              _buildTabItem(
                index: 2,
                iconPath: "assets/icons/claim_icon.png",
                label: "Claim",
              ),
              _buildTabItem(
                index: 3,
                iconPath: "assets/icons/setting_icon.png",
                label: "Settings",
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTabItem({
    required int index,
    required String iconPath,
    required String label,
  }) {
    final isSelected = _currentIndex == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          _currentIndex = index;
        });
      },
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Icon with dynamic gradient or gray color
          isSelected
              ? ShaderMask(
                  shaderCallback: (bounds) => LinearGradient(
                    colors: [
                      AppColors.primaryColorFirst,
                      AppColors.primaryColorSecond,
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ).createShader(bounds),
                  child: Image.asset(
                    iconPath,
                    color: Colors.white,
                    width: 24.w,
                    height: 24.w,
                  ),
                )
              : Image.asset(
                  iconPath,
                  color: AppColors.c9B9C9A,
                  width: 24.w,
                  height: 24.w,
                ),
          UIHelper.verticalSpace(4),
          // Label with dynamic gradient or gray color
          isSelected
              ? ShaderMask(
                  shaderCallback: (bounds) => LinearGradient(
                    colors: [
                      AppColors.primaryColorFirst,
                      AppColors.primaryColorSecond,
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ).createShader(bounds),
                  child: Text(
                    label,
                    style: TextStyle(
                      fontFamily: "SF Pro Rounded",
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                )
              : Text(
                  label,
                  style: TextStyle(
                    fontFamily: "SF Pro Rounded",
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                    color: AppColors.c9B9C9A,
                  ),
                ),
        ],
      ),
    );
  }
}
