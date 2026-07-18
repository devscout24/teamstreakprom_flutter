import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:teamstreakpromo/gen/assets.gen.dart';
import '../../../gen/colors.gen.dart';
import '../../../constants/text_font_style.dart';
import '../../../helpers/ui_helpers.dart';
import '../../../common_widgets/custom_back_button.dart';
import '../widgets/filter_bottom_sheet.dart';
import '../widgets/reward_card.dart';
import '../model/reward_model.dart';
import '../../../common_widgets/ticket_toggle_button.dart';

class RewardsScreen extends StatefulWidget {
  const RewardsScreen({super.key});

  @override
  State<RewardsScreen> createState() => _RewardsScreenState();
}

class _RewardsScreenState extends State<RewardsScreen> {
  int _selectedTabIndex = 0;

  static const List<RewardModel> _rewards = [
    RewardModel(
      title: "Adidas Courtblock Shoes",
      description: "NIKE is a leading athletic shoe brand known.",
      expiryDate: "23 Oct, 2024",
      points: "95",
      imageUrl:
          "https://images.unsplash.com/photo-1542291026-7eec264c27ff?auto=format&fit=crop&w=400&q=80",
      brandLogoUrl:
          "https://w7.pngwing.com/pngs/384/870/png-transparent-nike-swoosh-logo-brand-nike-angle-active-shirt-black.png",
    ),
    RewardModel(
      title: "Adidas Courtblock Shoes",
      description: "NIKE is a leading athletic shoe brand known.",
      expiryDate: "23 Oct, 2024",
      points: "95",
      imageUrl:
          "https://images.unsplash.com/photo-1600185365926-3a2ce3cdb9eb?auto=format&fit=crop&w=400&q=80",
      brandLogoUrl:
          "https://w7.pngwing.com/pngs/384/870/png-transparent-nike-swoosh-logo-brand-nike-angle-active-shirt-black.png",
    ),
  ];

  void _showFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const FilterBottomSheet(),
    );
  }

  void _redeemRewardDirectly() {
    // Silent reward redemption
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldColor,
      appBar: AppBar(
        backgroundColor: AppColors.scaffoldColor,
        elevation: 0,
        centerTitle: true,
        leading: const Padding(
          padding: EdgeInsets.all(8.0),
          child: CustomBackButton(),
        ),
        title: Text(
          "Rewards Marketplace",
          style: TextFontStyle.textStyle24cFFFFFFSFPro590.copyWith(
            fontSize: 20.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
          UIHelper.verticalSpace(12.h),

          // Points Banner
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Container(
              padding: EdgeInsets.all(20.w),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16.r),
                gradient: const LinearGradient(
                  colors: [AppColors.cE0BA68, AppColors.primaryColorSecond],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Assets.icons.pointIcon.image(height: 24.sp, width: 24.sp),
                      UIHelper.horizontalSpace(8.w),
                      Text(
                        "My Point",
                        style: TextFontStyle.textStyle24cFFFFFFSFPro590
                            .copyWith(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                      const Spacer(),
                      Text(
                        "95",
                        style: TextFontStyle.textStyle24cFFFFFFSFPro590
                            .copyWith(
                              fontSize: 32.sp,
                              fontWeight: FontWeight.bold,
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
                        .copyWith(fontSize: 13.sp),
                  ),
                ],
              ),
            ),
          ),
          UIHelper.verticalSpace(24.h),

          // Toggle Button
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: TicketToggleButton(
              leftLabel: 'Marketplace',
              rightLabel: 'My Rewards',
              selectedIndex: _selectedTabIndex,
              onChanged: (i) => setState(() => _selectedTabIndex = i),
              height: 48.h,
            ),
          ),
          UIHelper.verticalSpace(24.h),

          // Search Bar
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Container(
              height: 52.h,
              decoration: BoxDecoration(
                color: const Color(0xFF1E222B),
                borderRadius: BorderRadius.circular(100.r),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.05),
                  width: 1.w,
                ),
              ),
              padding: EdgeInsets.only(left: 16.w, right: 6.w),
              child: Row(
                children: [
                  Icon(
                    Icons.search,
                    color: Colors.white.withValues(alpha: 0.5),
                    size: 24.sp,
                  ),
                  UIHelper.horizontalSpace(12.w),
                  Expanded(
                    child: TextField(
                      style: TextFontStyle.textStyle14cFFFFFFSFProRounded400
                          .copyWith(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: "Search...",
                        hintStyle: TextFontStyle
                            .textStyle14cFFFFFFSFProRounded400
                            .copyWith(
                              color: Colors.white.withValues(alpha: 0.4),
                            ),
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: _showFilterBottomSheet,
                    child: Container(
                      width: 40.h,
                      height: 40.h,
                      decoration: const BoxDecoration(
                        color: Color(0xFF232D26),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.tune_rounded,
                        color: Colors.white,
                        size: 18.sp,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          UIHelper.verticalSpace(24.h),

          // Grid screen
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 16.h,
              crossAxisSpacing: 16.w,
              childAspectRatio: 0.41,
            ),
              itemCount: _rewards.length,
              itemBuilder: (context, index) {
                final reward = _rewards[index];
                return RewardCard(
                  title: reward.title,
                  description: reward.description,
                  expiryDate: reward.expiryDate,
                  points: reward.points,
                  imageUrl: reward.imageUrl,
                  brandLogoUrl: reward.brandLogoUrl,
                  onRedeemPressed: _redeemRewardDirectly,
                  width: double.infinity,
                );
              },
            ),
            UIHelper.verticalSpace(24.h),
          ],
        ),
      ),
    );
  }
}
