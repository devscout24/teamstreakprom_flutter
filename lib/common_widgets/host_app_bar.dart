import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:teamstreakpromo/common_widgets/app_network_image.dart';
import 'package:teamstreakpromo/constants/text_font_style.dart';
import 'package:teamstreakpromo/gen/assets.gen.dart';
import 'package:teamstreakpromo/gen/colors.gen.dart';
import 'package:teamstreakpromo/helpers/all_routes.dart';
import 'package:teamstreakpromo/helpers/navigation_service.dart';
import 'package:teamstreakpromo/helpers/ui_helpers.dart';

/// A reusable host-side app bar that mirrors the main [NavigationScreen]
/// header: avatar + name/location, points pill, and notification bell.
class HostAppBar extends StatelessWidget {
  const HostAppBar({
    super.key,
    this.name = "Wilson Culhane",
    this.location = "Divine Art Festival",
    this.avatarUrl =
        "https://images.unsplash.com/photo-1539571696357-5a69c17a67c6?q=80&w=150&auto=format&fit=crop",
    this.points = 95,
    this.notificationCount = 3,
    this.onNotificationTap,
  });

  final String name;
  final String location;
  final String avatarUrl;
  final int points;
  final int notificationCount;
  final VoidCallback? onNotificationTap;

  static const _gradient = LinearGradient(
    colors: [AppColors.primaryColorFirst, AppColors.primaryColorSecond],
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 12.h),
      color: AppColors.scaffoldColor,
      child: Row(
        children: [
          // ── Avatar ──────────────────────────────────────────────────────
          GestureDetector(
            onTap: () {
              NavigationService.navigateTo(Routes.hostEditProfileScreen);
            },
            child: Container(
              width: 44.w,
              height: 44.w,
              decoration: const BoxDecoration(shape: BoxShape.circle),
              child: AppNetworkImage(
                imageUrl: avatarUrl,
                borderRadius: const BorderRadius.all(Radius.circular(100)),
              ),
            ),
          ),
          UIHelper.horizontalSpace(12.w),

          // ── Name & Location ─────────────────────────────────────────────
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                GestureDetector(
                  onTap: () {
                    NavigationService.navigateTo(Routes.hostEditProfileScreen);
                  },
                  child: Text(
                    name,
                    style: TextFontStyle.textStyle16cFFFFFFSFPro590,
                  ),
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
                        location,
                        overflow: TextOverflow.ellipsis,
                        style: TextFontStyle.textStyle14cFFFFFFSFPro590
                            .copyWith(
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

          // ── Notification Bell ───────────────────────────────────────────
          GestureDetector(
            onTap:
                onNotificationTap ??
                () => NavigationService.navigateTo(Routes.notificationScreen),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Image.asset(
                  Assets.icons.notificationIcon.path,
                  width: 24.w,
                  height: 24.w,
                  color: Colors.white,
                ),
                if (notificationCount > 0)
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
                          "$notificationCount",
                          style: TextFontStyle.textStyle14cFFFFFFSFPro590
                              .copyWith(
                                fontSize: 8.sp,
                                fontWeight: FontWeight.w700,
                              ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
