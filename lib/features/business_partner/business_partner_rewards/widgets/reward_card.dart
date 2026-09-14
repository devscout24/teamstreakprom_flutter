import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../common_widgets/app_network_image.dart';
import '../../../../common_widgets/gradient_container.dart';
import '../../../../constants/text_font_style.dart';
import '../../../../gen/colors.gen.dart';
import '../../../../helpers/ui_helpers.dart';
import '../../../../common_widgets/custom_button.dart';
import '../../../../common_widgets/custom_gradient_button.dart';
import '../../../../networks/api_acess.dart';
import '../model/my_marketplaces_response_model.dart';
import '../presentation/business_partner_create_reward_screen.dart';
import 'package:intl/intl.dart';

class RewardCard extends StatelessWidget {
  final MyMarketplaceData data;
  const RewardCard({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 20.h),
      child: GradientContainer(
        padding: EdgeInsets.all(12.w),
        color: AppColors.c242A34,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            ClipRRect(
              borderRadius: BorderRadius.circular(12.r),
              child: AppNetworkImage(
                imageUrl: data.photos != null && data.photos!.isNotEmpty
                    ? data.photos!.first
                    : "https://images.unsplash.com/photo-1459749411175-04bf5292ceea?q=80&w=600&auto=format&fit=crop",
                height: 140.h,
                width: double.infinity,
              ),
            ),
            UIHelper.verticalSpace(12.h),

            // Title & Active Tag
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    data.title ?? "Unknown Title",
                    style: TextFontStyle.textStyle24cFFFFFFSFPro590.copyWith(
                      fontSize: 12.sp,
                      color: AppColors.cE9EAE9,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 12.w,
                    vertical: 4.h,
                  ),
                  decoration: BoxDecoration(
                    color: (data.isActive ?? false) 
                        ? AppColors.c59B53E.withValues(alpha: 0.2)
                        : Colors.red.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(100.r),
                  ),
                  child: Text(
                    (data.isActive ?? false) ? "Active" : "Inactive",
                    style: TextFontStyle.textStyle14cFFFFFFSFProRounded400
                        .copyWith(
                          fontSize: 10.sp,
                          color: AppColors.c59B53E,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ),
              ],
            ),
            UIHelper.verticalSpace(8.h),

            // Location & Date
            Row(
              children: [
                Icon(
                  Icons.location_on_outlined,
                  color: AppColors.cBCBCBB,
                  size: 14.sp,
                ),
                UIHelper.horizontalSpace(4.w),
                Expanded(
                  child: Text(
                    data.location ?? "Unknown Location",
                    style: TextFontStyle.textStyle14cFFFFFFSFProRounded400
                        .copyWith(color: AppColors.cBCBCBB, fontSize: 12.sp),
                  ),
                ),
                Text(
                  "Exp: ${data.endDateTime != null ? DateFormat('MMM dd, yyyy').format(DateTime.parse(data.endDateTime!).toLocal()) : 'N/A'}",
                  style: TextFontStyle.textStyle14cFFFFFFSFProRounded400
                      .copyWith(
                        color: Colors.white.withValues(alpha: 0.6),
                        fontSize: 12.sp,
                      ),
                ),
              ],
            ),
            UIHelper.verticalSpace(12.h),

            // Bottom Stats & Actions
            GradientContainer(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  AppColors.primaryColorSecond.withValues(alpha: .1),
                  AppColors.cFFFFFF.withValues(alpha: .3),
                ],
              ),
              padding: EdgeInsets.all(12.w),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        Text(
                          "${data.claimQuantity ?? 0}",
                          style: TextFontStyle.textStyle24cFFFFFFSFPro590
                              .copyWith(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        UIHelper.verticalSpace(4.h),
                        Text(
                          "Claimed",
                          style: TextFontStyle.textStyle14cFFFFFFSFProRounded400
                              .copyWith(
                                color: Colors.white.withValues(alpha: 0.6),
                                fontSize: 12.sp,
                              ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 1.w,
                    height: 40.h,
                    color: Colors.white.withValues(alpha: 0.1),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        Text(
                          "${(data.quantity ?? 0) - (data.claimQuantity ?? 0)}",
                          style: TextFontStyle.textStyle24cFFFFFFSFPro590
                              .copyWith(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        UIHelper.verticalSpace(4.h),
                        Text(
                          "Remaining",
                          style: TextFontStyle.textStyle14cFFFFFFSFProRounded400
                              .copyWith(
                                color: Colors.white.withValues(alpha: 0.6),
                                fontSize: 12.sp,
                              ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 1.w,
                    height: 40.h,
                    color: Colors.white.withValues(alpha: 0.1),
                  ),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildActionButton(
                          iconPath: 'assets/icons/delete_icon.png',
                          iconColor: const Color(0xFFC72C2C),
                          onTap: () {
                            _showDeleteBottomSheet(context);
                          },
                        ),
                        _buildActionButton(
                          iconPath: 'assets/icons/edit_icon.png',
                          iconColor: const Color(0xFF1E211A),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    BusinessPartnerCreateRewardScreen(
                                      isEdit: true,
                                      rewardData: data.toMarketplaceDetailsData(),
                                      rewardId: data.id,
                                    ),
                              ),
                            ).then((result) {
                              if (result == true) {
                                getMyMarketplacesRxObj.fetchMyMarketplaces();
                              }
                            });
                          },
                        ),
                      ],
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

  Widget _buildActionButton({
    required String iconPath,
    required Color iconColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(8.w),
        decoration: const BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
        ),
        child: Image.asset(
          iconPath,
          color: iconColor,
          width: 16.sp,
          height: 16.sp,
        ),
      ),
    );
  }

  void _showDeleteBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        bool isLoading = false;
        return StatefulBuilder(
          builder: (context, setState) {
            return Container(
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
              decoration: BoxDecoration(
                color: AppColors.scaffoldColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(32.r),
                  topRight: Radius.circular(32.r),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Delete Reward",
                    style: TextFontStyle.textStyle24cFFFFFFSFPro590.copyWith(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  UIHelper.verticalSpace(16.h),
                  Text(
                    "Are you sure you want to delete this reward? This action cannot be undone.",
                    textAlign: TextAlign.center,
                    style: TextFontStyle.textStyle14cFFFFFFSFProRounded400.copyWith(
                      color: Colors.white.withValues(alpha: 0.7),
                      fontSize: 13.sp,
                      height: 1.5,
                    ),
                  ),
                  UIHelper.verticalSpace(24.h),
                  Divider(
                    color: Colors.white.withValues(alpha: 0.1),
                    thickness: 1.h,
                    height: 1.h,
                  ),
                  UIHelper.verticalSpace(24.h),
                  Row(
                    children: [
                      Expanded(
                        child: CustomButton(
                          onPressed: isLoading ? null : () => Navigator.pop(context),
                          title: "Cancel",
                          height: 48.h,
                          borderRadius: BorderRadius.circular(100.r),
                          backgroundColor: Colors.white,
                          foregroundColor: AppColors.c262824,
                          textStyle: TextFontStyle.textStyle14cFFFFFFSFProRounded400
                              .copyWith(
                                color: AppColors.c262824,
                                fontWeight: FontWeight.w700,
                                fontSize: 14.sp,
                              ),
                        ),
                      ),
                      UIHelper.horizontalSpace(16.w),
                      Expanded(
                        child: CustomGradientButton(
                          onPressed: isLoading
                              ? null
                              : () async {
                                  if (data.id == null) return;
                                  setState(() => isLoading = true);
                                  try {
                                    await deleteMarketplaceRxObj.deleteMarketplace(data.id!);
                                    getMyMarketplacesRxObj.fetchMyMarketplaces();
                                    if (context.mounted) {
                                      Navigator.pop(context);
                                    }
                                  } catch (e) {
                                    setState(() => isLoading = false);
                                    // Handle error if necessary
                                  }
                                },
                          height: 48.h,
                          borderRadius: BorderRadius.circular(100.r),
                          gradient: const LinearGradient(
                            colors: [Color(0xFFC72C2C), Color(0xFF9E1F1F)],
                          ),
                          child: isLoading
                              ? const SizedBox(
                                  height: 24,
                                  width: 24,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                              : Text(
                                  "Delete",
                                  style: TextFontStyle.textStyle14cFFFFFFSFProRounded400
                                      .copyWith(
                                        color: AppColors.c262824,
                                        fontWeight: FontWeight.w700,
                                        fontSize: 14.sp,
                                      ),
                                ),
                        ),
                      ),
                    ],
                  ),
                  UIHelper.verticalSpace(8.h),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
