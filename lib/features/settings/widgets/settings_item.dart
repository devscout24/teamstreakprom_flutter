import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../common_widgets/gradient_container.dart';
import '../../../constants/text_font_style.dart';
import '../../../helpers/ui_helpers.dart';

class SettingsItem extends StatelessWidget {
  final String iconPath;
  final String title;
  final VoidCallback? onTap;

  const SettingsItem({
    super.key,
    required this.iconPath,
    required this.title,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: EdgeInsets.only(bottom: 12.h),
        child: GradientContainer(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          child: Row(
            children: [
              GradientContainer(
                width: 40.w,
                height: 40.w,
                borderRadius: BorderRadius.circular(100.r),
                gradient: const LinearGradient(
                  colors: [Color(0xFFD39A3D), Color(0xFF8DB741)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                child: Center(
                  child: Image.asset(
                    iconPath,
                    color: const Color(0xFF1B1C1A),
                    width: 20.sp,
                    height: 20.sp,
                  ),
                ),
              ),
              UIHelper.horizontalSpace(16.w),
              Expanded(
                child: Text(
                  title,
                  style: TextFontStyle.textStyle14cFFFFFFSFProRounded400
                      .copyWith(fontWeight: FontWeight.w500, fontSize: 15.sp),
                ),
              ),
              Icon(
                Icons.chevron_right,
                color: Colors.white.withValues(alpha: 0.5),
                size: 24.sp,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
