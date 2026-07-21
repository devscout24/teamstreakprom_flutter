import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../constants/text_font_style.dart';
import '../../../gen/colors.gen.dart';
import '../../../helpers/ui_helpers.dart';
import '../../../common_widgets/custom_button.dart';
import '../../../common_widgets/custom_gradient_button.dart';
import '../../../common_widgets/gradient_container.dart';
import '../../../common_widgets/custom_back_button.dart';

class TicketDetailsScreen extends StatelessWidget {
  const TicketDetailsScreen({
    super.key,
    required this.eventName,
    required this.dateTime,
    required this.location,
    required this.ticketCount,
    required this.price,
  });

  final String eventName;
  final String dateTime;
  final String location;
  final int ticketCount;
  final String price;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldColor,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: Padding(
          padding: EdgeInsets.all(8.r),
          child: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: const CustomBackButton(),
            title: Text(
              "Ticket Details",
              style: TextFontStyle.textStyle24cFFFFFFSFPro590.copyWith(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            centerTitle: true,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.w),
        child: Column(
          children: [
            // The main ticket container
            GradientContainer(
              width: double.infinity,
              padding: EdgeInsets.all(16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // QR Code Container
                  Center(
                    child: Container(
                      width: 250.w,
                      height: 250.w,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16.r),
                      ),
                      padding: EdgeInsets.all(16.w),
                      child: CustomPaint(painter: _QrPainter()),
                    ),
                  ),
                  UIHelper.verticalSpace(24.h),

                  // Details Rows
                  _buildDetailRow("Event", eventName),
                  UIHelper.verticalSpace(12.h),
                  _buildDetailRow("Event Location", location),
                  UIHelper.verticalSpace(12.h),
                  _buildDetailRow("Date & Time", dateTime),
                  UIHelper.verticalSpace(12.h),

                  // Organizer & Ticket ID
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: _buildDetailRow(
                          "Event Organizer",
                          "Music of Tour",
                        ),
                      ),
                      Expanded(
                        child: _buildDetailRow(
                          "Ticket ID",
                          "MOT3203920212",
                          alignRight: true,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            UIHelper.verticalSpace(24.h),

            // Download Ticket Button
            CustomGradientButton(
              onPressed: () {},
              title: "Download Ticket",
              height: 50.h,
              borderRadius: BorderRadius.circular(100.r),

              textStyle: TextFontStyle.textStyle14cFFFFFFSFProRounded400
                  .copyWith(
                    color: AppColors.c262824,
                    fontWeight: FontWeight.w700,
                    fontSize: 16.sp,
                  ),
            ),
            UIHelper.verticalSpace(24.h),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(
    String title,
    String value, {
    bool alignRight = false,
  }) {
    return Column(
      crossAxisAlignment: alignRight
          ? CrossAxisAlignment.end
          : CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextFontStyle.textStyle14cFFFFFFSFProRounded400.copyWith(
            color: Colors.white.withValues(alpha: 0.5),
            fontSize: 12.sp,
            fontFamily: "SF Pro",
          ),
        ),
        UIHelper.verticalSpace(10.h),
        Text(
          value,
          style: TextFontStyle.textStyle14cFFFFFFSFProRounded400.copyWith(
            color: AppColors.cFFFFFF.withValues(alpha: 0.8),
            fontSize: 16.sp,
            fontWeight: FontWeight.w500,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          textAlign: alignRight ? TextAlign.right : TextAlign.left,
        ),
        UIHelper.verticalSpace(12.h),
        CustomPaint(
          size: Size(double.infinity, 1.w),
          painter: _DashedLinePainter(
            color: Colors.white.withValues(alpha: 0.2),
          ),
        ),
      ],
    );
  }
}

// ── Custom Painters ────────────────────────────────────────────────────

class _DashedLinePainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final double dashWidth;
  final double dashSpace;

  _DashedLinePainter({
    required this.color,
    this.strokeWidth = 1.0,
    this.dashWidth = 4.0,
    this.dashSpace = 4.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    double startX = 0;
    while (startX < size.width) {
      canvas.drawLine(Offset(startX, 0), Offset(startX + dashWidth, 0), paint);
      startX += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant _DashedLinePainter oldDelegate) {
    return oldDelegate.color != color ||
        oldDelegate.strokeWidth != strokeWidth ||
        oldDelegate.dashWidth != dashWidth ||
        oldDelegate.dashSpace != dashSpace;
  }
}

// Same QRPainter from ticket_card.dart
class _QrPainter extends CustomPainter {
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
