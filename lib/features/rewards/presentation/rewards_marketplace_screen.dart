import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../gen/colors.gen.dart';
import '../../../constants/text_font_style.dart';
import '../../../helpers/ui_helpers.dart';
import '../../../common_widgets/custom_app_bar.dart';
import '../../home/widgets/filter_bottom_sheet.dart';
import '../../home/widgets/reward_card.dart';
import '../../home/model/reward_model.dart';
import '../../../common_widgets/app_network_image.dart';
import '../../business_partner/business_partner_rewards/presentation/business_partner_rewards_details_screen.dart';

class RewardsMarketplaceScreen extends StatefulWidget {
  const RewardsMarketplaceScreen({super.key});

  @override
  State<RewardsMarketplaceScreen> createState() =>
      _RewardsMarketplaceScreenState();
}

class _RewardsMarketplaceScreenState extends State<RewardsMarketplaceScreen> {
  int _selectedCategoryIndex = 0;

  static const List<String> _categories = [
    'All',
    'Clothing',
    'Electronics',
    'Food',
    'Travel',
  ];

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.c121212,

      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            UIHelper.verticalSpace(12.h),
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
            Expanded(
              child: GridView.builder(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12.w,
                  mainAxisSpacing: 16.h,
                  childAspectRatio: 0.55,
                ),
                itemCount: _rewards.length,
                itemBuilder: (context, index) {
                  final reward = _rewards[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              const BusinessPartnerRewardsDetailsScreen(),
                        ),
                      );
                    },
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: const Color(0xFF1E222B),
                        borderRadius: BorderRadius.circular(24.r),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.05),
                          width: 1.w,
                        ),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(8.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
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
                              style: TextFontStyle.textStyle24cFFFFFFSFPro590
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
                            UIHelper.verticalSpace(20.h),
                            // Expiry date info line
                            RichText(
                              text: TextSpan(
                                text: "Exp: ",
                                style: TextFontStyle
                                    .textStyle14cFFFFFFSFProRounded400
                                    .copyWith(
                                      color: const Color(0xFFF28F31),
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
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
