import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../gen/colors.gen.dart';
import '../../../gen/assets.gen.dart';
import '../../../constants/text_font_style.dart';
import '../../../helpers/ui_helpers.dart';
import '../../../common_widgets/app_network_image.dart';
import '../../../common_widgets/custom_gradient_button.dart';
import '../../event/presentation/event_details_screen.dart';

class RewardCard extends StatelessWidget {
  final String title;
  final String description;
  final String expiryDate;
  final String points;
  final String imageUrl;
  final String brandLogoUrl;
  final VoidCallback onRedeemPressed;
  final double? width;
  final double? height;
  final VoidCallback? onTap;

  const RewardCard({
    super.key,
    required this.title,
    required this.description,
    required this.expiryDate,
    required this.points,
    required this.imageUrl,
    required this.brandLogoUrl,
    required this.onRedeemPressed,
    this.width,
    this.height,
    this.onTap,
  });

  void _navigateToDetails(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EventDetailsScreen(
          title: title,
          location: "Divine Art Festival",
          date: expiryDate,
          price: "$points pts",
          imageUrl: imageUrl,
          description: description,
          points: points,
          isReward: true,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap ?? () => _navigateToDetails(context),
      child: Container(
        width: width ?? 270.w,
        height: height,
        decoration: BoxDecoration(
          color: const Color(0xFF1E222B),
          borderRadius: BorderRadius.circular(24.r),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.05),
            width: 1.w,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Product Image Container
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color(0xFF1B1D2A),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24.r),
                  topRight: Radius.circular(24.r),
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24.r),
                  topRight: Radius.circular(24.r),
                ),
                child: AppNetworkImage(
                  imageUrl: imageUrl,
                  fit: BoxFit.cover,
                  height: 140,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                left: 8.w,
                right: 8.w,
                top: 14.h,
                bottom: 8.h,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Product Title
                  Text(
                    title,
                    style: TextFontStyle.textStyle24cFFFFFFSFPro590.copyWith(
                      fontSize: 14.sp,

                      fontWeight: FontWeight.w700,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  UIHelper.verticalSpace(8.h),
                  // Description
                  Text(
                    description,
                    style: TextFontStyle.textStyle14cFFFFFFSFProRounded400
                        .copyWith(
                          color: AppColors.cC6C6C6,
                          fontSize: 11.sp,
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
                      style: TextFontStyle.textStyle14cFFFFFFSFProRounded400
                          .copyWith(
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
                          horizontal: 12.w,
                          vertical: 8.h,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF23262F),
                          borderRadius: BorderRadius.circular(100.r),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Assets.icons.pointIcon.image(
                              width: 16.w,
                              height: 16.w,
                            ),
                            UIHelper.horizontalSpace(6.w),
                            RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: points,
                                    style: TextFontStyle
                                        .textStyle14cFFFFFFSFProRounded400
                                        .copyWith(
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                  ),
                                  TextSpan(
                                    text: " pts",
                                    style: TextFontStyle
                                        .textStyle14cFFFFFFSFProRounded400
                                        .copyWith(
                                          fontSize: 13.sp,
                                          fontWeight: FontWeight.w400,
                                          color: Colors.white.withValues(
                                            alpha: 0.8,
                                          ),
                                        ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  UIHelper.verticalSpace(20.h),
                  // Redeem Reward Button
                  CustomGradientButton(
                    onPressed: () {
                      onRedeemPressed();
                      _navigateToDetails(context);
                    },
                    title: "Redeem Reward",
                    height: 50.h,
                    textStyle: TextFontStyle.textStyle14cFFFFFFSFProRounded400
                        .copyWith(
                          color: const Color(0xFF181A20),
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
