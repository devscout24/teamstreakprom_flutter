import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../common_widgets/custom_back_button.dart';
import '../../../constants/text_font_style.dart';
import '../../../gen/colors.gen.dart';
import '../../../helpers/ui_helpers.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

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
              "Notification",
              style: TextFontStyle.textStyle24cFFFFFFSFPro590.copyWith(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            centerTitle: true,
          ),
        ),
      ),
      body: ListView.separated(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        itemCount: 4,
        separatorBuilder: (context, index) =>
            Divider(color: Colors.white.withValues(alpha: 0.1), height: 32.h),
        itemBuilder: (context, index) {
          return _buildNotificationItem(
            title: "Event Scheduled for Tomorrow",
            subtitle: index == 0
                ? "You have a consultation with Dr. Smi.."
                : index == 1
                ? "You have a consultation with Dr. Joh.."
                : index == 2
                ? "You have a meeting with Ms. Lee to.."
                : "You have a meeting with Mr. Brown..",
            time: "2m",
            isUnread: true,
          );
        },
      ),
    );
  }

  Widget _buildNotificationItem({
    required String title,
    required String subtitle,
    required String time,
    required bool isUnread,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Icon Container
        Container(
          width: 48.w,
          height: 48.w,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: [Color(0xFFD39A3D), Color(0xFF8DB741)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Center(
            child: Icon(
              Icons.notifications_none_outlined,
              color: const Color(0xFF1B1C1A),
              size: 24.sp,
            ),
          ),
        ),
        UIHelper.horizontalSpace(12.w),
        // Texts
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              UIHelper.verticalSpace(2.h),
              Text(
                title,
                style: TextFontStyle.textStyle14cFFFFFFSFProRounded400.copyWith(
                  fontWeight: FontWeight.w500,
                  fontSize: 14.sp,
                  fontFamily: "SF Pro",
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              UIHelper.verticalSpace(4.h),
              Text(
                subtitle,
                style: TextFontStyle.textStyle14cFFFFFFSFProRounded400.copyWith(
                  color: Colors.white.withValues(alpha: 0.5),
                  fontSize: 12.sp,
                  fontFamily: "SF Pro",
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
        UIHelper.horizontalSpace(8.w),
        // Time and Unread Indicator
        Padding(
          padding: EdgeInsets.only(top: 4.h),
          child: Row(
            children: [
              Text(
                time,
                style: TextFontStyle.textStyle14cFFFFFFSFProRounded400.copyWith(
                  color: Colors.white.withValues(alpha: 0.5),
                  fontSize: 12.sp,
                  fontFamily: "SF Pro",
                ),
              ),
              UIHelper.horizontalSpace(6.w),
              if (isUnread)
                Container(
                  width: 8.w,
                  height: 8.w,
                  decoration: const BoxDecoration(
                    color: Color(0xFF59B53E),
                    shape: BoxShape.circle,
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
