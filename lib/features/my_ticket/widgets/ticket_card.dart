import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../constants/text_font_style.dart';
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

  @override
  Widget build(BuildContext context) {
    return GradientContainer(
      padding: EdgeInsets.all(14.w),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // ── Top row: QR + event info ──────────────────────────
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // QR code
              Container(
                width: 86.w,
                height: 86.w,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8.r),
                ),
                padding: EdgeInsets.all(4.w),
                child: CustomPaint(painter: _QrPainter()),
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

          if (showActions) ...[
            UIHelper.verticalSpace(12.h),

            // ── Action buttons ────────────────────────────────────
            Row(
              children: [
                // View — green
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
                UIHelper.horizontalSpace(10.w),
                // Cancel — orange
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

// ── QR code painter ────────────────────────────────────────────────────

/// Draws a pixel-perfect 21×21 QR-style grid matching the screenshot.
class _QrPainter extends CustomPainter {
  // 1 = black, 0 = white  (simplified 21×21 static pattern)
  static const _grid = [
    [1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 1, 0, 1, 0, 1, 1, 1, 1, 1, 1, 1],
    [1, 0, 0, 0, 0, 0, 1, 0, 0, 1, 0, 1, 0, 0, 1, 0, 0, 0, 0, 0, 1],
    [1, 0, 1, 1, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 1, 1, 0, 1],
    [1, 0, 1, 1, 1, 0, 1, 0, 0, 0, 0, 1, 0, 0, 1, 0, 1, 1, 1, 0, 1],
    [1, 0, 1, 1, 1, 0, 1, 0, 1, 1, 1, 0, 1, 0, 1, 0, 1, 1, 1, 0, 1],
    [1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1],
    [1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 1, 0, 1, 0, 1, 1, 1, 1, 1, 1, 1],
    [0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0],
    [1, 0, 1, 1, 0, 1, 1, 1, 0, 1, 1, 0, 1, 1, 0, 1, 1, 0, 1, 1, 0],
    [0, 1, 0, 0, 1, 0, 0, 0, 1, 0, 1, 0, 0, 1, 0, 0, 0, 1, 0, 1, 0],
    [1, 1, 1, 0, 1, 1, 1, 0, 1, 1, 0, 1, 1, 0, 1, 1, 1, 0, 1, 0, 1],
    [0, 0, 1, 0, 0, 0, 0, 0, 0, 1, 0, 0, 1, 0, 0, 0, 1, 0, 0, 1, 0],
    [1, 0, 1, 1, 0, 1, 1, 1, 0, 0, 1, 1, 0, 1, 0, 1, 0, 1, 1, 0, 1],
    [0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 1, 0, 0, 0, 0, 1, 0, 1, 0, 0],
    [1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 0, 0, 1, 0, 1, 0, 1, 0, 0, 1, 1],
    [1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, 1, 0, 1, 0, 1, 0, 1, 0, 0, 1],
    [1, 0, 1, 1, 1, 0, 1, 0, 1, 0, 0, 1, 1, 0, 1, 0, 1, 1, 0, 1, 0],
    [1, 0, 1, 1, 1, 0, 1, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 0, 1, 1, 0],
    [1, 0, 1, 1, 1, 0, 1, 0, 1, 1, 0, 1, 0, 0, 1, 1, 0, 1, 0, 0, 1],
    [1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, 0, 1, 0, 0, 1, 0, 0, 1, 0, 1],
    [1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 0, 0, 1, 1, 0, 1, 1, 0, 1, 1, 0],
  ];

  @override
  void paint(Canvas canvas, Size size) {
    final rows = _grid.length;
    final cols = _grid[0].length;
    final cellW = size.width / cols;
    final cellH = size.height / rows;

    final black = Paint()..color = Colors.black;
    final white = Paint()..color = Colors.white;

    for (var r = 0; r < rows; r++) {
      for (var c = 0; c < cols; c++) {
        final rect = Rect.fromLTWH(c * cellW, r * cellH, cellW, cellH);
        canvas.drawRect(rect, _grid[r][c] == 1 ? black : white);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter _) => false;
}
