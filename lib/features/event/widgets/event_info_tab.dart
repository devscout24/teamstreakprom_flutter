import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:teamstreakpromo/constants/text_font_style.dart';
import 'package:teamstreakpromo/gen/colors.gen.dart';
import 'package:teamstreakpromo/gen/assets.gen.dart';
import 'package:teamstreakpromo/helpers/ui_helpers.dart';
import 'package:teamstreakpromo/features/event/model/host_event_details_model.dart';
import 'package:teamstreakpromo/features/event/widgets/event_details_widgets.dart';

class EventInfoTab extends StatelessWidget {
  final bool isHost;
  final String displayDescription;
  final List<ArtistInfo> artists;
  final String formattedEndDate;
  final String timeLeft;
  final int? ageRestriction;
  final int? stock;
  final HostId? host;

  const EventInfoTab({
    super.key,
    required this.isHost,
    required this.displayDescription,
    required this.artists,
    required this.formattedEndDate,
    required this.timeLeft,
    required this.ageRestriction,
    required this.stock,
    this.host,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Description",
          style: TextFontStyle.textStyle24cFFFFFFSFPro590.copyWith(
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        UIHelper.verticalSpace(8.h),
        Text(
          displayDescription,
          style: TextFontStyle.textStyle14cFFFFFFSFProRounded400.copyWith(
            color: Colors.white.withValues(alpha: 0.7),
            fontSize: 13.sp,
            height: 1.5,
          ),
        ),
        UIHelper.verticalSpace(24.h),

        // Divider line
        Divider(color: Colors.white.withValues(alpha: 0.08)),
        UIHelper.verticalSpace(16.h),

        Text(
          "Artist Info",
          style: TextFontStyle.textStyle24cFFFFFFSFPro590.copyWith(
            fontSize: 14.sp,
            color: AppColors.c848484,
            fontWeight: FontWeight.bold,
          ),
        ),
        UIHelper.verticalSpace(12.h),

        // Artist profile cards
        if (artists.isNotEmpty)
          ...artists.map((artist) => ArtistCard(artist: artist)).toList()
        else
          Row(
            children: [
              UIHelper.horizontalSpace(12.w),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "No artists listed",
                    style: TextFontStyle.textStyle14cFFFFFFSFProRounded400
                        .copyWith(
                          color: Colors.white,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ],
              ),
            ],
          ),
        UIHelper.verticalSpace(16.h),

        UIHelper.verticalSpace(24.h),

        // Timeline Alert container box
        Container(
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                AppColors.primaryColorFirst.withValues(alpha: 0.1),
                AppColors.primaryColorSecond.withValues(alpha: 0.1),
              ],
            ),
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  RichText(
                    text: TextSpan(
                      text: "End Date : ",
                      style: TextFontStyle.textStyle14cFFFFFFSFProRounded400
                          .copyWith(
                            color: Colors.white.withValues(alpha: 0.6),
                            fontSize: 13.sp,
                            fontFamily: 'SF Pro',
                          ),
                      children: [
                        TextSpan(
                          text: formattedEndDate,
                          style: TextFontStyle.textStyle14cFFFFFFSFProRounded400
                              .copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                                fontSize: 13.sp,
                              ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    timeLeft,
                    style: TextFontStyle.textStyle14cFFFFFFSFProRounded400
                        .copyWith(
                          color: AppColors.cF54141,
                          fontWeight: FontWeight.w600,
                          fontSize: 13.sp,
                        ),
                  ),
                ],
              ),
              UIHelper.verticalSpace(12.h),
              Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    color: AppColors.primaryColorFirst,
                    size: 16.sp,
                  ),
                  UIHelper.horizontalSpace(8.w),
                  Expanded(
                    child: Text(
                      "This event is only for who are above ${ageRestriction ?? 18} years old.",
                      style: TextFontStyle.textStyle14cFFFFFFSFProRounded400
                          .copyWith(
                            color: AppColors.primaryColorFirst,
                            fontSize: 11.sp,
                          ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        UIHelper.verticalSpace(24.h),

        // Host section
        Row(
          children: [
            CircleAvatar(
              radius: 24.r,
              backgroundImage: (host?.profileImage != null &&
                      host!.profileImage!.isNotEmpty)
                  ? NetworkImage(host!.profileImage!) as ImageProvider
                  : AssetImage(Assets.images.placeholderImage.path),
            ),
            UIHelper.horizontalSpace(12.w),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  host?.name ?? "Unknown Host",
                  style:
                      TextFontStyle.textStyle14cFFFFFFSFProRounded400.copyWith(
                    color: Colors.white,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    fontFamily: "SF Pro",
                  ),
                ),
                UIHelper.verticalSpace(4.h),
                Text(
                  "Host",
                  style:
                      TextFontStyle.textStyle14cFFFFFFSFProRounded400.copyWith(
                    color: Colors.white.withValues(alpha: 0.8),
                    fontSize: 12.sp,
                  ),
                ),
              ],
            ),
          ],
        ),
        UIHelper.verticalSpace(16.h),

        // Seat info line
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(
                  Icons.confirmation_num_outlined,
                  color: Colors.white.withValues(alpha: 0.6),
                  size: 16.sp,
                ),
                UIHelper.horizontalSpace(6.w),
                Text(
                  "Buy this ticket & get 1 point",
                  style:
                      TextFontStyle.textStyle14cFFFFFFSFProRounded400.copyWith(
                    color: Colors.white.withValues(alpha: 0.8),
                    fontSize: 12.sp,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Icon(Icons.event_seat, color: AppColors.cDC822D, size: 16.sp),
                UIHelper.horizontalSpace(6.w),
                Text(
                  "${stock ?? 0} seat remaining",
                  style:
                      TextFontStyle.textStyle14cFFFFFFSFProRounded400.copyWith(
                    color: AppColors.cDC822D,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ],
        ),
        UIHelper.verticalSpace(24.h),

        // Location Section with map
        Text(
          "Location:",
          style: TextFontStyle.textStyle24cFFFFFFSFPro590.copyWith(
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        UIHelper.verticalSpace(12.h),

        // Map container
        Container(
          height: 180.h,
          width: double.infinity,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(16.r)),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16.r),
            child: Assets.images.mapEvent.image(fit: BoxFit.cover),
          ),
        ),
        UIHelper.verticalSpace(24.h),

        // Refer section
        if (!isHost) ...[
          Container(
            height: 52.h,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100.r),
              gradient: const LinearGradient(
                colors: [
                  AppColors.primaryColorFirst,
                  AppColors.primaryColorSecond,
                ],
              ),
            ),
            padding: EdgeInsets.all(1.w),
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFF171A20),
                borderRadius: BorderRadius.circular(100.r),
              ),
              alignment: Alignment.center,
              child: Text(
                "Refer your friend",
                style: TextFontStyle.textStyle14cFFFFFFSFProRounded400.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 15.sp,
                  fontFamily: "SF Pro",
                ),
              ),
            ),
          ),
          UIHelper.verticalSpace(12.h),
          Row(
            children: [
              Icon(
                Icons.info_outline,
                color: AppColors.primaryColorFirst,
                size: 16.sp,
              ),
              UIHelper.horizontalSpace(8.w),
              Expanded(
                child: Text(
                  "You'll receive 1 point only after your friend purchases a ticket.",
                  style: TextFontStyle.textStyle14cFFFFFFSFProRounded400
                      .copyWith(
                        color: AppColors.primaryColorFirst,
                        fontSize: 11.sp,
                      ),
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }
}
