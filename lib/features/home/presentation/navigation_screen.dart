import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../gen/colors.gen.dart';
import '../../../gen/assets.gen.dart';
import 'home_screen.dart';
import '../../event/presentation/event_screen.dart';
import '../../rewards/presentation/rewards_screen.dart';
import '../../my_ticket/presentation/my_ticket_screen.dart';
import '../../settings/presentation/settings_screen.dart';
import '../../../common_widgets/app_network_image.dart';
import '../../../constants/text_font_style.dart';
import '../../../helpers/ui_helpers.dart';

class NavigationScreen extends StatefulWidget {
  const NavigationScreen({super.key});

  @override
  State<NavigationScreen> createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = const [
    HomeScreen(),
    EventScreen(),
    RewardsScreen(),
    MyTicketScreen(),
    SettingsScreen(),
  ];

  static const Gradient _activeGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [AppColors.primaryColorFirst, AppColors.primaryColorSecond],
  );

  Widget _buildNavItem({
    required int index,
    required String iconPath,
    required String label,
  }) {
    final isSelected = _selectedIndex == index;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedIndex = index;
          });
        },
        behavior: HitTestBehavior.opaque,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedScale(
              scale: isSelected ? 1.15 : 1.0,
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeOutBack,
              child: isSelected
                  ? ShaderMask(
                      shaderCallback: (bounds) =>
                          _activeGradient.createShader(bounds),
                      blendMode: BlendMode.srcIn,
                      child: Image.asset(
                        iconPath,
                        width: 24.w,
                        height: 24.w,
                        color: Colors.white,
                      ),
                    )
                  : Image.asset(
                      iconPath,
                      width: 24.w,
                      height: 24.w,
                      color: Colors.white.withValues(alpha: 0.5),
                    ),
            ),
            UIHelper.verticalSpace(6.h),
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeInOut,
              style: TextFontStyle.textStyle14cFFFFFFSFProRounded400.copyWith(
                fontFamily: 'SF Pro',
                fontSize: isSelected ? 11.5.sp : 11.sp,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                color: isSelected
                    ? AppColors.primaryColorSecond
                    : Colors.white.withValues(alpha: 0.5),
              ),
              child: Text(label),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.fromLTRB(24.w, 16.h, 24.w, 12.h),
      color: AppColors.scaffoldColor,
      child: Row(
        children: [
          Container(
            width: 44.w,
            height: 44.w,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
            ),
            child: const AppNetworkImage(
              imageUrl: "https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?auto=format&fit=crop&w=200&q=80",
              borderRadius: BorderRadius.all(Radius.circular(100)),
            ),
          ),
          UIHelper.horizontalSpace(12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Wilson Culhane",
                  style: TextFontStyle.textStyle16cFFFFFFSFPro590,
                ),
                UIHelper.verticalSpace(4.h),
                Row(
                  children: [
                    Icon(
                      Icons.location_on_rounded,
                      size: 16.sp,
                      color: AppColors.primaryColorSecond,
                    ),
                    UIHelper.horizontalSpace(4.w),
                    Flexible(
                      child: Text(
                        "Divine Art Festival",
                        overflow: TextOverflow.ellipsis,
                        style: TextFontStyle.textStyle14cFFFFFFSFPro590.copyWith(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w400,
                          color: Colors.white.withValues(alpha: 0.6),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          UIHelper.horizontalSpace(12.w),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
            decoration: BoxDecoration(
              color: const Color(0xFF1E222B),
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                ShaderMask(
                  shaderCallback: (bounds) => const LinearGradient(
                    colors: [AppColors.primaryColorFirst, AppColors.primaryColorSecond],
                  ).createShader(bounds),
                  blendMode: BlendMode.srcIn,
                  child: Image.asset(
                    Assets.icons.pointIcon.path,
                    width: 18.w,
                    height: 18.w,
                    color: Colors.white,
                  ),
                ),
                UIHelper.horizontalSpace(6.w),
                RichText(
                  text: TextSpan(
                    text: "95 ",
                    style: TextFontStyle.textStyle14cFFFFFFSFPro590.copyWith(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primaryColorSecond,
                    ),
                    children: [
                      TextSpan(
                        text: "pts",
                        style: TextFontStyle.textStyle14cFFFFFFSFPro590.copyWith(
                          fontSize: 11.sp,
                          fontWeight: FontWeight.w400,
                          color: AppColors.primaryColorSecond.withValues(alpha: 0.8),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          UIHelper.horizontalSpace(12.w),
          Stack(
            clipBehavior: Clip.none,
            children: [
              Image.asset(
                Assets.icons.notificationIcon.path,
                width: 24.w,
                height: 24.w,
                color: Colors.white,
              ),
              Positioned(
                top: -2.h,
                right: -2.w,
                child: Container(
                  padding: EdgeInsets.all(4.w),
                  decoration: const BoxDecoration(
                    color: Color(0xFFF28F31),
                    shape: BoxShape.circle,
                  ),
                  constraints: BoxConstraints(
                    minWidth: 14.w,
                    minHeight: 14.w,
                  ),
                  child: Center(
                    child: Text(
                      "3",
                      style: TextFontStyle.textStyle14cFFFFFFSFPro590.copyWith(
                        fontSize: 8.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldColor,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: IndexedStack(
                index: _selectedIndex,
                children: _screens,
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        height: 78.h,
        decoration: BoxDecoration(
          color: const Color(0xFF13151B),
          border: Border(
            top: BorderSide(
              color: Colors.white.withValues(alpha: 0.05),
              width: 1.h,
            ),
          ),
        ),
        child: DecoratedBox(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0x1AF8FFF5),
                Color(0x1AB3E588),
              ],
            ),
          ),
          child: SafeArea(
            top: false,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(
                  index: 0,
                  iconPath: Assets.icons.homeIcon.path,
                  label: "Home",
                ),
                _buildNavItem(
                  index: 1,
                  iconPath: Assets.icons.eventIcon.path,
                  label: "Event",
                ),
                _buildNavItem(
                  index: 2,
                  iconPath: Assets.icons.rewards.path,
                  label: "Rewards",
                ),
                _buildNavItem(
                  index: 3,
                  iconPath: Assets.icons.ticketIcon.path,
                  label: "My Ticket",
                ),
                _buildNavItem(
                  index: 4,
                  iconPath: Assets.icons.settingIcon.path,
                  label: "Settings",
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
