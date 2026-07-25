import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:teamstreakpromo/gen/colors.gen.dart';
import 'package:teamstreakpromo/helpers/ui_helpers.dart';
import 'package:teamstreakpromo/common_widgets/gradient_container.dart';

class BusinessPartnerActiveRewardCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String location;
  final String expiryDate;
  final int claimedCount;
  final int leftCount;

  const BusinessPartnerActiveRewardCard({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.location,
    required this.expiryDate,
    required this.claimedCount,
    required this.leftCount,
  });

  @override
  Widget build(BuildContext context) {
    final total = claimedCount + leftCount;
    final progress = total == 0 ? 0.0 : claimedCount / total;

    return GradientContainer(
      padding: EdgeInsets.all(8.w),
      color: AppColors.c212521, // Dark olive/grey background
      borderRadius: BorderRadius.circular(16.r),
      border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Event Image Placeholder / Network Image
          ClipRRect(
            borderRadius: BorderRadius.circular(12.r),
            child: Image.network(
              imageUrl,
              width: 130.w,
              height: 100.h,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                width: 130.w,
                height: 100.h,
                color: AppColors.c242A34,
                child: Icon(
                  Icons.music_note,
                  color: Colors.white.withValues(alpha: 0.5),
                ),
              ),
            ),
          ),
          UIHelper.horizontalSpace(16),

          // Event Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontFamily: "SF Pro",
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                UIHelper.verticalSpace(6),
                // Location Pin & text
                Row(
                  children: [
                    Icon(
                      Icons.location_on_outlined,
                      color: Colors.white.withValues(alpha: 0.4),
                      size: 14.w,
                    ),
                    UIHelper.horizontalSpace(4),
                    Expanded(
                      child: Text(
                        location,
                        style: TextStyle(
                          fontFamily: "SF Pro",
                          fontSize: 12.sp,
                          color: Colors.white.withValues(alpha: 0.5),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                UIHelper.verticalSpace(8),
                Text(
                  "Exp: $expiryDate",
                  style: TextStyle(
                    fontFamily: "SF Pro",
                    fontSize: 12.sp,
                    color: Colors.white.withValues(alpha: 0.5),
                  ),
                ),
                UIHelper.verticalSpace(8),

                // Progress Bar
                Stack(
                  children: [
                    Container(
                      height: 6.h,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                    ),
                    FractionallySizedBox(
                      widthFactor: progress,
                      child: Container(
                        height: 6.h,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            stops: [-0.375, 1.2411],
                            colors: [AppColors.cF28F31, AppColors.c72E84F],
                          ),
                          borderRadius: BorderRadius.circular(35.r),
                        ),
                      ),
                    ),
                  ],
                ),
                UIHelper.verticalSpace(6),

                // Claimed & Left counts
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "$claimedCount claimed",
                      style: TextStyle(
                        fontFamily: "SF Pro",
                        fontSize: 12.sp,
                        color: Colors.white.withValues(alpha: 0.5),
                      ),
                    ),
                    Text(
                      "$leftCount left",
                      style: TextStyle(
                        fontFamily: "SF Pro",
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.c59B53E,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
