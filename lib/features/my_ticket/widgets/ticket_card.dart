import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';
import '../../../constants/text_font_style.dart';
import '../../../gen/assets.gen.dart';
import '../../../gen/colors.gen.dart';
import '../../../helpers/ui_helpers.dart';
import '../../../common_widgets/custom_gradient_button.dart';
import '../../../common_widgets/gradient_container.dart';

/// A ticket card matching the design: QR code on the left, event details
/// on the right, and two full-width action buttons at the bottom.
/// All fields are configurable so the widget can be reused anywhere.
class TicketCard extends StatelessWidget {
  const TicketCard({
    super.key,
    required this.eventName,
    required this.dateTime,
    required this.location,
    required this.ticketCount,
    required this.price,
    this.onViewPressed,
    this.onCancelPressed,
    this.viewLabel = 'View',
    this.cancelLabel = 'Cancel',
    this.showActions = true,
    this.imageUrl,
    this.qrCodeUrl,
  });

  final String eventName;
  final String dateTime;
  final String location;
  final int ticketCount;
  final String price;
  final VoidCallback? onViewPressed;
  final VoidCallback? onCancelPressed;
  final String viewLabel;
  final String cancelLabel;
  final bool showActions;
  final String? imageUrl;
  final String? qrCodeUrl;

  @override
  Widget build(BuildContext context) {
    final effectiveImage =
        (imageUrl != null && imageUrl!.isNotEmpty) ? imageUrl : qrCodeUrl;

    return GradientContainer(
      padding: EdgeInsets.all(14.w),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // ── Top row: Event Flyer + event info ──────────────────
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Event flyer image
              Container(
                width: 86.w,
                height: 86.w,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: (effectiveImage != null && effectiveImage.isNotEmpty)
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(8.r),
                        child: CachedNetworkImage(
                          imageUrl: effectiveImage,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Shimmer.fromColors(
                            baseColor: const Color(0xFF262A34),
                            highlightColor: const Color(0xFF383D4A),
                            child: Container(
                              color: const Color(0xFF262A34),
                            ),
                          ),
                          errorWidget: (context, url, error) => ClipRRect(
                            borderRadius: BorderRadius.circular(8.r),
                            child: Image.asset(
                              Assets.images.placeholderImage.path,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      )
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(8.r),
                        child: Image.asset(
                          Assets.images.placeholderImage.path,
                          fit: BoxFit.cover,
                        ),
                      ),
              ),
              UIHelper.horizontalSpace(12.w),

              // Event details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Event name
                    Text(
                      eventName,
                      style: TextFontStyle.textStyle24cFFFFFFSFPro590.copyWith(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w700,
                        color: Colors.white.withValues(alpha: 0.85),
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    UIHelper.verticalSpace(5.h),

                    // Date / time
                    Text(
                      dateTime,
                      style: TextFontStyle.textStyle14cFFFFFFSFProRounded400
                          .copyWith(
                            fontFamily: 'SF Pro',
                            fontSize: 11.5.sp,
                            color: Colors.white.withValues(alpha: 0.55),
                          ),
                    ),
                    UIHelper.verticalSpace(5.h),

                    // Location
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.location_on_rounded,
                          size: 13.sp,
                          color: Colors.white.withValues(alpha: 0.5),
                        ),
                        UIHelper.horizontalSpace(3.w),
                        Flexible(
                          child: Text(
                            location,
                            style: TextFontStyle
                                .textStyle14cFFFFFFSFProRounded400
                                .copyWith(
                                  fontFamily: 'SF Pro',
                                  fontSize: 11.5.sp,
                                  color: Colors.white.withValues(alpha: 0.5),
                                ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    UIHelper.verticalSpace(8.h),

                    // Ticket count + price
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Ticket : $ticketCount',
                          style: TextFontStyle.textStyle14cFFFFFFSFProRounded400
                              .copyWith(
                                fontFamily: 'SF Pro',
                                fontSize: 12.sp,
                                color: Colors.white.withValues(alpha: 0.6),
                              ),
                        ),
                        Text(
                          price,
                          style: TextFontStyle.textStyle24cFFFFFFSFPro590
                              .copyWith(
                                fontSize: 18.sp,
                                fontWeight: FontWeight.w800,
                                color: Colors.white.withValues(alpha: 0.85),
                              ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),

          if (showActions && (onViewPressed != null || onCancelPressed != null)) ...[
            UIHelper.verticalSpace(12.h),

            // ── Action buttons ────────────────────────────────────
            Row(
              children: [
                if (onViewPressed != null)
                  Expanded(
                    child: CustomGradientButton(
                      onPressed: onViewPressed,
                      title: viewLabel,
                      height: 40.h,
                      borderRadius: BorderRadius.circular(100.r),
                      gradient: const LinearGradient(
                        colors: [Color(0xFF7DFF57), Color(0xFF7DFF57)],
                      ),
                      textStyle: TextFontStyle.textStyle14cFFFFFFSFProRounded400
                          .copyWith(
                            fontFamily: 'SF Pro',
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w700,
                            color: AppColors.c262824,
                          ),
                    ),
                  ),
                if (onViewPressed != null && onCancelPressed != null)
                  UIHelper.horizontalSpace(10.w),
                if (onCancelPressed != null)
                  Expanded(
                    child: CustomGradientButton(
                      onPressed: onCancelPressed,
                      title: cancelLabel,
                      height: 40.h,
                      borderRadius: BorderRadius.circular(100.r),
                      gradient: const LinearGradient(
                        colors: [Color(0xFFF28F31), Color(0xFFF28F31)],
                      ),
                      textStyle: TextFontStyle.textStyle14cFFFFFFSFProRounded400
                          .copyWith(
                            fontFamily: 'SF Pro',
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w700,
                            color: AppColors.c1B1F26,
                          ),
                    ),
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
