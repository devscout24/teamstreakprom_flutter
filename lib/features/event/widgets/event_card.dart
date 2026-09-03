import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../gen/colors.gen.dart';
import '../../../constants/text_font_style.dart';
import '../../../helpers/ui_helpers.dart';
import '../../../common_widgets/app_network_image.dart';
import '../../../common_widgets/custom_gradient_button.dart';
import '../presentation/event_details_screen.dart';

class EventCard extends StatelessWidget {
  final String title;
  final String location;
  final String date;
  final String price;
  final String imageUrl;
  final VoidCallback onBuyPressed;
  final bool isOverlayStyle;
  final double? width;
  final double? height;
  final double? imageHeight;
  final VoidCallback? onTap;
  final String? eventId;

  const EventCard({
    super.key,
    required this.title,
    required this.location,
    required this.date,
    required this.price,
    required this.imageUrl,
    required this.onBuyPressed,
    this.isOverlayStyle = true,
    this.width,
    this.height,
    this.imageHeight,
    this.onTap,
    this.eventId,
  });

  void _navigateToDetails(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EventDetailsScreen(
          title: title,
          location: location,
          date: date,
          price: price,
          imageUrl: imageUrl,
          description:
              "Experience unmatched comfort with NIKE Men's Sneakers. Crafted for durability, they feature a breathable upper and cushioned sole, ensuring you stay light on your feet. The stylish design seamlessly blends with any outfit, making them a versatile choice for any occasion.",
          isReward: false,
          eventId: eventId,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap ?? () => _navigateToDetails(context),
      child: _buildCardContent(context),
    );
  }

  Widget _buildCardContent(BuildContext context) {
    if (isOverlayStyle) {
      return Container(
        width: width ?? 290.w,
        height: height,
        decoration: BoxDecoration(
          color: const Color(0xFF1E222B),
          borderRadius: BorderRadius.circular(24.r),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.05),
            width: 1.w,
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24.r),
          child: Stack(
            children: [
              // Cover Image
              Positioned.fill(
                child: AppNetworkImage(imageUrl: imageUrl, fit: BoxFit.cover),
              ),
              // Dark Gradient Overlay
              Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withValues(alpha: 0.3),
                        Colors.black.withValues(alpha: 0.85),
                      ],
                      stops: const [0.3, 0.6, 1.0],
                    ),
                  ),
                ),
              ),
              // Card Content overlayed at the bottom
              Padding(
                padding: EdgeInsets.all(16.w),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextFontStyle.textStyle24cFFFFFFSFPro590.copyWith(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    UIHelper.verticalSpace(8.h),
                    Row(
                      children: [
                        Icon(
                          Icons.location_on_rounded,
                          size: 16.sp,
                          color: AppColors.primaryColorSecond,
                        ),
                        UIHelper.horizontalSpace(6.w),
                        Flexible(
                          child: Text(
                            location,
                            style: TextFontStyle
                                .textStyle14cFFFFFFSFProRounded400
                                .copyWith(
                                  color: Colors.white.withValues(alpha: 0.6),
                                  fontSize: 13.sp,
                                ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    UIHelper.verticalSpace(8.h),
                    Row(
                      children: [
                        Icon(
                          Icons.calendar_today_rounded,
                          size: 14.sp,
                          color: Colors.white.withValues(alpha: 0.6),
                        ),
                        UIHelper.horizontalSpace(6.w),
                        Text(
                          date,
                          style: TextFontStyle.textStyle14cFFFFFFSFProRounded400
                              .copyWith(
                                color: Colors.white.withValues(alpha: 0.6),
                                fontSize: 12.sp,
                              ),
                        ),
                        const Spacer(),
                        Icon(
                          Icons.confirmation_num_rounded,
                          size: 14.sp,
                          color: Colors.white.withValues(alpha: 0.6),
                        ),
                        UIHelper.horizontalSpace(4.w),
                        Text(
                          price,
                          style: TextFontStyle.textStyle14cFFFFFFSFProRounded400
                              .copyWith(
                                color: Colors.white.withValues(alpha: 0.8),
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                      ],
                    ),
                    UIHelper.verticalSpace(16.h),
                    // Custom Gradient Buy Ticket Button
                    CustomGradientButton(
                      onPressed: () {
                        onBuyPressed();
                        _navigateToDetails(context);
                      },
                      title: "Buy Ticket",
                      height: 40.h,
                      borderRadius: BorderRadius.circular(20.r),
                      textStyle: TextFontStyle.textStyle14cFFFFFFSFProRounded400
                          .copyWith(
                            color: AppColors.c262824,
                            fontWeight: FontWeight.w700,
                            fontSize: 14.sp,
                          ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    } else {
      return Container(
        width: width ?? 270.w,
        height: height,
        decoration: BoxDecoration(color: AppColors.c121212),
        child: Padding(
          padding: EdgeInsets.all(8.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Cover Image
              Container(
                height: imageHeight ?? 360.h,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color.fromRGBO(134, 134, 134, 0.10),
                ),
                child: ClipRRect(
                  child: AppNetworkImage(imageUrl: imageUrl, fit: BoxFit.cover),
                ),
              ),
              UIHelper.verticalSpace(12.h),
              Text(
                title,
                style: TextFontStyle.textStyle24cFFFFFFSFPro590.copyWith(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              UIHelper.verticalSpace(10.h),
              Row(
                children: [
                  Icon(
                    Icons.location_on_outlined,
                    size: 16.sp,
                    color: Colors.white.withValues(alpha: 0.7),
                  ),
                  UIHelper.horizontalSpace(6.w),
                  Flexible(
                    child: Text(
                      location,
                      style: TextFontStyle.textStyle14cFFFFFFSFProRounded400
                          .copyWith(
                            color: Colors.white.withValues(alpha: 0.6),
                            fontSize: 12.sp,
                          ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              UIHelper.verticalSpace(10.h),
              Row(
                children: [
                  Icon(
                    Icons.calendar_month_outlined,
                    size: 16.sp,
                    color: Colors.white.withValues(alpha: 0.9),
                  ),
                  UIHelper.horizontalSpace(6.w),
                  Flexible(
                    child: Text(
                      date,
                      style: TextFontStyle.textStyle14cFFFFFFSFProRounded400
                          .copyWith(
                            color: Colors.white.withValues(alpha: 0.9),
                            fontSize: 14.sp,
                          ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    }
  }
}
