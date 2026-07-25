import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:teamstreakpromo/gen/colors.gen.dart';
import 'package:teamstreakpromo/helpers/ui_helpers.dart';
import 'package:teamstreakpromo/common_widgets/gradient_container.dart';

class HostEventCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String location;
  final String revenue;
  final String going;

  const HostEventCard({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.location,
    required this.revenue,
    required this.going,
  });

  @override
  Widget build(BuildContext context) {
    return GradientContainer(
      padding: EdgeInsets.all(12.w),
      // gradient: const LinearGradient(
      //   colors: [Color(0x24F28F31), Color(0x3772E84F)],
      //   begin: Alignment(0.50, -0.37),
      //   end: Alignment(0.50, 1.24),
      // ),
      border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      child: Row(
        children: [
          // Event Image Placeholder / Network Image
          ClipRRect(
            borderRadius: BorderRadius.circular(12.r),
            child: Image.network(
              imageUrl,
              width: 100.w,
              height: 70.h,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                width: 100.w,
                height: 70.h,
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
                    fontFamily: "SF Pro Rounded",
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
                // Revenue & Going tags
                SizedBox(
                  width: 200,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        revenue,
                        style: TextStyle(
                          fontFamily: "SF Pro",
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.c59B53E,
                        ),
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.people_outline_rounded,
                            color: Colors.white.withValues(alpha: 0.4),
                            size: 14.w,
                          ),
                          UIHelper.horizontalSpace(4),
                          Text(
                            going,
                            style: TextStyle(
                              fontFamily: "SF Pro",
                              fontSize: 12.sp,
                              color: AppColors.c9B9C9A,
                            ),
                          ),
                        ],
                      ),
                    ],
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
