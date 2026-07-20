import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:teamstreakpromo/features/rewards/widgets/filter_bottom_sheet.dart';
import '../../../gen/colors.gen.dart';
import '../../../constants/text_font_style.dart';
import '../../../gen/assets.gen.dart';
import '../../../helpers/ui_helpers.dart';
import '../../home/widgets/reward_card.dart';
import '../../home/model/reward_model.dart';
import '../../../common_widgets/ticket_toggle_button.dart';
import '../widgets/reward_filter_chips.dart';
import '../widgets/my_reward_card.dart';
import 'reward_details_screen.dart';
import 'marketplace_reward_details_screen.dart';
import 'rewards_point_details_screen.dart';

class RewardsScreen extends StatefulWidget {
  const RewardsScreen({super.key});

  @override
  State<RewardsScreen> createState() => _RewardsScreenState();
}

class _RewardsScreenState extends State<RewardsScreen> {
  int _selectedTabIndex = 0;
  int _selectedFilterIndex = 0;

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
      type: RewardType.marketplace,
    ),
    RewardModel(
      title: "Music Celebration: Highland Park",
      description: "Complimentary Craft Beer for the Event attendees.",
      expiryDate: "24 Nov, 2023",
      points: "50",
      imageUrl:
          "https://images.unsplash.com/photo-1600185365926-3a2ce3cdb9eb?auto=format&fit=crop&w=400&q=80",
      brandLogoUrl:
          "https://w7.pngwing.com/pngs/384/870/png-transparent-nike-swoosh-logo-brand-nike-angle-active-shirt-black.png",
      type: RewardType.event,
    ),
    RewardModel(
      title: "Nike Air Max 270",
      description: "Comfortable and stylish running shoes.",
      expiryDate: "15 Dec, 2024",
      points: "120",
      imageUrl:
          "https://images.unsplash.com/photo-1542291026-7eec264c27ff?auto=format&fit=crop&w=400&q=80",
      brandLogoUrl:
          "https://w7.pngwing.com/pngs/384/870/png-transparent-nike-swoosh-logo-brand-nike-angle-active-shirt-black.png",
      type: RewardType.marketplace,
    ),
  ];

  void _showFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const RewardsFilterBottomSheet(),
    );
  }

  void _redeemRewardDirectly() {
    // Silent reward redemption
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldColor,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            UIHelper.verticalSpace(12.h),

            // Points Banner
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const RewardsPointDetailsScreen(),
                    ),
                  );
                },
                child: Container(
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
                            "My Point",
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
                            style: TextFontStyle
                                .textStyle14cFFFFFFSFProRounded400
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
              ),
            ),
            UIHelper.verticalSpace(24.h),

            // Toggle Button
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: TicketToggleButton(
                leftLabel: 'Marketplace',
                rightLabel: 'My Rewards',
                selectedIndex: _selectedTabIndex,
                onChanged: (i) => setState(() => _selectedTabIndex = i),
                height: 50.h,
              ),
            ),

            if (_selectedTabIndex == 1) ...[
              UIHelper.verticalSpace(16.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: RewardFilterChips(
                  selectedIndex: _selectedFilterIndex,
                  onChanged: (i) => setState(() => _selectedFilterIndex = i),
                ),
              ),
            ],

            UIHelper.verticalSpace(24.h),

            // Search Bar
            if (_selectedTabIndex == 0) ...[
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
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
            ],

            // Grid or List screen
            Builder(
              builder: (context) {
                final filteredRewards = _selectedTabIndex == 1
                    ? _rewards.where((r) {
                        if (_selectedFilterIndex == 0) return true;
                        if (_selectedFilterIndex == 1)
                          return r.type == RewardType.marketplace;
                        if (_selectedFilterIndex == 2)
                          return r.type == RewardType.event;
                        return true;
                      }).toList()
                    : _rewards;

                if (_selectedTabIndex == 0) {
                  return GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 16.h,
                      crossAxisSpacing: 16.w,
                      childAspectRatio: 0.41,
                    ),
                    itemCount: filteredRewards.length,
                    itemBuilder: (context, index) {
                      final reward = filteredRewards[index];
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
                  );
                } else {
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    itemCount: filteredRewards.length,
                    itemBuilder: (context, index) {
                      final reward = filteredRewards[index];
                      return Padding(
                        padding: EdgeInsets.only(bottom: 16.h),
                        child: MyRewardCard(
                          title: reward.title,
                          description: reward.description,
                          location: "Kamisama Art Club",
                          claimedDate: "23 Oct, 24",
                          claimedTime: "8:45 PM",
                          imageUrl: reward.imageUrl,
                          type: reward.type == RewardType.marketplace
                              ? "Marketplace"
                              : "Event",
                          onViewDetailsPressed: () {
                            if (reward.type == RewardType.marketplace) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      MarketplaceRewardDetailsScreen(
                                        rewardName: "Complimentary Craft Beer",
                                        rewardLocation: "Divine Art Festival",
                                        dateTime: "Nov 24,23 • 10.00 PM",
                                        rewardOrganizer: "Nike Official Store",
                                        rewardId: "MOT3203920212",
                                      ),
                                ),
                              );
                            } else {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => RewardDetailsScreen(
                                    eventName:
                                        "Music Celebration: Highland Park, Alaska",
                                    eventLocation: "Alaska 99611, USA",
                                    eventDateTime: "Nov 24,23 • 10.00 PM",
                                    eventOrganizer: "Music of Tour",
                                    ticketId: "MOT3203920212",
                                    rewardName: reward.title,
                                    rewardDateTime: "Nov 24,23 • 10.00 PM",
                                  ),
                                ),
                              );
                            }
                          },
                        ),
                      );
                    },
                  );
                }
              },
            ),
            UIHelper.verticalSpace(24.h),
          ],
        ),
      ),
    );
  }
}
