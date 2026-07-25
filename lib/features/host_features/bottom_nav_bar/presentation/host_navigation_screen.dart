import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:teamstreakpromo/features/settings/presentation/settings_screen.dart';
import 'package:teamstreakpromo/gen/colors.gen.dart';
import 'package:teamstreakpromo/helpers/ui_helpers.dart';
import 'package:teamstreakpromo/common_widgets/host_app_bar.dart';

import 'package:teamstreakpromo/features/host_features/host_home/presentation/host_home.dart';
import 'package:teamstreakpromo/features/host_features/host_events/presentation/host_events_screen.dart';

import '../../host_earning/presentation/earning_overview_screen.dart';
import 'package:teamstreakpromo/helpers/all_routes.dart';

class HostNavigationScreen extends StatefulWidget {
  const HostNavigationScreen({super.key});

  @override
  State<HostNavigationScreen> createState() => _HostNavigationScreenState();
}

class _HostNavigationScreenState extends State<HostNavigationScreen> {
  int _currentIndex = 0;
  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      const HostHomeScreen(),
      HostEventsScreen(
        onBack: () {
          setState(() {
            _currentIndex = 0;
          });
        },
      ),
      const EarningOverviewScreen(),
      const SettingsScreen(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: _currentIndex == 3
          ? null
          : PreferredSize(
              preferredSize: Size.fromHeight(80.h),
              child: Container(
                color: AppColors.scaffoldColor,
                child: const SafeArea(bottom: false, child: HostAppBar()),
              ),
            ),
      body: _pages[_currentIndex],
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Container(
        margin: EdgeInsets.only(top: 8.h),
        child: FloatingActionButton(
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
      ),
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 8.w,
        color: const Color(0xFF2A313C),
        elevation: 10,
        padding: EdgeInsets.zero,
        height: 72.h,
        child: SafeArea(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              // Left Tabs
              _buildTabItem(
                index: 0,
                icon: Icons.grid_view_rounded,
                label: "Dashboard",
              ),
              _buildTabItem(
                index: 1,
                icon: Icons.calendar_today_rounded,
                label: "Events",
              ),

              // Spacer for docked FAB notch
              SizedBox(width: 48.w),

              // Right Tabs
              _buildTabItem(
                index: 2,
                icon: Icons.confirmation_number_outlined,
                label: "Earning",
              ),
              _buildTabItem(
                index: 3,
                icon: Icons.settings_outlined,
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
    required IconData icon,
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
                  child: Icon(icon, color: Colors.white, size: 24.w),
                )
              : Icon(icon, color: AppColors.c9B9C9A, size: 24.w),
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
