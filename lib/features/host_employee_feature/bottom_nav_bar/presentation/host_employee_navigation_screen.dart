import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:teamstreakpromo/gen/colors.gen.dart';
import 'package:teamstreakpromo/helpers/ui_helpers.dart';
import 'package:teamstreakpromo/helpers/all_routes.dart';
import 'package:teamstreakpromo/gen/assets.gen.dart';

import '../../home/presentation/host_employee_home_screen.dart';
import '../../profile/presentation/host_employee_profile_screen.dart';

class HostEmployeeNavigationScreen extends StatefulWidget {
  const HostEmployeeNavigationScreen({super.key});

  @override
  State<HostEmployeeNavigationScreen> createState() =>
      _HostEmployeeNavigationScreenState();
}

class _HostEmployeeNavigationScreenState
    extends State<HostEmployeeNavigationScreen> {
  int _currentIndex = 0;
  List<Widget> get _pages => [
    HostEmployeeHomeScreen(
      onProfileTapped: () {
        setState(() {
          _currentIndex = 1;
        });
      },
    ),
    HostEmployeeProfileScreen(
      onBackTapped: () {
        setState(() {
          _currentIndex = 0;
        });
      },
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldColor,
      body: _pages[_currentIndex],
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, Routes.qrScannerScreen);
        },
        shape: CircleBorder(
          side: BorderSide(
            color: Colors.white.withValues(alpha: 0.05),
            width: 1.5.w,
          ),
        ),
        backgroundColor: const Color(0xFF2A313C),
        elevation: 6,
        child: Icon(
          Icons.qr_code_scanner_rounded,
          color: Colors.white,
          size: 26.w,
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        notchMargin: 8.w,
        color: AppColors.c2b2f32,
        elevation: 10,
        padding: EdgeInsets.zero,
        height: 72.h,
        child: SafeArea(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              // Left Tab
              _buildTabItem(
                index: 0,
                iconPath: "assets/icons/dashboard_icon.png",
                label: "Dashboard",
              ),
              UIHelper.horizontalSpace(48.w),

              // Right Tab
              _buildTabItem(
                index: 1,
                iconPath: Assets.icons.profileIcon.path,
                label: "Profile",
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
