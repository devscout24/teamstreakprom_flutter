import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../gen/assets.gen.dart';
import '../constants/text_font_style.dart';
import '../helpers/ui_helpers.dart';
import 'custom_back_button.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showRightIcon;
  final bool showBackButton;
  final Widget? customAction;
  final VoidCallback? onBack;
  final Color? backgroundColor;

  const CustomAppBar({
    super.key,
    required this.title,
    this.showRightIcon = true,
    this.showBackButton = true,
    this.customAction,
    this.onBack,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8.r),
      child: AppBar(
        backgroundColor: backgroundColor ?? Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        leading: showBackButton ? CustomBackButton(onTap: onBack) : null,
        title: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            title,
            style: TextFontStyle.textStyle24cFFFFFFSFPro590.copyWith(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        centerTitle: true,
        actions: customAction != null
            ? [customAction!, UIHelper.horizontalSpace(16.w)]
            : showRightIcon
            ? [
                Image.asset(
                  Assets.icons.splashLogo.path,
                  height: 14.h,
                  color: Colors.white,
                ),
                UIHelper.horizontalSpace(16.w),
              ]
            : null,
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
