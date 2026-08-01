import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../common_widgets/app_network_image.dart';
import '../../../../common_widgets/custom_app_bar.dart';
import '../../../../common_widgets/custom_gradient_button.dart';
import '../../../../common_widgets/gradient_container.dart';
import '../../../../constants/text_font_style.dart';
import '../../../../gen/assets.gen.dart';
import '../../../../gen/colors.gen.dart';
import '../../../../helpers/ui_helpers.dart';
import '../../../../common_widgets/swipe_to_action_button.dart';
import '../../../../common_widgets/custom_button.dart';
import 'business_partner_create_reward_screen.dart';

class BusinessPartnerRewardsDetailsScreen extends StatelessWidget {
  final String? type;
  const BusinessPartnerRewardsDetailsScreen({super.key, this.type});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldColor,
      appBar: const CustomAppBar(
        showRightIcon: false,
        title: "Rewards Product Detail",
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(vertical: 16.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image Carousel
            SizedBox(
              height: 300.h,
              child: PageView.builder(
                controller: PageController(viewportFraction: 0.9),
                itemCount: 3,
                itemBuilder: (context, index) {
                  return Container(
                    margin: EdgeInsets.symmetric(horizontal: 8.w),
                    decoration: BoxDecoration(
                      color: AppColors.c242A34,
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(16.r),
                          child: AppNetworkImage(
                            imageUrl:
                                "https://images.unsplash.com/photo-1542291026-7eec264c27ff?auto=format&fit=crop&q=80&w=800",
                            height: double.infinity,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            UIHelper.verticalSpace(16.h),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Carousel Indicator
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildDot(true),
                      UIHelper.horizontalSpace(6.w),
                      _buildDot(false),
                      UIHelper.horizontalSpace(6.w),
                      _buildDot(false),
                    ],
                  ),
                  UIHelper.verticalSpace(24.h),

                  // Title & Points
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          "Adidas Courtblock Shoes",
                          style: TextFontStyle.textStyle24cFFFFFFSFPro590
                              .copyWith(
                                fontSize: 16.sp,
                                color: AppColors.cFFF9F3,
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 12.w,
                          vertical: 6.h,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.c242A34,
                          borderRadius: BorderRadius.circular(100.r),
                        ),
                        child: Row(
                          children: [
                            Image.asset(
                              Assets.icons.pointIcon.path,
                              color: Colors.white,
                              width: 14.sp,
                              height: 14.sp,
                            ),
                            UIHelper.horizontalSpace(4.w),
                            Text(
                              "95",
                              style: TextFontStyle.textStyle24cFFFFFFSFPro590
                                  .copyWith(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            Text(
                              " pts",
                              style: TextFontStyle
                                  .textStyle14cFFFFFFSFProRounded400
                                  .copyWith(
                                    color: Colors.white.withValues(alpha: 0.6),
                                    fontSize: 12.sp,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  UIHelper.verticalSpace(8.h),

                  // Location
                  Row(
                    children: [
                      Icon(
                        Icons.location_on_outlined,
                        color: AppColors.c9D9D9D,
                        size: 14.sp,
                      ),
                      UIHelper.horizontalSpace(4.w),
                      Text(
                        "Divine Art Festival",
                        style: TextFontStyle.textStyle14cFFFFFFSFProRounded400
                            .copyWith(
                              color: AppColors.c9D9D9D,
                              fontSize: 14.sp,
                            ),
                      ),
                    ],
                  ),
                  UIHelper.verticalSpace(16.h),
                  Divider(
                    color: Colors.white.withValues(alpha: 0.1),
                    thickness: 1.h,
                  ),
                  UIHelper.verticalSpace(24.h),

                  // Description
                  Text(
                    "Description",
                    style: TextFontStyle.textStyle14cFFFFFFSFProRounded400
                        .copyWith(
                          color: AppColors.c848484,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                  UIHelper.verticalSpace(12.h),
                  Text(
                    "Experience unmatched comfort with NIKE Men's Sneakers. Crafted for durability, they feature a breathable upper and cushioned sole, ensuring you stay light on your feet. The stylish design seamlessly blends with any outfit, making them a versatile choice for any occasion.",
                    style: TextFontStyle.textStyle14cFFFFFFSFProRounded400
                        .copyWith(color: AppColors.cBCBCBB, fontSize: 12.sp),
                  ),
                  UIHelper.verticalSpace(24.h),
                  Divider(
                    color: Colors.white.withValues(alpha: 0.1),
                    thickness: 1.h,
                  ),
                  UIHelper.verticalSpace(24.h),

                  // Store Info
                  Row(
                    children: [
                      Container(
                        width: 44.w,
                        height: 44.w,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Icon(
                            Icons.storefront,
                            color: Colors.black,
                            size: 24.sp,
                          ),
                        ),
                      ),
                      UIHelper.horizontalSpace(12.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Nike Official Store",
                              style: TextFontStyle
                                  .textStyle14cFFFFFFSFProRounded400
                                  .copyWith(
                                    color: AppColors.cE9EAE9,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14.sp,
                                  ),
                            ),
                            UIHelper.verticalSpace(4.h),
                            Row(
                              children: [
                                Icon(
                                  Icons.star,
                                  color: const Color(0xFFFCA311),
                                  size: 14.sp,
                                ),
                                UIHelper.horizontalSpace(4.w),
                                Text(
                                  "4.9",
                                  style: TextFontStyle
                                      .textStyle14cFFFFFFSFProRounded400
                                      .copyWith(
                                        color: const Color(0xFFFCA311),
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.w600,
                                      ),
                                ),
                                UIHelper.horizontalSpace(8.w),
                                Text(
                                  "|  7932 sold",
                                  style: TextFontStyle
                                      .textStyle14cFFFFFFSFProRounded400
                                      .copyWith(
                                        color: AppColors.cBCBCBB,
                                        fontSize: 12.sp,
                                      ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  UIHelper.verticalSpace(24.h),
                  Divider(
                    color: Colors.white.withValues(alpha: 0.1),
                    thickness: 1.h,
                  ),
                  UIHelper.verticalSpace(24.h),

                  // Shop Location Map
                  Text(
                    "Shop Location",
                    style: TextFontStyle.textStyle14cFFFFFFSFProRounded400
                        .copyWith(
                          color: Colors.white.withValues(alpha: 0.6),
                          fontSize: 14.sp,
                        ),
                  ),
                  UIHelper.verticalSpace(12.h),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12.r),
                    child: AppNetworkImage(
                      imageUrl:
                          "https://images.unsplash.com/photo-1524661135-423995f22d0b?auto=format&fit=crop&q=80&w=800",
                      height: 130.h,
                      width: double.infinity,
                    ),
                  ),
                  UIHelper.verticalSpace(24.h),

                  // End Date and Info Box
                  GradientContainer(
                    padding: EdgeInsets.all(16.w),

                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              "End Date : ",
                              style: TextFontStyle
                                  .textStyle14cFFFFFFSFProRounded400
                                  .copyWith(
                                    color: AppColors.cBCBCBB,
                                    fontSize: 12.sp,
                                  ),
                            ),
                            Text(
                              "Aug 28, 2026",
                              style: TextFontStyle
                                  .textStyle14cFFFFFFSFProRounded400
                                  .copyWith(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 12.sp,
                                  ),
                            ),
                            const Spacer(),
                            Text(
                              "7h 32m left",
                              style: TextFontStyle
                                  .textStyle14cFFFFFFSFProRounded400
                                  .copyWith(
                                    color: const Color(0xFFC72C2C),
                                    fontWeight: FontWeight.w600,
                                    fontSize: 12.sp,
                                  ),
                            ),
                          ],
                        ),
                        UIHelper.verticalSpace(12.h),
                        Row(
                          children: [
                            Icon(
                              Icons.info_outline,
                              color: AppColors.cE9EAE9,
                              size: 16.sp,
                            ),
                            UIHelper.horizontalSpace(8.w),
                            Expanded(
                              child: Text(
                                "This reward can be collected from a physical store location.",
                                style: TextFontStyle
                                    .textStyle14cFFFFFFSFProRounded400
                                    .copyWith(
                                      color: AppColors.cE9EAE9,
                                      fontSize: 11.sp,
                                    ),
                              ),
                            ),
                          ],
                        ),
                        UIHelper.verticalSpace(12.h),
                        Row(
                          children: [
                            Image.asset(
                              Assets.icons.rewardsIcon.path,
                              color: const Color(0xFFFCA311),
                              width: 16.sp,
                              height: 16.sp,
                            ),
                            UIHelper.horizontalSpace(8.w),
                            Text(
                              "4 reward remaining",
                              style: TextFontStyle
                                  .textStyle14cFFFFFFSFProRounded400
                                  .copyWith(
                                    color: const Color(0xFFFCA311),
                                    fontWeight: FontWeight.w600,
                                    fontSize: 11.sp,
                                  ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  UIHelper.verticalSpace(32.h),

                  // Bottom Buttons
                  if (type == 'host' || type == 'businessPartner')
                    Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: CustomGradientButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const BusinessPartnerCreateRewardScreen(
                                        isEdit: true,
                                      ),
                                ),
                              );
                            },
                            title: "Edit Info",
                            height: 48.h,
                          ),
                        ),
                        UIHelper.horizontalSpace(16.w),
                        Expanded(
                          flex: 1,
                          child: CustomGradientButton(
                            onPressed: () {
                              _showDeleteBottomSheet(context);
                            },
                            title: "Delete",
                            height: 48.h,
                            gradient: const LinearGradient(
                              colors: [Color(0xFFC72C2C), Color(0xFF9E1F1F)],
                            ),
                          ),
                        ),
                      ],
                    )
                  else
                    SwipeToActionButton(
                      text: "Swipe right to Redeem Reward",
                      onAction: () async {
                        _showRedeemBottomSheet(context);
                      },
                    ),
                  UIHelper.verticalSpace(32.h),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

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

  Widget _buildDot(bool isActive) {
    return Container(
      width: 6.w,
      height: 6.w,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isActive
            ? AppColors.primaryColorSecond
            : Colors.white.withValues(alpha: 0.3),
      ),
    );
  }

  void _showDeleteBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
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
                      onPressed: () => Navigator.pop(context),
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
                      onPressed: () {
                        // Confirm deletion logic here
                        Navigator.pop(context);
                      },
                      title: "Delete",
                      height: 48.h,
                      borderRadius: BorderRadius.circular(100.r),
                      textStyle: TextFontStyle.textStyle14cFFFFFFSFProRounded400
                          .copyWith(
                            color: AppColors.c262824,
                            fontWeight: FontWeight.w700,
                            fontSize: 14.sp,
                          ),
                      gradient: const LinearGradient(
                        colors: [Color(0xFFC72C2C), Color(0xFF9E1F1F)],
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
  }
}
