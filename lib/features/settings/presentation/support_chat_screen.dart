import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../common_widgets/custom_back_button.dart';
import '../../../constants/text_font_style.dart';
import '../../../gen/assets.gen.dart';
import '../../../gen/colors.gen.dart';
import '../../../helpers/ui_helpers.dart';

class SupportChatScreen extends StatelessWidget {
  final String topic;
  final String problem;

  const SupportChatScreen({
    super.key,
    required this.topic,
    required this.problem,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldColor,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: Padding(
          padding: EdgeInsets.all(8.r),
          child: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: const CustomBackButton(),
            title: Text(
              "Streak Customer Support",
              style: TextFontStyle.textStyle24cFFFFFFSFPro590.copyWith(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            centerTitle: true,
          ),
        ),
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
        children: [
          _buildRightBubble(topic),
          UIHelper.verticalSpace(16.h),
          if (problem.isNotEmpty) _buildRightBubble(problem),
          if (problem.isNotEmpty) UIHelper.verticalSpace(16.h),
          _buildLeftBubble(problem),
        ],
      ),
    );
  }

  Widget _buildRightBubble(String text) {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
        constraints: BoxConstraints(maxWidth: 280.w),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [
              Color(0xFFF28F31),
              Color(0xFF72E84F),
            ],
          ),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24.r),
            topRight: Radius.circular(24.r),
            bottomLeft: Radius.circular(24.r),
            bottomRight: Radius.circular(24.r),
          ),
        ),
        child: Text(
          text,
          style: TextFontStyle.textStyle14cFFFFFFSFProRounded400.copyWith(
            color: const Color(0xFF1E222B), 
            fontWeight: FontWeight.w500,
            fontSize: 13.sp,
            fontFamily: "SF Pro",
          ),
        ),
      ),
    );
  }

  Widget _buildLeftBubble(String text) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Container(
            width: 32.w,
            height: 32.w,
            decoration: const BoxDecoration(
              color: Color(0xFF72E84F),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Image.asset(
                Assets.icons.splashLogo.path,
                height: 16.h,
                color: Colors.white,
              ),
            ),
          ),
          UIHelper.horizontalSpace(8.w),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
            constraints: BoxConstraints(maxWidth: 260.w),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.05),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(24.r),
                topRight: Radius.circular(24.r),
                bottomRight: Radius.circular(24.r),
                bottomLeft: Radius.circular(24.r),
              ),
            ),
            child: Text(
              text,
              style: TextFontStyle.textStyle14cFFFFFFSFProRounded400.copyWith(
                color: AppColors.cBCBCBB,
                fontWeight: FontWeight.w400,
                fontSize: 13.sp,
                fontFamily: "SF Pro",
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
