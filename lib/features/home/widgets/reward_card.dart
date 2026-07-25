import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../gen/colors.gen.dart';
import '../../../constants/text_font_style.dart';
import '../../../helpers/ui_helpers.dart';
import '../../../common_widgets/app_network_image.dart';
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
        child: Padding(
          padding: EdgeInsets.all(8.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Product Image Container
              Container(
                height: 180.h,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color.fromRGBO(134, 134, 134, 0.10),
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
                  color: AppColors.cFFF9F3,
                  fontWeight: FontWeight.w600,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              UIHelper.verticalSpace(8.h),
              // Description
              Text(
                description,
                style: TextFontStyle.textStyle14cFFFFFFSFProRounded400.copyWith(
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
                        color: AppColors.cE9EAE9,
                        fontWeight: FontWeight.w400,
                        fontSize: 12.sp,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
