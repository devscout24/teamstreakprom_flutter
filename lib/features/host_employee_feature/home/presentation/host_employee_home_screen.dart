import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:teamstreakpromo/gen/colors.gen.dart';
import 'package:teamstreakpromo/helpers/ui_helpers.dart';
import 'package:teamstreakpromo/constants/text_font_style.dart';
import 'package:teamstreakpromo/common_widgets/app_network_image.dart';
import 'package:teamstreakpromo/helpers/navigation_service.dart';
import 'package:teamstreakpromo/helpers/all_routes.dart';
import 'package:teamstreakpromo/common_widgets/gradient_container.dart';

class HostEmployeeHomeScreen extends StatelessWidget {
  final VoidCallback? onProfileTapped;

  const HostEmployeeHomeScreen({super.key, this.onProfileTapped});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(vertical: 20.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              UIHelper.verticalSpace(24.h),

              // ── Search & Filter Row ──────────────────
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Container(
                  height: 52.h,
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E222B),
                    borderRadius: BorderRadius.circular(100.r),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.05),
                      width: 1.w,
                    ),
                  ),
                  padding: EdgeInsets.only(left: 16.w, right: 6.w),
                  child: Row(
                    children: [
                      Icon(
                        Icons.search,
                        color: Colors.white.withValues(alpha: 0.5),
                        size: 24.sp,
                      ),
                      UIHelper.horizontalSpace(12.w),
                      Expanded(
                        child: TextField(
                          style: TextFontStyle.textStyle14cFFFFFFSFProRounded400
                              .copyWith(color: Colors.white),
                          decoration: InputDecoration(
                            hintText: "Search...",
                            hintStyle: TextFontStyle
                                .textStyle14cFFFFFFSFProRounded400
                                .copyWith(
                                  color: Colors.white.withValues(alpha: 0.4),
                                ),
                            border: InputBorder.none,
                            isDense: true,
                            contentPadding: EdgeInsets.zero,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              UIHelper.verticalSpace(32.h),

              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Container(
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                    color: const Color(0xFF262829),
                    borderRadius: BorderRadius.circular(16.r),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.05),
                      width: 1.w,
                    ),
                  ),
                  child: Column(
                    children: [
                      // Table Header
                      GradientContainer(
                        height: 56.h,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(16.r),
                          topRight: Radius.circular(16.r),
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 16.w),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: _buildHeaderText("Ticket ID"),
                            ),
                            Expanded(
                              flex: 4,
                              child: _buildHeaderText("Event Name"),
                            ),
                            Expanded(
                              flex: 3,
                              child: _buildHeaderText("Date & Time"),
                            ),
                            Expanded(
                              flex: 2,
                              child: Center(child: _buildHeaderText("Action")),
                            ),
                          ],
                        ),
                      ),

                      // List of items
                      // List of items
                      ListView.builder(
                        shrinkWrap: true,
                        padding: EdgeInsets.zero,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: 2,
                        itemBuilder: (context, index) {
                          return _buildTableRow(
                            "#${2530 + index}",
                            "Ella's Creative Showcase",
                            "Aug 15, 2026\n10 am",
                            index
                                .isEven, // Alternating valid/invalid for preview
                            index != 1, // Hide divider on last item
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderText(String text) {
    return Text(
      text,
      style: TextStyle(
        fontFamily: "SF Pro Rounded",
        fontSize: 13.sp,
        fontWeight: FontWeight.w600,
        color: Colors.white,
      ),
    );
  }

  Widget _buildTableRow(
    String id,
    String name,
    String date,
    bool isValid,
    bool showDivider,
  ) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: AppColors.c2b2f32,
            borderRadius: showDivider
                ? null
                : BorderRadius.only(
                    bottomLeft: Radius.circular(16.r),
                    bottomRight: Radius.circular(16.r),
                  ),
          ),
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                flex: 2,
                child: Text(
                  id,
                  style: TextStyle(
                    fontFamily: "SF Pro Rounded",
                    fontSize: 12.sp,
                    color: Colors.white.withValues(alpha: 0.7),
                  ),
                ),
              ),
              Expanded(
                flex: 4,
                child: Text(
                  name,
                  style: TextStyle(
                    fontFamily: "SF Pro Rounded",
                    fontSize: 12.sp,
                    color: Colors.white.withValues(alpha: 0.9),
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Expanded(
                flex: 3,
                child: Text(
                  date,
                  style: TextStyle(
                    fontFamily: "SF Pro Rounded",
                    fontSize: 12.sp,
                    color: Colors.white.withValues(alpha: 0.7),
                    height: 1.4,
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Center(
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 10.w,
                      vertical: 6.h,
                    ),
                    decoration: BoxDecoration(
                      color: isValid
                          ? Colors.green.withValues(alpha: 0.15)
                          : Colors.red.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(100.r),
                    ),
                    child: Text(
                      isValid ? "Valid" : "Invalid",
                      style: TextStyle(
                        fontFamily: "SF Pro Rounded",
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w600,
                        color: isValid
                            ? Colors.greenAccent[400]
                            : Colors.redAccent[400],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        if (showDivider)
          Divider(
            color: Colors.white.withValues(alpha: 0.1),
            thickness: 1.h,
            height: 1.h,
          ),
      ],
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Container(
        color: AppColors.scaffoldColor,
        child: Row(
          children: [
            GestureDetector(
              onTap:
                  onProfileTapped ??
                  () {
                    NavigationService.navigateTo(
                      Routes.hostEmployeeProfileScreen,
                    );
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
                    onTap:
                        onProfileTapped ??
                        () {
                          NavigationService.navigateTo(
                            Routes.hostEmployeeProfileScreen,
                          );
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
