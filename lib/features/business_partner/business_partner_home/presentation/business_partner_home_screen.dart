import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:teamstreakpromo/common_widgets/host_app_bar.dart';
import 'package:teamstreakpromo/networks/api_acess.dart';
import 'package:teamstreakpromo/features/settings/model/user_profile_model.dart';
import 'package:teamstreakpromo/networks/endpoints.dart';
import 'package:teamstreakpromo/gen/colors.gen.dart';
import 'package:teamstreakpromo/helpers/ui_helpers.dart';
import 'package:teamstreakpromo/constants/text_font_style.dart';
import 'package:teamstreakpromo/features/host_features/host_home/widget/host_stat_card.dart';
import 'package:teamstreakpromo/features/business_partner/business_partner_home/widget/reward_sell_chart_card.dart';
import 'package:teamstreakpromo/features/business_partner/business_partner_home/widget/business_partner_active_reward_card.dart';
import 'package:teamstreakpromo/features/business_partner/business_partner_home/presentation/business_partner_active_rewards_screen.dart';

class BusinessPartnerHomeScreen extends StatefulWidget {
  const BusinessPartnerHomeScreen({super.key});

  @override
  State<BusinessPartnerHomeScreen> createState() =>
      _BusinessPartnerHomeScreenState();
}

class _BusinessPartnerHomeScreenState extends State<BusinessPartnerHomeScreen> {
  @override
  void initState() {
    super.initState();
    _fetchProfile();
  }

  Future<void> _fetchProfile() async {
    try {
      await userProfileRxObj.fetchUserProfile();
    } catch (e) {
      debugPrint("Error fetching profile: $e");
    }
  }

  final List<Map<String, dynamic>> _activeRewards = const [
    {
      "imageUrl":
          "https://images.unsplash.com/photo-1521572163474-6864f9cf17ab?q=80&w=300&auto=format&fit=crop",
      "title": "SoundWave Music Festival",
      "location": "Divine Art Festival",
      "expiryDate": "Sep 30, 2025",
      "claimedCount": 55,
      "leftCount": 8,
    },
    {
      "imageUrl":
          "https://images.unsplash.com/photo-1596755094514-f87e32f85e2c?q=80&w=300&auto=format&fit=crop",
      "title": "Tech Innovations Summit",
      "location": "Divine Art Festival",
      "expiryDate": "Jan 10, 2026",
      "claimedCount": 5,
      "leftCount": 30,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldColor,
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: SafeArea(
          child: StreamBuilder<UserProfileModel>(
            stream: userProfileRxObj.userProfileData,
            builder: (context, snapshot) {
              final profile = snapshot.data?.data ??
                  userProfileRxObj.userProfileData.valueOrNull?.data;

              final name = profile?.name ?? "Business Partner";
              final location = profile?.businessProfile?.location ??
                  profile?.businessProfile?.businessName ??
                  "Location";
              String? profileImageUrl = profile?.profileImage;
              if (profileImageUrl != null &&
                  profileImageUrl.isNotEmpty &&
                  !profileImageUrl.startsWith('http')) {
                profileImageUrl = url + profileImageUrl;
              }

              final isLoading = profile == null;

              return Column(
                children: [
                  HostAppBar(
                    isLoading: isLoading,
                    name: name,
                    location: location,
                    avatarUrl: profileImageUrl,
                    points: profile?.totalPoints ?? 0,
                    notificationCount: 0,
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                // Search Bar
                Container(
                  height: 52.h,
                  decoration: BoxDecoration(
                    color: AppColors.c1E222B,
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
                      UIHelper.horizontalSpace(12),
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
                    ],
                  ),
                ),
                UIHelper.verticalSpace(24),

                // Stat Cards
                Row(
                  children: [
                    Expanded(
                      child: HostStatCard(
                        title: "Total rewards claimed",
                        value: "12,450",
                        icon: Icons.check_box_outlined,
                        iconColor: Colors.blueAccent,
                        circleBgColor: Colors.blueAccent.withValues(
                          alpha: 0.15,
                        ),
                      ),
                    ),
                    UIHelper.horizontalSpace(16),
                    Expanded(
                      child: HostStatCard(
                        title: "Store Visits",
                        value: "12,450",
                        icon: Icons.people_outline_rounded,
                        iconColor: Colors.greenAccent,
                        circleBgColor: Colors.greenAccent.withValues(
                          alpha: 0.15,
                        ),
                      ),
                    ),
                  ],
                ),
                UIHelper.verticalSpace(24),

                // Chart Card
                const RewardSellChartCard(),
                UIHelper.verticalSpace(24),

                // Active Rewards Section
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Active Rewards",
                      style: TextFontStyle.textStyle16cFFFFFFSFProRounded700,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                BusinessPartnerActiveRewardsScreen(
                                  activeRewards: _activeRewards,
                                ),
                          ),
                        );
                      },
                      behavior: HitTestBehavior.opaque,
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8.w,
                          vertical: 4.h,
                        ),
                        child: Text(
                          "See All",
                          style: TextFontStyle.textStyle12cFFFFFFSFPro600
                              .copyWith(decoration: TextDecoration.underline),
                        ),
                      ),
                    ),
                  ],
                ),
                UIHelper.verticalSpace(16),

                // Rewards List
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _activeRewards.length,
                  separatorBuilder: (context, index) =>
                      UIHelper.verticalSpace(16),
                  itemBuilder: (context, index) {
                    final reward = _activeRewards[index];
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
                UIHelper.verticalSpace(24),
              ],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
