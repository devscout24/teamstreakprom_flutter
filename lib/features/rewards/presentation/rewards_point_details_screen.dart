import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../common_widgets/custom_app_bar.dart';
import 'package:teamstreakpromo/gen/assets.gen.dart';
import '../../../constants/text_font_style.dart';
import '../../../gen/colors.gen.dart';
import '../../../helpers/ui_helpers.dart';
import '../../../common_widgets/custom_back_button.dart';
import '../../../common_widgets/gradient_container.dart';

class RewardsPointDetailsScreen extends StatelessWidget {
  const RewardsPointDetailsScreen({super.key});

  static final List<Map<String, dynamic>> _transactions = [
    {
      "title": "Points Earned Summer Music Festival",
      "date": "23 Oct, 2024",
      "points": "+1 PTS",
      "status": "Earned",
      "statusColor": const Color(0xFF86B847),
    },
    {
      "title": "Referral Bonus – Friend Joined",
      "date": "23 Oct, 2024",
      "points": "+1 PTS",
      "status": "Refer",
      "statusColor": const Color(0xFF6FDB92),
    },
    {
      "title": "Points Earned Summer Music Festival",
      "date": "23 Oct, 2024",
      "points": "+1 PTS",
      "status": "Earned",
      "statusColor": const Color(0xFF86B847),
    },
    {
      "title": "Referral Bonus – Friend Joined",
      "date": "23 Oct, 2024",
      "points": "+1 PTS",
      "status": "Refer",
      "statusColor": const Color(0xFF6FDB92),
    },
    {
      "title": "Points Earned Summer Music Festival",
      "date": "23 Oct, 2024",
      "points": "+1 PTS",
      "status": "Earned",
      "statusColor": const Color(0xFF86B847),
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldColor,
      appBar: const CustomAppBar(title: "Reward Point Details"),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.w),
        child: Column(
          children: [
            // Points Banner (Reused Design)
            Container(
              padding: EdgeInsets.all(20.w),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16.r),
                image: DecorationImage(
                  image: AssetImage(Assets.images.pointBackground.path),
                  fit: BoxFit.cover,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Assets.icons.pointIcon.image(
                        color: AppColors.cFFFFFF,
                        height: 24.sp,
                        width: 24.sp,
                      ),
                      UIHelper.horizontalSpace(8.w),
                      Text(
                        "My  Point",
                        style: TextFontStyle.textStyle24cFFFFFFSFPro590
                            .copyWith(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w600,
                              fontFamily: "SF Pro Rounded",
                              color: AppColors.cE8E8E8,
                            ),
                      ),
                      const Spacer(),
                      Text(
                        "95",
                        style: TextFontStyle.textStyle24cFFFFFFSFPro590
                            .copyWith(
                              fontSize: 32.sp,
                              fontWeight: FontWeight.bold,
                              fontFamily: "SF Pro Rounded",
                              color: AppColors.cFFFFFF,
                            ),
                      ),
                      Text(
                        " pts",
                        style: TextFontStyle.textStyle14cFFFFFFSFProRounded400
                            .copyWith(fontSize: 14.sp),
                      ),
                    ],
                  ),
                  UIHelper.verticalSpace(16.h),
                  Text(
                    "Earn 325 more points to unlock more rewards.",
                    style: TextFontStyle.textStyle14cFFFFFFSFProRounded400
                        .copyWith(
                          fontSize: 13.sp,
                          fontFamily: "SF Pro Rounded",
                          color: AppColors.cE8E8E8,
                        ),
                  ),
                ],
              ),
            ),
            UIHelper.verticalSpace(24.h),

            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _transactions.length,
              itemBuilder: (context, index) {
                final transaction = _transactions[index];
                return Padding(
                  padding: EdgeInsets.only(bottom: 12.h),
                  child: _buildTransactionItem(
                    title: transaction["title"],
                    date: transaction["date"],
                    points: transaction["points"],
                    status: transaction["status"],
                    statusColor: transaction["statusColor"],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTransactionItem({
    required String title,
    required String date,
    required String points,
    required String status,
    required Color statusColor,
  }) {
    return GradientContainer(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      borderRadius: BorderRadius.circular(12.r),
      gradient: LinearGradient(
        colors: [
          AppColors.primaryColorFirst.withValues(alpha: .08),
          AppColors.primaryColorSecond.withValues(alpha: .08),
        ],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextFontStyle.textStyle14cFFFFFFSFProRounded400.copyWith(
                  fontWeight: FontWeight.w600,
                  fontSize: 12.sp,
                  color: AppColors.cFFFFFF.withOpacity(.8),
                  fontFamily: "SF Pro",
                ),
              ),
              Text(
                points,
                style: TextFontStyle.textStyle14cFFFFFFSFProRounded400.copyWith(
                  color: AppColors.cF28F31,
                  fontWeight: FontWeight.bold,
                  fontSize: 12.sp,
                  fontFamily: "SF Pro",
                ),
              ),
            ],
          ),
          UIHelper.verticalSpace(12.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                date,
                style: TextFontStyle.textStyle14cFFFFFFSFProRounded400.copyWith(
                  color: Colors.white.withValues(alpha: 0.5),
                  fontSize: 12.sp,
                  fontFamily: "SF Pro",
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: const Color(0xFF1B231D),
                  borderRadius: BorderRadius.circular(100.r),
                ),
                child: Text(
                  status,
                  style: TextFontStyle.textStyle14cFFFFFFSFProRounded400
                      .copyWith(
                        color: statusColor,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
