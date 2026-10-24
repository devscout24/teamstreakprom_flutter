import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:teamstreakpromo/features/settings/presentation/settings_screen.dart';
import 'package:teamstreakpromo/gen/colors.gen.dart';
import 'package:teamstreakpromo/helpers/ui_helpers.dart';
import 'package:teamstreakpromo/gen/assets.gen.dart';

import 'package:teamstreakpromo/features/host_features/host_home/presentation/host_home.dart';
import 'package:teamstreakpromo/features/host_features/host_events/presentation/host_events_screen.dart';

import '../../host_earning/presentation/earning_overview_screen.dart';
import 'package:teamstreakpromo/helpers/all_routes.dart';
import 'package:teamstreakpromo/constants/app_constants.dart';
import 'package:teamstreakpromo/helpers/di.dart';
import 'package:teamstreakpromo/networks/api_acess.dart';
import 'package:teamstreakpromo/features/settings/model/stripe_account_status_model.dart';

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
    _fetchStripeStatus();
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

  Future<void> _fetchStripeStatus() async {
    try {
      final res = await getStripeAccountStatusRxObj.getStripeAccountStatus();
      if (res.success == true && res.data != null) {
        final isConnected = res.data?.isStripeConnected ?? false;
        appData.write(kKeyStripeConnected, isConnected);
      }
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldColor,
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
                iconPath: Assets.icons.dashboardIcon.path,
                label: "Dashboard",
              ),
              _buildTabItem(
                index: 1,
                iconPath: Assets.icons.eventIcon.path,
                label: "Events",
              ),

              // Spacer for docked FAB notch
              SizedBox(width: 48.w),

              // Right Tabs
              _buildTabItem(
                index: 2,
                iconPath: Assets.icons.rewards.path,
                label: "Earning",
              ),
              StreamBuilder<StripeAccountStatusModel>(
                stream: getStripeAccountStatusRxObj.getStripeAccountStatusData,
                builder: (context, snapshot) {
                  final statusData = snapshot.data?.data ??
                      getStripeAccountStatusRxObj
                          .getStripeAccountStatusData
                          .valueOrNull
                          ?.data;
                  final isConnected = statusData?.isStripeConnected == true ||
                      statusData?.stripeAccountStatus?.toUpperCase() ==
                          'ACTIVE' ||
                      (appData.read(kKeyStripeConnected) as bool? ?? false);
                  final showBell = !isConnected;

                  return _buildTabItem(
                    index: 3,
                    iconPath: Assets.icons.settingIcon.path,
                    label: "Settings",
                    showNotificationBadge: showBell,
                  );
                },
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
    bool showNotificationBadge = false,
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
          Stack(
            clipBehavior: Clip.none,
            children: [
              isSelected
                  ? ShaderMask(
                      shaderCallback: (bounds) => const LinearGradient(
                        colors: [
                          AppColors.primaryColorFirst,
                          AppColors.primaryColorSecond,
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ).createShader(bounds),
                      blendMode: BlendMode.srcIn,
                      child: Image.asset(
                        iconPath,
                        color: Colors.white,
                        width: 24.w,
                        height: 24.w,
                      ),
                    )
                  : Image.asset(
                      iconPath,
                      color: Colors.white.withValues(alpha: 0.5),
                      width: 24.w,
                      height: 24.w,
                    ),
              if (showNotificationBadge)
                Positioned(
                  top: -5.h,
                  right: -7.w,
                  child: Container(
                    padding: EdgeInsets.all(3.w),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [
                          AppColors.primaryColorFirst,
                          AppColors.primaryColorSecond,
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color:
                              const Color(0xFFF28F31).withValues(alpha: 0.6),
                          blurRadius: 4,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.notifications_active_rounded,
                      size: 9.sp,
                      color: const Color(0xFF1B1C1A),
                    ),
                  ),
                ),
            ],
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
