import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:teamstreakpromo/gen/colors.gen.dart';
import 'package:teamstreakpromo/helpers/ui_helpers.dart';
import 'package:teamstreakpromo/common_widgets/custom_button.dart';
import 'package:teamstreakpromo/common_widgets/custom_gradient_button.dart';
import 'package:teamstreakpromo/constants/text_font_style.dart';
import 'package:cached_network_image/cached_network_image.dart';

class HostEventListCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String location;
  final String date;
  final String price;
  final int ticketsSold;
  final int capacity;
  final Future<void> Function() onDelete;
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
          colors: [Color(0x24F28F31), Color(0x3772E84F)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24.r),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Event Image
          ClipRRect(
            borderRadius: BorderRadius.circular(16.r),
            child: imageUrl.isEmpty
                ? Image.asset(
                    'assets/images/placeholder_image.jpeg',
                    width: double.infinity,
                    height: 160.h,
                    fit: BoxFit.cover,
                  )
                : CachedNetworkImage(
                    imageUrl: imageUrl,
                    width: double.infinity,
                    height: 160.h,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      width: double.infinity,
                      height: 160.h,
                      color: AppColors.c242A34,
                      child: const Center(
                        child: CircularProgressIndicator(
                          color: AppColors.primaryColorSecond,
                        ),
                      ),
                    ),
                    errorWidget: (context, url, error) => Image.asset(
                      'assets/images/placeholder_image.jpeg',
                      width: double.infinity,
                      height: 160.h,
                      fit: BoxFit.cover,
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
              color: AppColors.cBCBCBB.withValues(alpha: .2),
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
                      onTap: () => _showDeleteBottomSheet(context, onDelete),
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
                          size: 18.w,
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

  void _showDeleteBottomSheet(
    BuildContext context,
    Future<void> Function() onConfirmDelete,
  ) {
    bool isDeleting = false;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      isDismissible: false,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Container(
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
              decoration: BoxDecoration(
                color: AppColors.scaffoldColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(32.r),
                  topRight: Radius.circular(32.r),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Delete Event",
                    style: TextFontStyle.textStyle24cFFFFFFSFPro590.copyWith(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  UIHelper.verticalSpace(16.h),
                  Text(
                    "Are you sure you want to delete this event? This action cannot be undone.",
                    textAlign: TextAlign.center,
                    style: TextFontStyle.textStyle14cFFFFFFSFProRounded400.copyWith(
                      color: Colors.white.withValues(alpha: 0.7),
                      fontSize: 13.sp,
                      height: 1.5,
                    ),
                  ),
                  UIHelper.verticalSpace(24.h),
                  Divider(
                    color: Colors.white.withValues(alpha: 0.1),
                    thickness: 1.h,
                    height: 1.h,
                  ),
                  UIHelper.verticalSpace(24.h),
                  Row(
                    children: [
                      Expanded(
                        child: CustomButton(
                          onPressed: isDeleting ? () {} : () => Navigator.pop(context),
                          title: "Cancel",
                          height: 48.h,
                          borderRadius: BorderRadius.circular(100.r),
                          backgroundColor: Colors.white,
                          foregroundColor: AppColors.c262824,
                          textStyle: TextFontStyle.textStyle14cFFFFFFSFProRounded400
                              .copyWith(
                                color: AppColors.c262824,
                                fontWeight: FontWeight.w700,
                                fontSize: 14.sp,
                              ),
                        ),
                      ),
                      UIHelper.horizontalSpace(16.w),
                      Expanded(
                        child: CustomGradientButton(
                          onPressed: isDeleting ? null : () async {
                            setState(() { isDeleting = true; });
                            await onConfirmDelete();
                            if (context.mounted) {
                              Navigator.pop(context);
                            }
                          },
                          title: isDeleting ? null : "Delete",
                          child: isDeleting 
                            ? SizedBox(
                                height: 24.w, 
                                width: 24.w, 
                                child: const CircularProgressIndicator(color: Colors.white, strokeWidth: 2)
                              ) 
                            : null,
                          height: 48.h,
                          borderRadius: BorderRadius.circular(100.r),
                          textStyle: TextFontStyle.textStyle14cFFFFFFSFProRounded400
                              .copyWith(
                                color: AppColors.c262824,
                                fontWeight: FontWeight.w700,
                                fontSize: 14.sp,
                              ),
                          gradient: const LinearGradient(
                            colors: [Color(0xFFC72C2C), Color(0xFF9E1F1F)],
                          ),
                        ),
                      ),
                    ],
                  ),
                  UIHelper.verticalSpace(8.h),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
