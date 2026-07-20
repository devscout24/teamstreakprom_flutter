import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:teamstreakpromo/features/host_features/host_events/model/event_model.dart';
import 'package:teamstreakpromo/gen/colors.gen.dart';
import 'package:teamstreakpromo/helpers/ui_helpers.dart';

class WizardStepSix extends StatelessWidget {
  final String eventName;
  final String location;
  final String eventDesc;
  final List<ArtistFormModel> artistForms;
  final String? selectedAgeRestriction;
  final List<Map<String, dynamic>> rewards;
  final VoidCallback onPostEvent;

  const WizardStepSix({
    super.key,
    required this.eventName,
    required this.location,
    required this.eventDesc,
    required this.artistForms,
    required this.selectedAgeRestriction,
    required this.rewards,
    required this.onPostEvent,
  });

  Widget _buildRewardImage(dynamic rewardImage, {required double width, required double height}) {
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
          child: Icon(Icons.broken_image, color: Colors.white.withValues(alpha: 0.5)),
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
        child: Icon(Icons.card_giftcard, color: Colors.white.withValues(alpha: 0.5)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final firstReward = rewards.isNotEmpty ? rewards[0] : null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Overview",
          style: TextStyle(
            fontFamily: "SF Pro Rounded",
            fontSize: 20.sp,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
        UIHelper.verticalSpace(8),
        Text(
          "Double check your information before making your event live.",
          style: TextStyle(
            fontFamily: "SF Pro",
            fontSize: 14.sp,
            color: Colors.white.withValues(alpha: 0.5),
          ),
        ),
        UIHelper.verticalSpace(24),

        // Event Information Section
        Text(
          "Event Information",
          style: TextStyle(
            fontFamily: "SF Pro Rounded",
            fontSize: 16.sp,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
        UIHelper.verticalSpace(12),

        Container(
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: const Color(0xFF1E222B),
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.08),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Event Name
              Text(
                eventName.isEmpty ? "Adidas Court block Shoes" : eventName,
                style: TextStyle(
                  fontFamily: "SF Pro Rounded",
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
              UIHelper.verticalSpace(6),
              // Location
              Row(
                children: [
                  Icon(Icons.location_on_outlined, color: Colors.white.withValues(alpha: 0.4), size: 14.w),
                  UIHelper.horizontalSpace(4),
                  Text(
                    location.isEmpty ? "Divine Art Festival" : location,
                    style: TextStyle(
                      fontFamily: "SF Pro",
                      fontSize: 12.sp,
                      color: Colors.white.withValues(alpha: 0.5),
                    ),
                  ),
                ],
              ),
              UIHelper.verticalSpace(14),

              // Description Title
              Text(
                "Description",
                style: TextStyle(
                  fontFamily: "SF Pro Rounded",
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.white.withValues(alpha: 0.6),
                ),
              ),
              UIHelper.verticalSpace(6),
              // Description Value
              Text(
                eventDesc.isEmpty
                    ? "Experience unmatched comfort with NIKE Men's Sneakers. Crafted for durability, they feature a breathable upper and cushioned sole, ensuring you stay light on your feet. The stylish design seamlessly blends with any outfit, making them a versatile choice for any occasion."
                    : eventDesc,
                style: TextStyle(
                  fontFamily: "SF Pro",
                  fontSize: 12.sp,
                  color: Colors.white.withValues(alpha: 0.4),
                  height: 1.4,
                ),
              ),
              UIHelper.verticalSpace(16),

              // Artist Info Section (Displaying all dynamic artists)
              Text(
                "Artist Info",
                style: TextStyle(
                  fontFamily: "SF Pro Rounded",
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.white.withValues(alpha: 0.6),
                ),
              ),
              UIHelper.verticalSpace(8),

              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: artistForms.length,
                separatorBuilder: (context, index) => UIHelper.verticalSpace(14),
                itemBuilder: (context, index) {
                  final artist = artistForms[index];
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 18.r,
                            backgroundColor: AppColors.c242A34,
                            backgroundImage: artist.photoPath != null
                                ? FileImage(File(artist.photoPath!)) as ImageProvider
                                : const NetworkImage(
                                    "https://images.unsplash.com/photo-1539571696357-5a69c17a67c6?q=80&w=150&auto=format&fit=crop",
                                  ),
                          ),
                          UIHelper.horizontalSpace(10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                artist.nameController.text.isEmpty ? "Artist Name" : artist.nameController.text,
                                style: TextStyle(
                                  fontFamily: "SF Pro Rounded",
                                  fontSize: 13.sp,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                artist.designationController.text.isEmpty ? "Designation" : artist.designationController.text,
                                style: TextStyle(
                                  fontFamily: "SF Pro",
                                  fontSize: 11.sp,
                                  color: Colors.white.withValues(alpha: 0.4),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      UIHelper.verticalSpace(8),
                      // Media Links for this artist
                      Text(
                        "Media Links",
                        style: TextStyle(
                          fontFamily: "SF Pro Rounded",
                          fontSize: 11.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.white.withValues(alpha: 0.4),
                        ),
                      ),
                      UIHelper.verticalSpace(4),
                      Row(
                        children: artist.socialLinks.map((social) {
                          IconData iconData;
                          if (social.platform == "Facebook") {
                            iconData = Icons.facebook;
                          } else if (social.platform == "Instagram") {
                            iconData = Icons.alternate_email;
                          } else if (social.platform == "Twitter") {
                            iconData = Icons.flutter_dash;
                          } else {
                            iconData = Icons.link;
                          }
                          return Padding(
                            padding: EdgeInsets.only(right: 8.w),
                            child: Icon(iconData, color: AppColors.primaryColorSecond, size: 16.w),
                          );
                        }).toList(),
                      ),
                    ],
                  );
                },
              ),
              UIHelper.verticalSpace(14),

              // Date & Seats Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(Icons.calendar_today_outlined, color: Colors.white.withValues(alpha: 0.4), size: 14.w),
                      UIHelper.horizontalSpace(6),
                      Text(
                        "Event Date : Aug 28, 2026",
                        style: TextStyle(
                          fontFamily: "SF Pro",
                          fontSize: 12.sp,
                          color: Colors.white.withValues(alpha: 0.5),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                    decoration: BoxDecoration(
                      color: AppColors.primaryColorFirst.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Text(
                      "4 seat remaining",
                      style: TextStyle(
                        fontFamily: "SF Pro Rounded",
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w800,
                        color: AppColors.primaryColorFirst,
                      ),
                    ),
                  ),
                ],
              ),
              UIHelper.verticalSpace(16),

              // Age Restriction Notice Box
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
                decoration: BoxDecoration(
                  color: AppColors.primaryColorFirst.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info_outline_rounded, color: AppColors.primaryColorFirst, size: 16.w),
                    UIHelper.horizontalSpace(8),
                    Expanded(
                      child: Text(
                        "This event is only for who are above ${selectedAgeRestriction ?? '18'} years old.",
                        style: TextStyle(
                          fontFamily: "SF Pro",
                          fontSize: 11.sp,
                          color: AppColors.primaryColorFirst,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        UIHelper.verticalSpace(24),

        // Reward Information Section
        Text(
          "Reward Information",
          style: TextStyle(
            fontFamily: "SF Pro Rounded",
            fontSize: 16.sp,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
        UIHelper.verticalSpace(12),

        Container(
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: const Color(0xFF1E222B),
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.08),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Reward Name
              Text(
                firstReward != null ? firstReward["title"] : "Adidas Court block Shoes",
                style: TextStyle(
                  fontFamily: "SF Pro Rounded",
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
              UIHelper.verticalSpace(10),

              // Reward Desc Title
              Text(
                "Reward Description",
                style: TextStyle(
                  fontFamily: "SF Pro Rounded",
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.white.withValues(alpha: 0.6),
                ),
              ),
              UIHelper.verticalSpace(6),
              // Reward Desc Value
              Text(
                firstReward != null
                    ? firstReward["desc"]
                    : "Experience unmatched comfort with NIKE Men's Sneakers. Crafted for durability, they feature a breathable upper and cushioned sole, ensuring you stay light on your feet. The stylish design seamlessly blends with any outfit, making them a versatile choice for any occasion.",
                style: TextStyle(
                  fontFamily: "SF Pro",
                  fontSize: 12.sp,
                  color: Colors.white.withValues(alpha: 0.4),
                  height: 1.4,
                ),
              ),
              UIHelper.verticalSpace(14),

              // Qty remaining badge
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: AppColors.primaryColorFirst.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Text(
                  "${firstReward != null ? firstReward['qty'] : 4} reward remaining",
                  style: TextStyle(
                    fontFamily: "SF Pro Rounded",
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w800,
                    color: AppColors.primaryColorFirst,
                  ),
                ),
              ),
              UIHelper.verticalSpace(16),

              // Reward Photo (Displaying first uploaded file or network fallback)
              ClipRRect(
                borderRadius: BorderRadius.circular(12.r),
                child: firstReward != null
                    ? _buildRewardImage(firstReward["image"], width: double.infinity, height: 180.h)
                    : Image.network(
                        "https://images.unsplash.com/photo-1542291026-7eec264c27ff?q=80&w=400&auto=format&fit=cover",
                        width: double.infinity,
                        height: 180.h,
                        fit: BoxFit.cover,
                      ),
              ),
            ],
          ),
        ),
        UIHelper.verticalSpace(36),

        // Post Event Button
        _buildPostEventButton(onPostEvent),
        UIHelper.verticalSpace(40),
      ],
    );
  }

  Widget _buildPostEventButton(VoidCallback onPressed) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 16.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.r),
          gradient: const LinearGradient(
            colors: [
              Color(0xFFF28F31),
              Color(0xFF72E84F),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        alignment: Alignment.center,
        child: Text(
          "Post Event",
          style: TextStyle(
            fontFamily: "SF Pro Rounded",
            fontSize: 16.sp,
            fontWeight: FontWeight.w800,
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}
