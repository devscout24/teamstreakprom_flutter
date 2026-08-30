import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:teamstreakpromo/features/rewards/widgets/filter_bottom_sheet.dart';
import '../../../gen/colors.gen.dart';
import '../../../constants/text_font_style.dart';
import '../../../gen/assets.gen.dart';
import '../../../helpers/ui_helpers.dart';
import '../../home/model/reward_model.dart';
import '../../../common_widgets/app_network_image.dart';
import '../../../common_widgets/ticket_toggle_button.dart';
import '../widgets/reward_filter_chips.dart';
import '../widgets/my_reward_card.dart';
import 'reward_details_screen.dart';
import 'marketplace_reward_details_screen.dart';
import 'rewards_point_details_screen.dart';
import '../../business_partner/business_partner_rewards/presentation/business_partner_rewards_details_screen.dart';

class RewardsScreen extends StatefulWidget {
  const RewardsScreen({super.key});

  @override
  State<RewardsScreen> createState() => _RewardsScreenState();
}

class _RewardsScreenState extends State<RewardsScreen> {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldColor,
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: SingleChildScrollView(
          child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            UIHelper.verticalSpace(24.h),

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



              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: RewardFilterChips(
                  selectedIndex: _selectedFilterIndex,
                  onChanged: (i) => setState(() => _selectedFilterIndex = i),
                ),
              ),
              UIHelper.verticalSpace(24.h),

            // List screen
            Builder(
              builder: (context) {
                final filteredRewards = _rewards.where((r) {
                  if (_selectedFilterIndex == 0) return true;
                  if (_selectedFilterIndex == 1)
                    return r.type == RewardType.marketplace;
                  if (_selectedFilterIndex == 2)
                    return r.type == RewardType.event;
                  return true;
                }).toList();
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
              },
            ),
            UIHelper.verticalSpace(24.h),
          ],
        ),
      ),
      ),
    );
  }
}
