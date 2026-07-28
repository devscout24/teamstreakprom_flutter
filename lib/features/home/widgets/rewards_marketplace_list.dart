import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:teamstreakpromo/features/rewards/presentation/rewards_marketplace_screen.dart';
import '../../../gen/colors.gen.dart';
import '../../../constants/text_font_style.dart';
import '../../../helpers/ui_helpers.dart';
import '../model/reward_model.dart';
import 'reward_card.dart';

import '../../../common_widgets/custom_gradient_button.dart';

class RewardsMarketplaceList extends StatelessWidget {
  final VoidCallback? onSeeAllTapped;
  const RewardsMarketplaceList({super.key, this.onSeeAllTapped});

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

  void _showRedeemBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1E222B),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28.r)),
      ),
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.fromLTRB(24.w, 32.h, 24.w, 32.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Confirmation Redeem",
                style: TextFontStyle.textStyle24cFFFFFFSFPro590.copyWith(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              UIHelper.verticalSpace(12.h),
              Text(
                "Please ensure an employee is present before redeeming this reward.",
                style: TextFontStyle.textStyle14cFFFFFFSFProRounded400.copyWith(
                  color: Colors.white.withValues(alpha: 0.6),
                  fontSize: 14.sp,
                ),
                textAlign: TextAlign.center,
              ),
              UIHelper.verticalSpace(24.h),
              Divider(color: Colors.white.withValues(alpha: 0.08), height: 1.h),
              UIHelper.verticalSpace(24.h),
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 48.h,
                      child: ElevatedButton(
                        onPressed: () => Navigator.pop(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: const Color(0xFF1E222B),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(100.r),
                          ),
                          elevation: 0,
                        ),
                        child: Text(
                          "Cancel",
                          style: TextFontStyle.textStyle14cFFFFFFSFProRounded400
                              .copyWith(
                                color: const Color(0xFF1E222B),
                                fontWeight: FontWeight.w600,
                                fontSize: 15.sp,
                              ),
                        ),
                      ),
                    ),
                  ),
                  UIHelper.horizontalSpace(16.w),
                  Expanded(
                    child: CustomGradientButton(
                      onPressed: () {
                        // Confirm action
                        Navigator.pop(context);
                      },
                      title: "Confirm",
                      height: 48.h,
                      borderRadius: BorderRadius.circular(100.r),
                      textStyle: TextFontStyle.textStyle14cFFFFFFSFProRounded400
                          .copyWith(
                            color: const Color(0xFF262824),
                            fontWeight: FontWeight.w700,
                            fontSize: 15.sp,
                          ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Rewards Marketplace",
                style: TextFontStyle.textStyle24cFFFFFFSFPro590.copyWith(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              GestureDetector(
                onTap:
                    onSeeAllTapped ??
                    () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              const RewardsMarketplaceScreen(),
                        ),
                      );
                    },
                child: Text(
                  "See All",
                  style: TextFontStyle.textStyle14cFFFFFFSFProRounded400
                      .copyWith(
                        color: AppColors.cFFFFFF,
                        fontWeight: FontWeight.w500,
                        fontSize: 12.sp,
                        decoration: TextDecoration.underline,
                        decorationColor: AppColors.cFFFFFF,
                      ),
                ),
              ),
            ],
          ),
        ),
        UIHelper.verticalSpace(16.h),
        SizedBox(
          height: 280.h,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            itemCount: _rewards.length,
            itemBuilder: (context, index) {
              final reward = _rewards[index];
              return Padding(
                padding: EdgeInsets.only(right: 16.w),
                child: RewardCard(
                  title: reward.title,
                  description: reward.description,
                  expiryDate: reward.expiryDate,
                  points: reward.points,
                  imageUrl: reward.imageUrl,
                  brandLogoUrl: reward.brandLogoUrl,
                  onRedeemPressed: () => _showRedeemBottomSheet(context),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
