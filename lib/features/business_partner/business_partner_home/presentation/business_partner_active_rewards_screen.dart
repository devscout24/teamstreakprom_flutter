import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:teamstreakpromo/gen/colors.gen.dart';
import 'package:teamstreakpromo/helpers/ui_helpers.dart';
import 'package:teamstreakpromo/features/business_partner/business_partner_home/widget/business_partner_active_reward_card.dart';
import 'package:teamstreakpromo/common_widgets/custom_app_bar.dart';

class BusinessPartnerActiveRewardsScreen extends StatelessWidget {
  final List<Map<String, dynamic>> activeRewards;

  const BusinessPartnerActiveRewardsScreen({
    super.key,
    required this.activeRewards,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldColor,
      appBar: const CustomAppBar(title: "Active Rewards", showRightIcon: false),
      body: ListView.separated(
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
        itemCount: activeRewards.length,
        separatorBuilder: (context, index) => UIHelper.verticalSpace(16),
        itemBuilder: (context, index) {
          final reward = activeRewards[index];
          return BusinessPartnerActiveRewardCard(
            imageUrl: reward["imageUrl"],
            title: reward["title"],
            location: reward["location"],
            expiryDate: reward["expiryDate"],
            claimedCount: reward["claimedCount"],
            leftCount: reward["leftCount"],
          );
        },
      ),
    );
  }
}
