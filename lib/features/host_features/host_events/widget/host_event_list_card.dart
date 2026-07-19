import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:teamstreakpromo/gen/colors.gen.dart';
import 'package:teamstreakpromo/helpers/ui_helpers.dart';

class HostEventListCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String location;
  final String date;
  final String price;
  final int ticketsSold;
  final int capacity;
  final VoidCallback onDelete;
  final VoidCallback onEdit;

  const HostEventListCard({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.location,
    required this.date,
    required this.price,
    required this.ticketsSold,
    required this.capacity,
    required this.onDelete,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        // Applied the exact yellow-orange to lime-green translucent gradient background requested by the user
        gradient: const LinearGradient(
          colors: [
            Color(0x24F28F31),
            Color(0x3772E84F),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24.r),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.08),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Event Image
          ClipRRect(
            borderRadius: BorderRadius.circular(16.r),
            child: Image.network(
              imageUrl,
              width: double.infinity,
              height: 160.h,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                width: double.infinity,
                height: 160.h,
                color: AppColors.c242A34,
                child: Icon(Icons.music_note, color: Colors.white.withValues(alpha: 0.5), size: 40.w),
              ),
            ),
          ),
          UIHelper.verticalSpace(14),

          // 2. Title & Price Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontFamily: "SF Pro Rounded",
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              UIHelper.horizontalSpace(8),
              Row(
                children: [
                  Icon(
                    Icons.confirmation_number_outlined,
                    color: AppColors.primaryColorSecond,
                    size: 16.w,
                  ),
                  UIHelper.horizontalSpace(4),
                  Text(
                    price,
                    style: TextStyle(
                      fontFamily: "SF Pro Rounded",
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primaryColorSecond,
                    ),
                  ),
                ],
              ),
            ],
          ),
          UIHelper.verticalSpace(8),

          // 3. Location & Date Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Location Pin & text
              Expanded(
                child: Row(
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
              ),
              UIHelper.horizontalSpace(8),
              // Date/Time
              Text(
                date,
                style: TextStyle(
                  fontFamily: "SF Pro",
                  fontSize: 12.sp,
                  color: Colors.white.withValues(alpha: 0.5),
                ),
              ),
            ],
          ),
          UIHelper.verticalSpace(14),

          // 4. Stats & Action Buttons Panel
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Row(
              children: [
                // Ticket Sold Stat
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "$ticketsSold",
                        style: TextStyle(
                          fontFamily: "SF Pro Rounded",
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                      UIHelper.verticalSpace(2),
                      Text(
                        "Ticket Sold",
                        style: TextStyle(
                          fontFamily: "SF Pro",
                          fontSize: 12.sp,
                          color: Colors.white.withValues(alpha: 0.4),
                        ),
                      ),
                    ],
                  ),
                ),

                // Capacity Stat
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "$capacity",
                        style: TextStyle(
                          fontFamily: "SF Pro Rounded",
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                      UIHelper.verticalSpace(2),
                      Text(
                        "Capacity",
                        style: TextStyle(
                          fontFamily: "SF Pro",
                          fontSize: 12.sp,
                          color: Colors.white.withValues(alpha: 0.4),
                        ),
                      ),
                    ],
                  ),
                ),

                // Action buttons: Delete & Edit
                Row(
                  children: [
                    // Delete Button
                    GestureDetector(
                      onTap: onDelete,
                      child: Container(
                        width: 30.w,
                        height: 30.w,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.delete_outline_rounded,
                          color: Colors.redAccent,
                          size: 18
                              .w,
                        ),
                      ),
                    ),
                    UIHelper.horizontalSpace(12),
                    // Edit Button
                    GestureDetector(
                      onTap: onEdit,
                      child: Container(
                        width: 30.w,
                        height: 30.w,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.edit_outlined,
                          color: Colors.black,
                          size: 18.w,
                        ),
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
