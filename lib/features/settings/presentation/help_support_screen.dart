import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../common_widgets/custom_app_bar.dart';
import '../../../gen/assets.gen.dart';
import '../../../common_widgets/custom_back_button.dart';
import '../../../common_widgets/gradient_container.dart';
import '../../../constants/text_font_style.dart';
import '../../../gen/colors.gen.dart';
import '../../../helpers/ui_helpers.dart';
import '../../../helpers/all_routes.dart';
import '../../../helpers/navigation_service.dart';

class HelpSupportScreen extends StatelessWidget {
  const HelpSupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final tickets = [
      {
        "title": "The event ended earlier than expected.",
        "description":
            "The event concluded before we reached the last activity. It was disappointing to miss out on the final moments of the Neon Nights: Glow Rave Extravaganza.",
        "ticketId": "MOT3203920212",
        "status": "Under review",
        "statusColor": AppColors.primaryColorFirst,
      },
      {
        "title": "The feedback was overwhelmingly positive.",
        "description":
            "Participants praised the organization and atmosphere, highlighting the vibrant energy of the attendees at the Neon Nights: Glow Rave Extravaganza.",
        "ticketId": "MOT3203920213",
        "status": "Under review",
        "statusColor": AppColors.primaryColorFirst,
      },
    ];

    return Scaffold(
      backgroundColor: AppColors.scaffoldColor,
      appBar: const CustomAppBar(title: "My Support"),
      body: ListView.separated(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
        itemCount: tickets.length,
        separatorBuilder: (context, index) => UIHelper.verticalSpace(16.h),
        itemBuilder: (context, index) {
          final ticket = tickets[index];
          return _buildTicketItem(
            title: ticket["title"] as String,
            description: ticket["description"] as String,
            ticketId: ticket["ticketId"] as String,
            status: ticket["status"] as String,
            statusColor: ticket["statusColor"] as Color,
          );
        },
      ),
      floatingActionButton: GestureDetector(
        onTap: () {
          NavigationService.navigateTo(Routes.supportOptionsScreen);
        },
        child: Container(
          width: 60,
          height: 60,
          padding: const EdgeInsets.all(15),
          decoration: ShapeDecoration(
            gradient: LinearGradient(
              begin: const Alignment(0.50, -0.37),
              end: const Alignment(0.50, 1.24),
              colors: [
                const Color(0xFFF28F31).withValues(alpha: 0.10),
                const Color(0xFF72E84F).withValues(alpha: 0.10),
              ],
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 30,
                height: 30,
                clipBehavior: Clip.antiAlias,
                decoration: const BoxDecoration(),
                child: const Icon(
                  Icons.headset_mic_outlined,
                  color: Colors.white,
                  size: 28,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTicketItem({
    required String title,
    required String description,
    required String ticketId,
    required String status,
    required Color statusColor,
  }) {
    return GradientContainer(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextFontStyle.textStyle16c000000SFPro590.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 14.sp,
            ),
          ),
          UIHelper.verticalSpace(12.h),
          Text(
            description,
            style: TextFontStyle.textStyle14cFFFFFFSFProRounded400.copyWith(
              color: AppColors.cBCBCBB,
              fontFamily: "SF Pro",
              fontSize: 12.sp,
              height: 1.5,
            ),
          ),
          UIHelper.verticalSpace(16.h),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text(
                      "Ticket ID : ",
                      style: TextFontStyle.textStyle14cFFFFFFSFProRounded400
                          .copyWith(color: AppColors.c9B9C9A, fontSize: 12.sp),
                    ),
                    Text(
                      ticketId,
                      style: TextFontStyle.textStyle14cFFFFFFSFProRounded400
                          .copyWith(
                            color: AppColors.cFFF9F3,
                            fontWeight: FontWeight.w400,
                            fontSize: 10.sp,
                          ),
                    ),
                  ],
                ),
                Container(
                  width: 1.w,
                  height: 14.h,
                  color: AppColors.c9B9C9A.withValues(alpha: 0.3),
                ),
                Row(
                  children: [
                    Text(
                      "Status ",
                      style: TextFontStyle.textStyle14cFFFFFFSFProRounded400
                          .copyWith(color: AppColors.c9B9C9A, fontSize: 12.sp),
                    ),
                    UIHelper.horizontalSpace(4.w),
                    Container(
                      width: 6.w,
                      height: 6.w,
                      decoration: BoxDecoration(
                        color: statusColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                    UIHelper.horizontalSpace(6.w),
                    Text(
                      status,
                      style: TextFontStyle.textStyle14cFFFFFFSFProRounded400
                          .copyWith(
                            color: statusColor,
                            fontSize: 10.sp,
                            fontWeight: FontWeight.w500,
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
}
