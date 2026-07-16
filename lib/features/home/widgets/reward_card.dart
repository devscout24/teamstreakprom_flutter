import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../gen/colors.gen.dart';
import '../../../gen/assets.gen.dart';
import '../../../constants/text_font_style.dart';
import '../../../helpers/ui_helpers.dart';
import '../../../common_widgets/app_network_image.dart';
import '../../../common_widgets/custom_gradient_button.dart';

class RewardCard extends StatelessWidget {
  final String title;
  final String description;
  final String expiryDate;
  final String points;
  final String imageUrl;
  final String brandLogoUrl;
  final VoidCallback onRedeemPressed;

  const RewardCard({
    super.key,
    required this.title,
    required this.description,
    required this.expiryDate,
    required this.points,
    required this.imageUrl,
    required this.brandLogoUrl,
    required this.onRedeemPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 270.w,
      decoration: BoxDecoration(
        color: const Color(0xFF1E222B),
        borderRadius: BorderRadius.circular(24.r),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.05),
          width: 1.w,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(12.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Product Image Container
            Container(
              height: 120.h,
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color(0xFF131722),
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16.r),
                child: AppNetworkImage(imageUrl: imageUrl, fit: BoxFit.cover),
              ),
            ),
            UIHelper.verticalSpace(12.h),
            // Product Title
            Text(
              title,
              style: TextFontStyle.textStyle24cFFFFFFSFPro590.copyWith(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            UIHelper.verticalSpace(4.h),
            // Description
            Text(
              description,
              style: TextFontStyle.textStyle14cFFFFFFSFProRounded400.copyWith(
                color: Colors.white.withValues(alpha: 0.5),
                fontSize: 12.sp,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            UIHelper.verticalSpace(8.h),
            // Expiry date info line
            RichText(
              text: TextSpan(
                text: "Exp: ",
                style: TextFontStyle.textStyle14cFFFFFFSFProRounded400.copyWith(
                  color: const Color(0xFFF28F31),
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'SF Pro',
                ),
                children: [
                  TextSpan(
                    text: expiryDate,
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.6),
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
            UIHelper.verticalSpace(12.h),
            // Brand Logo and Points badge Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Brand Logo circle
                Container(
                  width: 32.w,
                  height: 32.w,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  padding: EdgeInsets.all(4.w),
                  child: ClipOval(
                    child: AppNetworkImage(
                      imageUrl: brandLogoUrl,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                // Points badge pill
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 10.w,
                    vertical: 6.h,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF131722),
                    borderRadius: BorderRadius.circular(100.r),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ShaderMask(
                        shaderCallback: (bounds) => const LinearGradient(
                          colors: [
                            AppColors.primaryColorFirst,
                            AppColors.primaryColorSecond,
                          ],
                        ).createShader(bounds),
                        blendMode: BlendMode.srcIn,
                        child: Image.asset(
                          Assets.icons.pointIcon.path,
                          width: 14.w,
                          height: 14.w,
                          color: Colors.white,
                        ),
                      ),
                      UIHelper.horizontalSpace(4.w),
                      Text(
                        "$points pts",
                        style: TextFontStyle.textStyle14cFFFFFFSFProRounded400
                            .copyWith(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w600,
                              color: Colors.white.withValues(alpha: 0.9),
                            ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            UIHelper.verticalSpace(12.h),
            // Redeem Reward Button
            CustomGradientButton(
              onPressed: onRedeemPressed,
              title: "Redeem Reward",
              height: 40.h,
              borderRadius: BorderRadius.circular(20.r),
              textStyle: TextFontStyle.textStyle14cFFFFFFSFProRounded400
                  .copyWith(
                    color: AppColors.c262824,
                    fontWeight: FontWeight.w700,
                    fontSize: 14.sp,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
