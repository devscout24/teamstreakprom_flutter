import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'gen/colors.gen.dart';
import 'gen/assets.gen.dart';
import 'features/home/presentation/home_screen.dart';
import 'features/rewards/presentation/rewards_marketplace_screen.dart';
import 'features/rewards/presentation/rewards_screen.dart';
import 'features/my_ticket/presentation/my_ticket_screen.dart';
import 'features/settings/presentation/settings_screen.dart';
import 'constants/text_font_style.dart';
import 'helpers/ui_helpers.dart';
import 'constants/app_constants.dart';
import 'helpers/di.dart';
import 'networks/api_acess.dart';
import 'features/settings/model/stripe_account_status_model.dart';

class NavigationScreen extends StatefulWidget {
  const NavigationScreen({super.key});

  @override
  State<NavigationScreen> createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen> {
  int _selectedIndex = 0;

  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _screens = [
      HomeScreen(
        onNavigateToRewards: () {
          setState(() {
            _selectedIndex = 2; // Switch to Rewards tab
          });
        },
      ),
      const RewardsMarketplaceScreen(),
      const RewardsScreen(),
      const MyTicketScreen(),
      const SettingsScreen(),
    ];
  }

  static const Gradient _activeGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [AppColors.primaryColorFirst, AppColors.primaryColorSecond],
  );

  Widget _buildNavItem({
    required int index,
    required String iconPath,
    required String label,
    bool showNotificationBadge = false,
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
        child: _buildNavItemContent(
          isSelected,
          iconPath,
          label,
          showNotificationBadge: showNotificationBadge,
        ),
      ),
    );
  }

  Widget _buildNavItemContent(
    bool isSelected,
    String iconPath,
    String label, {
    bool showNotificationBadge = false,
  }) {
    Widget iconWidget = Image.asset(
      iconPath,
      width: 24.w,
      height: 24.w,
      color: isSelected ? Colors.white : Colors.white.withValues(alpha: 0.5),
    );

    if (isSelected) {
      iconWidget = ShaderMask(
        shaderCallback: (bounds) => _activeGradient.createShader(bounds),
        blendMode: BlendMode.srcIn,
        child: iconWidget,
      );
    }

    Widget textWidget = Text(label);
    if (isSelected) {
      textWidget = ShaderMask(
        shaderCallback: (bounds) => _activeGradient.createShader(bounds),
        blendMode: BlendMode.srcIn,
        child: textWidget,
      );
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            AnimatedScale(
              scale: isSelected ? 1.15 : 1.0,
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeOutBack,
              child: iconWidget,
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
                        color: const Color(0xFFF28F31).withValues(alpha: 0.6),
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
        UIHelper.verticalSpace(6.h),
        AnimatedDefaultTextStyle(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          style: TextFontStyle.textStyle14cFFFFFFSFProRounded400.copyWith(
            fontFamily: 'SF Pro',
            fontSize: isSelected ? 11.5.sp : 11.sp,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
            color: isSelected
                ? Colors.white
                : Colors.white.withValues(alpha: 0.5),
          ),
          child: textWidget,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: (_selectedIndex == 0 || _selectedIndex == 1)
          ? AppColors.c121212
          : AppColors.scaffoldColor,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: IndexedStack(index: _selectedIndex, children: _screens),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        height: 90.h,
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
              colors: [Color(0x1AF8FFF5), Color(0x1AB3E588)],
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
                  iconPath: 'assets/icons/marketplace_icon.png',
                  label: "Marketplace",
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
                StreamBuilder<StripeAccountStatusModel>(
                  stream:
                      getStripeAccountStatusRxObj.getStripeAccountStatusData,
                  builder: (context, snapshot) {
                    final accountType = appData.read(kAccountType)?.toString();
                    final isHost = accountType == "HOST" ||
                        accountType == "host" ||
                        accountType == "AccountType.host";

                    bool showBell = false;
                    if (isHost) {
                      final statusData = snapshot.data?.data ??
                          getStripeAccountStatusRxObj
                              .getStripeAccountStatusData
                              .valueOrNull
                              ?.data;
                      final isConnected = statusData?.isStripeConnected ==
                              true ||
                          statusData?.stripeAccountStatus?.toUpperCase() ==
                              'ACTIVE' ||
                          (appData.read(kKeyStripeConnected) as bool? ?? false);
                      showBell = !isConnected;
                    }

                    return _buildNavItem(
                      index: 4,
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
      ),
    );
  }
}
