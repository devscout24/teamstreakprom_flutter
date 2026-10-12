import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../gen/colors.gen.dart';
import '../../../gen/assets.gen.dart';
import '../../../constants/text_font_style.dart';
import '../../../helpers/ui_helpers.dart';
import '../../../common_widgets/custom_back_button.dart';
import '../../../common_widgets/custom_gradient_button.dart';
import '../../../common_widgets/app_network_image.dart';

class NearbyEventMapScreen extends StatelessWidget {
  const NearbyEventMapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE5E9E6), // Map background color roughly
      body: Stack(
        children: [
          // Background Map Image
          Positioned.fill(
            child: Image.asset(Assets.images.mapEvent.path, fit: BoxFit.cover),
          ),

          // Custom App Bar Overlay
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              color: const Color(0xFF191B21), // Dark header
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).padding.top + 8.h,
                bottom: 12.h,
                left: 16.w,
                right: 16.w,
              ),
              child: Row(
                children: [
                  const CustomBackButton(),
                  Expanded(
                    child: Center(
                      child: Text(
                        "Nearby Event",
                        style: TextFontStyle.textStyle24cFFFFFFSFPro590
                            .copyWith(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                    ),
                  ),
                  SizedBox(width: 44.w), // Balance for centering
                ],
              ),
            ),
          ),

          // Map Markers Overlay
          _buildMapMarkers(context),

          // Fixed Bottom Sheet Panel
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFF191B21),
                borderRadius: BorderRadius.vertical(top: Radius.circular(28.r)),
              ),
              padding: EdgeInsets.fromLTRB(
                16.w,
                12.h,
                16.w,
                24.h + MediaQuery.of(context).padding.bottom,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Drag Handle
                  Container(
                    width: 48.w,
                    height: 4.h,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.8),
                      borderRadius: BorderRadius.circular(2.r),
                    ),
                  ),
                  UIHelper.verticalSpace(24.h),

                  // Event Card
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFF262824),
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    padding: EdgeInsets.all(12.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Event Image
                        Stack(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(16.r),
                              child: AppNetworkImage(
                                imageUrl:
                                    "https://images.unsplash.com/photo-1540039155732-61ee033d526e?auto=format&fit=crop&w=600&q=80",
                                height: 160.h,
                                width: double.infinity,
                              ),
                            ),
                            // Date and Price overlay
                            Positioned(
                              bottom: 0,
                              left: 0,
                              right: 0,
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 16.w,
                                  vertical: 8.h,
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.vertical(
                                    bottom: Radius.circular(16.r),
                                  ),
                                  gradient: LinearGradient(
                                    begin: Alignment.bottomCenter,
                                    end: Alignment.topCenter,
                                    colors: [
                                      Colors.black.withValues(alpha: 0.8),
                                      Colors.black.withValues(alpha: 0.0),
                                    ],
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.calendar_today_outlined,
                                          color: Colors.white,
                                          size: 14.sp,
                                        ),
                                        UIHelper.horizontalSpace(6.w),
                                        Text(
                                          "Sep 21 · 11:00 AM",
                                          style: TextFontStyle
                                              .textStyle14cFFFFFFSFProRounded400
                                              .copyWith(fontSize: 12.sp),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.local_activity_outlined,
                                          color: Colors.white,
                                          size: 14.sp,
                                        ),
                                        UIHelper.horizontalSpace(6.w),
                                        Text(
                                          "\$ 30",
                                          style: TextFontStyle
                                              .textStyle14cFFFFFFSFProRounded400
                                              .copyWith(
                                                fontSize: 12.sp,
                                                fontWeight: FontWeight.bold,
                                              ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        UIHelper.verticalSpace(16.h),
                        // Event Details
                        Text(
                          "Lois Photographic Event",
                          style: TextFontStyle.textStyle24cFFFFFFSFPro590
                              .copyWith(fontSize: 18.sp),
                        ),
                        UIHelper.verticalSpace(6.h),
                        Row(
                          children: [
                            Icon(
                              Icons.location_on_outlined,
                              color: Colors.white.withValues(alpha: 0.6),
                              size: 14.sp,
                            ),
                            UIHelper.horizontalSpace(4.w),
                            Text(
                              "Kamisama Art Club",
                              style: TextFontStyle
                                  .textStyle14cFFFFFFSFProRounded400
                                  .copyWith(
                                    color: Colors.white.withValues(alpha: 0.6),
                                    fontSize: 12.sp,
                                  ),
                            ),
                          ],
                        ),
                        UIHelper.verticalSpace(20.h),
                        // Buy Ticket Button
                        CustomGradientButton(
                          onPressed: () {},
                          title: "Buy Ticket",
                          height: 48.h,
                          borderRadius: BorderRadius.circular(100.r),
                          textStyle: TextFontStyle
                              .textStyle14cFFFFFFSFProRounded400
                              .copyWith(
                                color: const Color(0xFF1E211A),
                                fontWeight: FontWeight.w700,
                                fontSize: 16.sp,
                              ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMapMarkers(BuildContext context) {
    return Positioned(
      top: 150.h,
      left: 0,
      right: 0,
      bottom: 400.h,
      child: Stack(
        children: [
          // Main Active Marker Popup
          Positioned(
            top: 60.h,
            left: 90.w,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    width: 20.w,
                    height: 20.w,
                    decoration: const BoxDecoration(
                      color: Colors.transparent,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: ShaderMask(
                        shaderCallback: (Rect bounds) {
                          return const LinearGradient(
                            colors: [
                              AppColors.primaryColorFirst,
                              AppColors.primaryColorSecond,
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ).createShader(bounds);
                        },
                        blendMode: BlendMode.srcIn,
                        child: Image.asset(
                          Assets.icons.splashLogo.path,
                          width: 16.w,
                          height: 16.w,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),
                  UIHelper.horizontalSpace(8.w),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "LOCAL HERO\nEXHIBITION",
                        style: TextFontStyle.textStyle24cFFFFFFSFPro590
                            .copyWith(
                              color: Colors.black,
                              fontSize: 10.sp,
                              height: 1.1,
                            ),
                      ),
                      UIHelper.verticalSpace(2.h),
                      Text(
                        "SS Art Center",
                        style: TextFontStyle.textStyle14cFFFFFFSFProRounded400
                            .copyWith(color: Colors.grey, fontSize: 8.sp),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          // A few star markers
          Positioned(top: 20.h, left: 200.w, child: _buildStarMarker()),
          Positioned(top: 150.h, left: 140.w, child: _buildStarMarker()),
          Positioned(top: 160.h, right: 120.w, child: _buildStarMarker()),
        ],
      ),
    );
  }

  Widget _buildStarMarker() {
    return Container(
      width: 24.w,
      height: 24.w,
      decoration: const BoxDecoration(
        color: Color(0xFF6B7280),
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Icon(Icons.star, color: Colors.white, size: 14.sp),
      ),
    );
  }
}
