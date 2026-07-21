import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:teamstreakpromo/common_widgets/gradient_container.dart';
import 'package:teamstreakpromo/helpers/ui_helpers.dart';

class HostStatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color iconColor;
  final Color circleBgColor;

  const HostStatCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    required this.iconColor,
    required this.circleBgColor,
  });

  @override
  Widget build(BuildContext context) {
    return GradientContainer(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 18.h),
      border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(8.r),
                decoration: BoxDecoration(
                  color: circleBgColor,
                  borderRadius: BorderRadius.all(Radius.circular(10.r)),
                ),
                child: Icon(icon, color: iconColor, size: 18.w),
              ),
              UIHelper.horizontalSpace(10),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontFamily: "SF Pro",
                    fontSize: 13.sp,
                    color: Colors.white.withValues(alpha: 0.6),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          UIHelper.verticalSpace(14),
          Text(
            value,
            style: TextStyle(
              fontFamily: "SF Pro Rounded",
              fontSize: 22.sp,
              fontWeight: FontWeight.w800,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
