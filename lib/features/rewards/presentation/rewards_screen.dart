import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:teamstreakpromo/features/rewards/widgets/filter_bottom_sheet.dart';
import '../../../gen/colors.gen.dart';
import '../../../constants/text_font_style.dart';
import '../../../gen/assets.gen.dart';
import '../../../helpers/ui_helpers.dart';
import '../../home/model/reward_model.dart';
import '../../../common_widgets/app_network_image.dart';
import '../../event/presentation/event_details_screen.dart';
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
                  return Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        final itemWidth = (constraints.maxWidth - 16.w) / 2;
                        return Wrap(
                          spacing: 16.w,
                          runSpacing: 16.h,
                          children: filteredRewards.map((reward) {
                            return SizedBox(
                              width: itemWidth,
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => EventDetailsScreen(
                                        title: reward.title,
                                        location: "Divine Art Festival",
                                        date: reward.expiryDate,
                                        price: "${reward.points} pts",
                                        imageUrl: reward.imageUrl,
                                        description: reward.description,
                                        points: reward.points,
                                        isReward: true,
                                      ),
                                    ),
                                  );
                                },
                                child: Container(
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF1E222B),
                                    borderRadius: BorderRadius.circular(24.r),
                                    border: Border.all(
                                      color: Colors.white.withValues(
                                        alpha: 0.05,
                                      ),
                                      width: 1.w,
                                    ),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.all(8.w),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        // Product Image Container
                                        Container(
                                          height: 140.h,
                                          width: double.infinity,
                                          decoration: BoxDecoration(
                                            color: const Color.fromRGBO(
                                              134,
                                              134,
                                              134,
                                              0.10,
                                            ),
                                            borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(16.r),
                                              topRight: Radius.circular(16.r),
                                            ),
                                          ),
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(16.r),
                                              topRight: Radius.circular(16.r),
                                            ),
                                            child: AppNetworkImage(
                                              imageUrl: reward.imageUrl,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                        UIHelper.verticalSpace(12.h),
                                        // Product Title
                                        Text(
                                          reward.title,
                                          style: TextFontStyle
                                              .textStyle24cFFFFFFSFPro590
                                              .copyWith(
                                                fontSize: 12.sp,
                                                color: AppColors.cFFF9F3,
                                                fontWeight: FontWeight.w600,
                                              ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        UIHelper.verticalSpace(8.h),
                                        // Description
                                        Text(
                                          reward.description,
                                          style: TextFontStyle
                                              .textStyle14cFFFFFFSFProRounded400
                                              .copyWith(
                                                color: AppColors.cC6C6C6,
                                                fontSize: 10.sp,
                                                height: 1.4,
                                              ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        UIHelper.verticalSpace(8.h),
                                        // Expiry date info line
                                        RichText(
                                          text: TextSpan(
                                            text: "Exp: ",
                                            style: TextFontStyle
                                                .textStyle14cFFFFFFSFProRounded400
                                                .copyWith(
                                                  color: const Color(
                                                    0xFFF28F31,
                                                  ),
                                                  fontSize: 10.sp,
                                                  fontWeight: FontWeight.w600,
                                                  fontFamily: 'SF Pro',
                                                ),
                                            children: [
                                              TextSpan(
                                                text: reward.expiryDate,
                                                style: TextStyle(
                                                  color: AppColors.cE9EAE9,
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 12.sp,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        UIHelper.verticalSpace(10.h),
                                        // Brand logo and points row
                                        // Row(
                                        //   mainAxisAlignment:
                                        //       MainAxisAlignment.spaceBetween,
                                        //   children: [
                                        //     // Brand logo
                                        //     Container(
                                        //       width: 28.h,
                                        //       height: 28.h,
                                        //       decoration: const BoxDecoration(
                                        //         color: Colors.white,
                                        //         shape: BoxShape.circle,
                                        //       ),
                                        //       child: Center(
                                        //         child: ClipOval(
                                        //           child: AppNetworkImage(
                                        //             imageUrl:
                                        //                 reward.brandLogoUrl,
                                        //             width: 18.h,
                                        //             height: 18.h,
                                        //             fit: BoxFit.contain,
                                        //           ),
                                        //         ),
                                        //       ),
                                        //     ),
                                        //     // Points badge
                                        //     Container(
                                        //       padding: EdgeInsets.symmetric(
                                        //         horizontal: 8.w,
                                        //         vertical: 4.h,
                                        //       ),
                                        //       decoration: BoxDecoration(
                                        //         color: const Color(0xFF2C3138),
                                        //         borderRadius:
                                        //             BorderRadius.circular(
                                        //               100.r,
                                        //             ),
                                        //       ),
                                        //       child: Row(
                                        //         mainAxisSize: MainAxisSize.min,
                                        //         children: [
                                        //           Icon(
                                        //             Icons.emoji_events_outlined,
                                        //             color: Colors.white,
                                        //             size: 14.sp,
                                        //           ),
                                        //           UIHelper.horizontalSpace(4.w),
                                        //           Text(
                                        //             "${reward.points} pts",
                                        //             style: TextFontStyle
                                        //                 .textStyle14cFFFFFFSFProRounded400
                                        //                 .copyWith(
                                        //                   fontWeight:
                                        //                       FontWeight.w500,
                                        //                   fontSize: 12.sp,
                                        //                 ),
                                        //           ),
                                        //         ],
                                        //       ),
                                        //     ),
                                        //   ],
                                        // ),
                                        // UIHelper.verticalSpace(12.h),
                                        // // Redeem Reward button
                                        // CustomGradientButton(
                                        //   title: "Redeem Reward",
                                        //   height: 32.h,
                                        //   textStyle: TextFontStyle
                                        //       .textStyle14cFFFFFFSFProRounded400
                                        //       .copyWith(
                                        //         color: const Color(0xFF1E222B),
                                        //         fontWeight: FontWeight.w600,
                                        //         fontSize: 14.sp,
                                        //       ),
                                        //   onPressed: _redeemRewardDirectly,
                                        // ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        );
                      },
                    ),
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
