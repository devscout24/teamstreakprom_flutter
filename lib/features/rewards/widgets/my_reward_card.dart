import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../gen/colors.gen.dart';
import '../../../constants/text_font_style.dart';
import '../../../helpers/ui_helpers.dart';
import '../../../common_widgets/app_network_image.dart';
import '../../../common_widgets/custom_gradient_button.dart';

class MyRewardCard extends StatelessWidget {
  final String title;
  final String description;
  final String location;
  final String claimedDate;
  final String claimedTime;
  final String imageUrl;
  final String type;
  final VoidCallback onViewDetailsPressed;

  const MyRewardCard({
    super.key,
    required this.title,
    required this.description,
    required this.location,
    required this.claimedDate,
    required this.claimedTime,
    required this.imageUrl,
    required this.type,
    required this.onViewDetailsPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.c242A34,
        borderRadius: BorderRadius.circular(24.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image Container
              Container(
                width: 88.w,
                height: 88.w,
                decoration: BoxDecoration(
                  color: const Color(0xFF23262F),
                  borderRadius: BorderRadius.circular(16.r),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16.r),
                  child: AppNetworkImage(imageUrl: imageUrl, fit: BoxFit.cover),
                ),
              ),
              UIHelper.horizontalSpace(16.w),
              // Text Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextFontStyle.textStyle14cFFFFFFSFProRounded400
                          .copyWith(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColors.cFFFFFF,
                          ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    UIHelper.verticalSpace(6.h),
                    Text(
                      description,
                      style: TextFontStyle.textStyle14cFFFFFFSFProRounded400
                          .copyWith(
                            color: AppColors.cADADAD,
                            fontSize: 12.sp,
                            height: 1.4,
                          ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    UIHelper.verticalSpace(8.h),
                    Row(
                      children: [
                        Icon(
                          Icons.location_on_outlined,
                          color: Colors.white.withValues(alpha: 0.8),
                          size: 16.sp,
                        ),
                        UIHelper.horizontalSpace(4.w),
                        Expanded(
                          child: Text(
                            location,
                            style: TextFontStyle
                                .textStyle14cFFFFFFSFProRounded400
                                .copyWith(
                                  color: AppColors.cD9D9D9,
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w700,
                                  fontFamily: "SF Pro",
                                ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          UIHelper.verticalSpace(16.h),
          // Claimed Row
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: "Claimed : ",
                        style: TextFontStyle.textStyle14cFFFFFFSFProRounded400
                            .copyWith(
                              color: const Color(0xFFF28F31), // Orange color
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                      TextSpan(
                        text: "$claimedDate  •  $claimedTime",
                        style: TextFontStyle.textStyle14cFFFFFFSFProRounded400
                            .copyWith(
                              color: AppColors.cADADAD,
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w500,
                              fontFamily: "SF Pro",
                            ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: AppColors.c2A313C,
                  borderRadius: BorderRadius.circular(100.r),
                ),
                child: Text(
                  type,
                  style: TextFontStyle.textStyle14cFFFFFFSFProRounded400
                      .copyWith(
                        color: type.toLowerCase() == "event"
                            ? const Color(0xFF45A93D)
                            : AppColors.cFFFFFF,
                        fontSize: 12.sp,
                      ),
                ),
              ),
            ],
          ),
          UIHelper.verticalSpace(16.h),
          // Dashed Divider
          LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              final boxWidth = constraints.constrainWidth();
              final dashWidth = 4.w;
              final dashHeight = 1.h;
              final dashCount = (boxWidth / (2 * dashWidth)).floor();
              return Flex(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                direction: Axis.horizontal,
                children: List.generate(dashCount, (_) {
                  return SizedBox(
                    width: dashWidth,
                    height: dashHeight,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                      ),
                    ),
                  );
                }),
              );
            },
          ),
          UIHelper.verticalSpace(16.h),
          // View Details Button
          CustomGradientButton(
            onPressed: onViewDetailsPressed,
            title: "View Details",
            height: 48.h,
            borderRadius: BorderRadius.circular(100.r),
            textStyle: TextFontStyle.textStyle14cFFFFFFSFProRounded400.copyWith(
              color: const Color(0xFF181A20),
              fontWeight: FontWeight.w700,
              fontSize: 16.sp,
            ),
          ),
        ],
      ),
    );
  }
}
