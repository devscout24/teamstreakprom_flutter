import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:teamstreakpromo/gen/colors.gen.dart';
import 'package:teamstreakpromo/helpers/ui_helpers.dart';

import 'package:teamstreakpromo/common_widgets/gradient_container.dart';

class CustomRewardCard extends StatelessWidget {
  final Map<String, dynamic> reward;
  final VoidCallback onRemove;

  const CustomRewardCard({
    super.key,
    required this.reward,
    required this.onRemove,
  });

  Widget _buildRewardImage(
    dynamic rewardImage, {
    required double width,
    required double height,
  }) {
    if (rewardImage is List && rewardImage.isNotEmpty) {
      return Image.file(
        File(rewardImage[0]),
        width: width,
        height: height,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => Container(
          width: width,
          height: height,
          color: AppColors.c242A34,
          child: Icon(
            Icons.broken_image,
            color: Colors.white.withValues(alpha: 0.5),
          ),
        ),
      );
    } else if (rewardImage is String && rewardImage.startsWith("http")) {
      return Image.network(
        rewardImage,
        width: width,
        height: height,
        fit: BoxFit.cover,
      );
    } else {
      return Container(
        width: width,
        height: height,
        color: AppColors.c242A34,
        child: Icon(
          Icons.card_giftcard,
          color: Colors.white.withValues(alpha: 0.5),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GradientContainer(
      padding: EdgeInsets.all(12.w),
      child: Stack(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // White rounded image container
              Container(
                width: 80.w,
                height: 80.w,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                alignment: Alignment.center,
                clipBehavior: Clip.hardEdge,
                child: _buildRewardImage(
                  reward["image"],
                  width: 80.w,
                  height: 80.w,
                ),
              ),
              UIHelper.horizontalSpace(12),
              // Text Content
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      reward["title"],
                      style: TextStyle(
                        fontFamily: "SF Pro",
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    UIHelper.verticalSpace(6),
                    Text(
                      reward["desc"],
                      style: TextStyle(
                        fontFamily: "SF Pro",
                        fontSize: 10.sp,
                        color: AppColors.cBCBCBB,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    UIHelper.verticalSpace(8),
                    Text(
                      "Available In ${reward['qty']}pcs",
                      style: TextStyle(
                        fontFamily: "SF Pro",
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w600,
                        color: const Color(
                          0xFF45A93D,
                        ), // Green text from screenshot
                      ),
                    ),
                  ],
                ),
              ),
              // Space for close button
              UIHelper.horizontalSpace(32),
            ],
          ),
          // Close button positioned top right
          Positioned(
            top: 0,
            right: 0,
            child: GestureDetector(
              onTap: onRemove,
              child: Container(
                padding: EdgeInsets.all(8.w),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.close_rounded, color: Colors.red, size: 16.w),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
