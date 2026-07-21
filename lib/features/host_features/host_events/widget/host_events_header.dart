import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:teamstreakpromo/gen/colors.gen.dart';
import 'package:teamstreakpromo/common_widgets/custom_back_button.dart';

class HostEventsHeader extends StatelessWidget {
  final VoidCallback onBack;
  final VoidCallback onCreateEvent;

  const HostEventsHeader({
    super.key,
    required this.onBack,
    required this.onCreateEvent,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Circular Back Button
        GestureDetector(onTap: onBack, child: const CustomBackButton()),

        // "+ Create New Event" Button
        GestureDetector(
          onTap: onCreateEvent,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
            decoration: BoxDecoration(
              color: AppColors.primaryColorFirst,
              borderRadius: BorderRadius.circular(24.r),
            ),
            child: Row(
              children: [
                Icon(Icons.add, color: Colors.black, size: 18.w),
                SizedBox(width: 4.w),
                Text(
                  "Create New Event",
                  style: TextStyle(
                    fontFamily: "SF Pro Rounded",
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w800,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
