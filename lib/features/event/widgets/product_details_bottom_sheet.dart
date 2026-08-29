import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:teamstreakpromo/features/event/widgets/event_details_widgets.dart';
import '../../../constants/text_font_style.dart';
import '../../../gen/colors.gen.dart';
import '../../../gen/assets.gen.dart';
import '../../../helpers/ui_helpers.dart';
import '../../../common_widgets/custom_gradient_button.dart';
import '../../../constants/app_constants.dart';
import '../../../helpers/di.dart';
import '../../../common_widgets/app_network_image.dart';

void showProductDetailsBottomSheet({
  required BuildContext context,
  required RewardProduct product,
  required String location,
  required VoidCallback onContinueToPay,
}) {
  showModalBottomSheet(
    context: context,
    backgroundColor: const Color(0xFF131722),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(28.r)),
    ),
    isScrollControlled: true,
    builder: (context) {
      final PageController sheetPageController = PageController();
      int sheetCurrentIndex = 0;
      final List<String> sheetImages = product.imageUrls;
      final String accountType =
          appData.read(kAccountType)?.toString().toLowerCase() ?? '';
      final bool isHost =
          accountType == 'accounttype.host' || accountType == 'host';

      return StatefulBuilder(
        builder: (context, setSheetState) {
          return Padding(
            padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 24.h),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const SizedBox(width: 24),
                    Container(
                      width: 48.w,
                      height: 5.h,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(100.r),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                UIHelper.verticalSpace(12.h),
                Container(
                  height: 250.h,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E222B),
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20.r),
                    child: Stack(
                      children: [
                        PageView.builder(
                          controller: sheetPageController,
                          itemCount: sheetImages.length,
                          onPageChanged: (index) {
                            setSheetState(() {
                              sheetCurrentIndex = index;
                            });
                          },
                          itemBuilder: (context, index) {
                            return AppNetworkImage(
                              imageUrl: sheetImages[index],
                              fit: BoxFit.cover,
                              width: double.infinity,
                              height: double.infinity,
                            );
                          },
                        ),
                        // Dot Indicators
                        Positioned(
                          bottom: 16.h,
                          left: 0,
                          right: 0,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(
                              sheetImages.length,
                              (index) => AnimatedContainer(
                                duration: const Duration(milliseconds: 250),
                                width: sheetCurrentIndex == index ? 16.w : 6.w,
                                height: 6.h,
                                margin: EdgeInsets.symmetric(horizontal: 3.w),
                                decoration: BoxDecoration(
                                  color: sheetCurrentIndex == index
                                      ? AppColors.primaryColorSecond
                                      : Colors.white.withValues(alpha: 0.5),
                                  borderRadius: BorderRadius.circular(100.r),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                UIHelper.verticalSpace(20.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        product.title,
                        style: TextFontStyle.textStyle14cFFFFFFSFProRounded400
                            .copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 20.sp,
                            ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 12.w,
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
                                  fontSize: 13.sp,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                UIHelper.verticalSpace(8.h),
                Row(
                  children: [
                    Icon(
                      Icons.location_on_outlined,
                      color: Colors.white.withValues(alpha: 0.6),
                      size: 16.sp,
                    ),
                    UIHelper.horizontalSpace(6.w),
                    Text(
                      location,
                      style: TextFontStyle.textStyle14cFFFFFFSFProRounded400
                          .copyWith(
                            color: Colors.white.withValues(alpha: 0.6),
                            fontSize: 13.sp,
                          ),
                    ),
                  ],
                ),
                UIHelper.verticalSpace(20.h),
                Text(
                  "Description",
                  style: TextFontStyle.textStyle14cFFFFFFSFProRounded400
                      .copyWith(
                        color: Colors.white.withValues(alpha: 0.6),
                        fontWeight: FontWeight.bold,
                        fontSize: 14.sp,
                      ),
                ),
                UIHelper.verticalSpace(8.h),
                Text(
                  product.description,
                  style: TextFontStyle.textStyle14cFFFFFFSFProRounded400
                      .copyWith(
                        color: Colors.white.withValues(alpha: 0.8),
                        fontSize: 13.sp,
                        height: 1.4,
                      ),
                ),
                UIHelper.verticalSpace(20.h),
                Row(
                  children: [
                    Icon(
                      Icons.redeem_rounded,
                      color: AppColors.primaryColorFirst,
                      size: 16.sp,
                    ),
                    UIHelper.horizontalSpace(8.w),
                    Text(
                      "${product.stock} reward remaining",
                      style: TextFontStyle.textStyle14cFFFFFFSFProRounded400
                          .copyWith(
                            color: AppColors.primaryColorFirst,
                            fontSize: 13.sp,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ],
                ),
                if (!isHost) ...[
                  UIHelper.verticalSpace(24.h),
                  CustomGradientButton(
                    onPressed: () {
                      Navigator.pop(context);
                      onContinueToPay();
                    },
                    title: "Continue to Redeem Reward",
                    borderRadius: BorderRadius.circular(100.r),
                    textStyle: TextFontStyle.textStyle14cFFFFFFSFProRounded400
                        .copyWith(
                          color: const Color(0xFF262824),
                          fontWeight: FontWeight.w700,
                          fontSize: 16.sp,
                        ),
                  ),
                ],
              ],
            ),
          );
        },
      );
    },
  );
}
