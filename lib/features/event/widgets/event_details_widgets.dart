import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:teamstreakpromo/constants/text_font_style.dart';
import 'package:teamstreakpromo/gen/colors.gen.dart';
import 'package:teamstreakpromo/gen/assets.gen.dart';
import 'package:teamstreakpromo/helpers/ui_helpers.dart';
import 'package:teamstreakpromo/common_widgets/custom_gradient_button.dart';
import 'package:teamstreakpromo/features/event/widgets/product_details_bottom_sheet.dart';
import 'package:teamstreakpromo/features/event/model/host_event_details_model.dart';
import 'package:teamstreakpromo/common_widgets/app_network_image.dart';

class RewardProduct {
  final String title;
  final String description;
  final List<String> imageUrls;
  final bool isStockIn;
  final String points;
  final int stock;

  const RewardProduct({
    required this.title,
    required this.description,
    required this.imageUrls,
    required this.isStockIn,
    required this.points,
    required this.stock,
  });
}

class RewardProductCard extends StatelessWidget {
  final RewardProduct product;
  final bool isSelected;
  final String displayLocation;
  final VoidCallback onTap;
  final VoidCallback onContinueToPay;

  const RewardProductCard({
    super.key,
    required this.product,
    required this.isSelected,
    required this.displayLocation,
    required this.onTap,
    required this.onContinueToPay,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: 16.h),
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: const Color(0xFF1E222B),
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: isSelected
                ? const Color(0xFFFFA500)
                : Colors.white.withValues(alpha: 0.05),
            width: 1.w,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product image
            GestureDetector(
              onTap: () {
                onTap();
                showProductDetailsBottomSheet(
                  context: context,
                  product: product,
                  location: displayLocation,
                  onContinueToPay: onContinueToPay,
                );
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12.r),
                child: AppNetworkImage(
                  imageUrl: product.imageUrls.first,
                  width: 80.w,
                  height: 80.w,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            UIHelper.horizontalSpace(16.w),
            // Product info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.title,
                    style: TextFontStyle.textStyle14cFFFFFFSFProRounded400
                        .copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 15.sp,
                        ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  UIHelper.verticalSpace(4.h),
                  Text(
                    product.description,
                    style: TextFontStyle.textStyle14cFFFFFFSFProRounded400
                        .copyWith(
                          color: Colors.white.withValues(alpha: 0.5),
                          fontSize: 12.sp,
                          height: 1.3,
                        ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  UIHelper.verticalSpace(8.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        product.isStockIn ? "Stock In" : "Stock Out",
                        style: TextFontStyle.textStyle14cFFFFFFSFProRounded400
                            .copyWith(
                              color: product.isStockIn
                                  ? AppColors.primaryColorSecond
                                  : const Color(0xFFDD1F1F),
                              fontWeight: FontWeight.bold,
                              fontSize: 13.sp,
                            ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 10.w,
                          vertical: 6.h,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.08),
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
                            UIHelper.horizontalSpace(6.w),
                            Text(
                              "${product.points} pts",
                              style: TextFontStyle
                                  .textStyle14cFFFFFFSFProRounded400
                                  .copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12.sp,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ],
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

class ArtistCard extends StatelessWidget {
  final ArtistInfo artist;

  const ArtistCard({super.key, required this.artist});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Row(
        children: [
          CircleAvatar(
            radius: 24.r,
            backgroundImage: NetworkImage(
              (artist.image != null && artist.image!.isNotEmpty)
                  ? artist.image!
                  : "https://images.unsplash.com/photo-1500648767791-00dcc994a43e?auto=format&fit=crop&w=150&q=80",
            ),
          ),
          UIHelper.horizontalSpace(12.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                artist.name ?? "Unknown Artist",
                style: TextFontStyle.textStyle14cFFFFFFSFProRounded400
                    .copyWith(
                      color: Colors.white,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                    ),
              ),
              UIHelper.verticalSpace(4.h),
              Text(
                artist.role ?? "Artist",
                style: TextFontStyle.textStyle14cFFFFFFSFProRounded400
                    .copyWith(
                      color: Colors.white.withValues(alpha: 0.8),
                      fontSize: 12.sp,
                    ),
              ),
            ],
          ),
          if (artist.socialMediaLinks != null &&
              ((artist.socialMediaLinks?.instagram?.isNotEmpty ?? false) ||
                  (artist.socialMediaLinks?.spotify?.isNotEmpty ?? false))) ...[
            const Spacer(),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (artist.socialMediaLinks?.instagram?.isNotEmpty ??
                    false) ...[
                  Container(
                    width: 28.w,
                    height: 28.w,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.08),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Icon(
                        Icons.camera_alt_outlined,
                        size: 14.sp,
                        color: Colors.white.withValues(alpha: 0.9),
                      ),
                    ),
                  ),
                  UIHelper.horizontalSpace(8.w),
                ],
                if (artist.socialMediaLinks?.spotify?.isNotEmpty ?? false) ...[
                  Container(
                    width: 28.w,
                    height: 28.w,
                    decoration: BoxDecoration(
                      color:
                          AppColors.primaryColorSecond.withValues(alpha: 0.15),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Icon(
                        Icons.music_note_rounded,
                        size: 14.sp,
                        color: AppColors.primaryColorSecond,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ],
        ],
      ),
    );
  }
}

void showDeleteEventBottomSheet(BuildContext context, VoidCallback onDelete) {
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
              "Delete Event",
              style: TextFontStyle.textStyle24cFFFFFFSFPro590.copyWith(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            UIHelper.verticalSpace(16.h),
            Text(
              "Are you sure you want to delete this event? This action cannot be undone.",
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
                  child: CustomGradientButton(
                    onPressed: () => Navigator.pop(context),
                    title: "Cancel",
                    height: 48.h,
                    borderRadius: BorderRadius.circular(100.r),
                    gradient: const LinearGradient(
                      colors: [Colors.white, Colors.white],
                    ),
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
                      Navigator.pop(context);
                      onDelete();
                    },
                    title: "Delete",
                    height: 48.h,
                    borderRadius: BorderRadius.circular(100.r),
                    textStyle: TextFontStyle.textStyle14cFFFFFFSFProRounded400
                        .copyWith(
                          color: Colors.white,
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
