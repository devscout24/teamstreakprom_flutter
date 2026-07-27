import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:teamstreakpromo/gen/colors.gen.dart';
import 'package:teamstreakpromo/helpers/ui_helpers.dart';
import 'package:teamstreakpromo/gen/assets.gen.dart';
import 'package:teamstreakpromo/common_widgets/app_network_image.dart';

import 'home/presentation/business_partner_employee_home.dart';
import 'claim/presentation/business_partner_employee_claim.dart';
import 'profile/presentation/business_partner_employee_profile.dart';

class BusinessPartnerEmployeeNav extends StatefulWidget {
  const BusinessPartnerEmployeeNav({super.key});

  @override
  State<BusinessPartnerEmployeeNav> createState() =>
      _BusinessPartnerEmployeeNavState();
}

class _BusinessPartnerEmployeeNavState
    extends State<BusinessPartnerEmployeeNav> {
  int _currentIndex = 0;

  List<Widget> get _pages => [
    const BusinessPartnerEmployeeHome(),
    const BusinessPartnerEmployeeClaim(),
    BusinessPartnerEmployeeProfile(
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
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            UIHelper.verticalSpace(24.h),
            Expanded(child: _pages[_currentIndex]),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: AppColors.c2b2f32,
        elevation: 10,
        padding: EdgeInsets.zero,
        height: 72.h,
        child: SafeArea(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildTabItem(
                index: 0,
                iconPath: Assets.icons.dashboardIcon.path,
                label: "Dashboard",
              ),
              _buildTabItem(
                index: 1,
                iconPath: Assets.icons.claimIcon.path,
                label: "Claim",
              ),
              _buildTabItem(
                index: 2,
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
          UIHelper.verticalSpace(4.h),
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

  Widget _buildHeader() {
    return Padding(
      padding: EdgeInsets.only(left: 16.w, right: 16.w, top: 20.h),
      child: Container(
        color: AppColors.scaffoldColor,
        child: Row(
          children: [
            GestureDetector(
              onTap: () {
                setState(() {
                  _currentIndex = 2;
                });
              },
              child: Container(
                width: 44.w,
                height: 44.w,
                decoration: const BoxDecoration(shape: BoxShape.circle),
                child: const AppNetworkImage(
                  imageUrl:
                      "https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?auto=format&fit=crop&w=200&q=80",
                  borderRadius: BorderRadius.all(Radius.circular(100)),
                ),
              ),
            ),
            UIHelper.horizontalSpace(12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Welcome Back!",
                    style: TextStyle(
                      fontFamily: "SF Pro",
                      fontSize: 13.sp,
                      color: Colors.white.withValues(alpha: 0.6),
                    ),
                  ),
                  UIHelper.verticalSpace(4.h),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _currentIndex = 2;
                      });
                    },
                    child: Text(
                      "Wilson Culhane",
                      style: TextStyle(
                        fontFamily: "SF Pro Rounded",
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
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
