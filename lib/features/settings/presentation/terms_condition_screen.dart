import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../common_widgets/custom_back_button.dart';
import '../../../constants/text_font_style.dart';
import '../../../gen/assets.gen.dart';
import '../../../gen/colors.gen.dart';
import '../../../helpers/ui_helpers.dart';

class TermsConditionScreen extends StatelessWidget {
  const TermsConditionScreen({super.key});

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
              "Terms & Condition",
              style: TextFontStyle.textStyle24cFFFFFFSFPro590.copyWith(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            centerTitle: true,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSection(
              title: "1. Acceptance of Terms",
              content:
                  "By accessing or using Eventify, you agree to be bound by these Terms & Conditions. If you do not agree, please refrain from using the app.",
            ),
            UIHelper.verticalSpace(24.h),
            _buildSection(
              title: "2. Use of the App",
              content:
                  "Eventify provides a platform that connects users with event organizers, venues, and ticket sellers. You agree to use the app responsibly and only for lawful purposes.",
            ),
            UIHelper.verticalSpace(24.h),
            _buildSection(
              title: "3. Event Services",
              bulletPoints: [
                "Event availability depends on venue capacity.",
                "Tickets for events are subject to confirmation before purchase.",
                "An event can only be booked after the payment is successfully processed.",
              ],
            ),
            UIHelper.verticalSpace(24.h),
            _buildSection(
              title: "4. Payments",
              bulletPoints: [
                "Payments can be made online through the app or in cash at the venue.",
                "Online payments may include a service fee.",
                "Cash payments are recorded for transparency but collected by the venue staff.",
                "All completed bookings are logged in the system.",
              ],
            ),
            UIHelper.verticalSpace(24.h),
            _buildSection(
              title: "6. Organizer Responsibilities",
              bulletPoints: [
                "Event organizers must be verified before using the platform.",
                "Subscription status determines account access and event management capabilities.",
                "Eventify does not manage event content or attendee behavior.",
              ],
            ),
            UIHelper.verticalSpace(24.h),
            _buildSection(
              title: "7. Safety",
              content:
                  "User safety is a priority. Please report any suspicious activity to support.",
            ),
            UIHelper.verticalSpace(32.h),
          ],
        ),
      ),
    );
  }

  Widget _buildSection({
    required String title,
    String? content,
    List<String>? bulletPoints,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextFontStyle.textStyle24cFFFFFFSFPro590.copyWith(
            fontSize: 16.sp,
            color: AppColors.cF3F3F3,
            fontWeight: FontWeight.w600,
          ),
        ),
        UIHelper.verticalSpace(12.h),
        if (content != null)
          Text(
            content,
            style: TextFontStyle.textStyle14cFFFFFFSFProRounded400.copyWith(
              color: AppColors.cBCBCBB,
              fontFamily: "SF Pro",
              height: 1.5,
            ),
          ),
        if (bulletPoints != null)
          ...bulletPoints.map((point) {
            return Padding(
              padding: EdgeInsets.only(bottom: 8.h),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 6.h, right: 8.w),
                    child: Container(
                      width: 4.w,
                      height: 4.w,
                      decoration: const BoxDecoration(
                        color: AppColors.c9B9C9A,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      point,
                      style: TextFontStyle.textStyle14cFFFFFFSFProRounded400
                          .copyWith(
                            fontFamily: "SF Pro",
                            color: AppColors.cBCBCBB,
                            height: 1.5,
                          ),
                    ),
                  ),
                ],
              ),
            );
          }),
      ],
    );
  }
}
