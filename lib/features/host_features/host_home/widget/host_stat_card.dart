import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:teamstreakpromo/common_widgets/gradient_container.dart';
import 'package:teamstreakpromo/gen/colors.gen.dart';
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
      padding: EdgeInsets.symmetric(vertical: 18.w),
      border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.all(10.w),
                  decoration: BoxDecoration(
                    color: circleBgColor,
                    borderRadius: BorderRadius.all(Radius.circular(10.r)),
                  ),
                  child: Icon(icon, color: iconColor, size: 18.w),
                ),
                UIHelper.horizontalSpace(10),
                Flexible(
                  child: Text(
                    title,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: "SF Pro",

                      fontSize: 12.sp,
                      color: AppColors.cFFFFFF.withValues(alpha: 0.7),
                      fontWeight: FontWeight.w400,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          UIHelper.verticalSpace(6),
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
