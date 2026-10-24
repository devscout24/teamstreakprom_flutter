import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../common_widgets/custom_app_bar.dart';
import '../../../common_widgets/custom_gradient_button.dart';
import '../../../common_widgets/gradient_container.dart';
import '../../../constants/text_font_style.dart';
import '../../../gen/colors.gen.dart';
import '../../../helpers/ui_helpers.dart';
import '../../event/widgets/invite_friend_bottom_sheet.dart';

class InviteFriendScreen extends StatelessWidget {
  const InviteFriendScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldColor,
      appBar:
          const CustomAppBar(title: "It is time to expand the community!"),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Referral Dashboard",
                style: TextFontStyle.textStyle24cFFFFFFSFPro590.copyWith(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              UIHelper.verticalSpace(8.h),
              Text(
                "Spread community! Invite friends and earn points every time they sign up for a streak!",
                style: TextFontStyle.textStyle14cFFFFFFSFProRounded400.copyWith(
                  color: AppColors.c9B9C9A,
                ),
              ),
              UIHelper.verticalSpace(24.h),
              GradientContainer(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "streak.com/join?ref=fdsah",
                      style: TextFontStyle.textStyle14cFFFFFFSFProRounded400
                          .copyWith(
                            fontWeight: FontWeight.w600,
                            fontFamily: "SF Pro",
                          ),
                    ),
                    Container(
                      padding: EdgeInsets.all(12.w),
                      decoration: BoxDecoration(
                        color: const Color(0xFFC3D852),
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      child: Icon(
                        Icons.copy_outlined,
                        color: Colors.black,
                        size: 18.sp,
                      ),
                    ),
                  ],
                ),
              ),
              UIHelper.verticalSpace(32.h),
              Text(
                "My Invitations",
                style: TextFontStyle.textStyle24cFFFFFFSFPro590.copyWith(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  fontFamily: "SF Pro",
                ),
              ),
              UIHelper.verticalSpace(16.h),
              Expanded(
                child: ListView(
                  children: [
                    _buildInvitationItem(
                      name: "Kimberly Gilbert",
                      email: "kimberlygil052@gmail.com",
                      status: "Successful",
                      statusColor: const Color(0xFF72E84F),
                    ),
                    UIHelper.verticalSpace(12.h),
                    _buildInvitationItem(
                      name: "Marcus Lee",
                      email: "marcuslee1987@gmail.com",
                      status: "Successful",
                      statusColor: const Color(0xFF72E84F),
                    ),
                    UIHelper.verticalSpace(12.h),
                    _buildInvitationItem(
                      name: "Sofia Chen",
                      email: "sofiachen@email.com",
                      status: "Pending",
                      statusColor: const Color(0xFFF28F31),
                    ),
                  ],
                ),
              ),
              UIHelper.verticalSpace(16.h),
              CustomGradientButton(
                onPressed: () {
                  showInviteFriendBottomSheet(context);
                },
                title: "Exclusive friend invitation link",
                height: 52.h,
                borderRadius: BorderRadius.circular(100.r),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInvitationItem({
    required String name,
    required String email,
    required String status,
    required Color statusColor,
  }) {
    return GradientContainer(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: TextFontStyle.textStyle16c000000SFPro590.copyWith(
                  color: AppColors.cF3F3F3,
                  fontWeight: FontWeight.w500,
                ),
              ),
              UIHelper.verticalSpace(4.h),
              Text(
                email,
                style: TextFontStyle.textStyle14cFFFFFFSFProRounded400.copyWith(
                  color: AppColors.c9B9C9A,
                  fontSize: 12.sp,
                ),
              ),
            ],
          ),
          Row(
            children: [
              Container(
                width: 8.w,
                height: 8.w,
                decoration: BoxDecoration(
                  color: statusColor,
                  shape: BoxShape.circle,
                ),
              ),
              UIHelper.horizontalSpace(6.w),
              Text(
                status,
                style: TextFontStyle.textStyle14cFFFFFFSFProRounded400.copyWith(
                  color: statusColor,
                  fontSize: 10.sp,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
