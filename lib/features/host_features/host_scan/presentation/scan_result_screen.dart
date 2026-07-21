import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:teamstreakpromo/gen/colors.gen.dart';
import 'package:teamstreakpromo/helpers/ui_helpers.dart';
import 'package:teamstreakpromo/common_widgets/gradient_container.dart';
import 'package:teamstreakpromo/common_widgets/custom_back_button.dart';

class ScanResultScreen extends StatelessWidget {
  const ScanResultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldColor,
      body: SafeArea(
        child: Column(
          children: [
            UIHelper.verticalSpace(20),
            // Header Row
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Row(
                children: [
                  const CustomBackButton(),
                  const Spacer(),
                  Text(
                    "Scan Result",
                    style: TextStyle(
                      fontFamily: "SF Pro Rounded",
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  const Spacer(),
                  SizedBox(width: 40.w), // Spacer balance
                ],
              ),
            ),
            UIHelper.verticalSpace(24),

            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Column(
                  children: [
                    // Main Ticket/QR Card Container
                    GradientContainer(
                      width: double.infinity,
                      padding: EdgeInsets.all(20.w),
                      border: Border.all(
                        color: AppColors.cFFFFFF.withValues(alpha: 0.5),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // 1. Beautiful Mock QR Code Display
                          Center(
                            child: Container(
                              width: 200.w,
                              height: 200.w,
                              padding: EdgeInsets.all(10.w),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16.r),
                              ),
                              child: CustomPaint(painter: _QrCodePainter()),
                            ),
                          ),
                          UIHelper.verticalSpace(24),

                          // Dashed divider line
                          const _DashedLine(color: Colors.white10),
                          UIHelper.verticalSpace(16),

                          // 2. Event Title Details
                          Text(
                            "Event",
                            style: TextStyle(
                              fontFamily: "SF Pro Rounded",
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w600,
                              color: Colors.white.withValues(alpha: 0.4),
                            ),
                          ),
                          UIHelper.verticalSpace(6),
                          Text(
                            "Music Celebration: Highland Park, Alaska",
                            style: TextStyle(
                              fontFamily: "SF Pro Rounded",
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                          UIHelper.verticalSpace(16),

                          // Dashed divider line
                          const _DashedLine(color: Colors.white10),
                          UIHelper.verticalSpace(16),

                          // 3. Grid of Details
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Column Left
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _buildDetailItem(
                                      label: "Ticket ID",
                                      value: "MOT3203920212",
                                    ),
                                    UIHelper.verticalSpace(16),
                                    _buildDetailItem(
                                      label: "Date & Time",
                                      value: "Nov 24,23 • 10.00 PM",
                                    ),
                                  ],
                                ),
                              ),
                              // Vertical Dotted Divider Line
                              Container(
                                height: 95.h,
                                width: 1.w,
                                margin: EdgeInsets.symmetric(horizontal: 16.w),
                                child: CustomPaint(
                                  painter: _VerticalDottedLinePainter(
                                    color: Colors.white.withValues(alpha: 0.12),
                                  ),
                                ),
                              ),
                              // Column Right
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _buildDetailItem(
                                      label: "Event Location",
                                      value: "Alaska 99611, USA",
                                    ),
                                    UIHelper.verticalSpace(16),
                                    _buildDetailItem(
                                      label: "Event Organizer",
                                      value: "Music of Tour",
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    UIHelper.verticalSpace(20),

                    // Valid Banner Card
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 16.h,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1B2A22).withValues(alpha: .7),
                        borderRadius: BorderRadius.circular(16.r),
                        border: Border.all(
                          color: AppColors.cFFFFFF.withValues(alpha: 0.1),
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.check_circle_rounded,
                            color: const Color(0xFF2ECC71),
                            size: 20.w,
                          ),
                          UIHelper.horizontalSpace(10),
                          Text(
                            "This Ticket is Valid.",
                            style: TextStyle(
                              fontFamily: "SF Pro Rounded",
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF2ECC71),
                            ),
                          ),
                        ],
                      ),
                    ),
                    UIHelper.verticalSpace(40),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailItem({required String label, required String value}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontFamily: "SF Pro Rounded",
            fontSize: 11.sp,
            fontWeight: FontWeight.w600,
            color: Colors.white.withValues(alpha: 0.4),
          ),
        ),
        UIHelper.verticalSpace(6),
        Text(
          value,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontFamily: "SF Pro Rounded",
            fontSize: 13.sp,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}

// Custom Painter to draw a clean, stylized QR Code
class _QrCodePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final double width = size.width;
    final double height = size.height;
    final double finderSize = width * 0.28;

    final darkPaint = Paint()..color = const Color(0xFF1E222B);

    // 1. Finder pattern Top-Left
    _drawFinderPattern(canvas, 0, 0, finderSize, darkPaint);

    // 2. Finder pattern Top-Right
    _drawFinderPattern(canvas, width - finderSize, 0, finderSize, darkPaint);

    // 3. Finder pattern Bottom-Left
    _drawFinderPattern(canvas, 0, height - finderSize, finderSize, darkPaint);

    // 4. Draw random mock QR blocks/modules to make it look exactly like a real QR code
    final double blockSize = width / 18;
    final List<List<int>> mockGrid = [
      [0, 0, 0, 0, 0, 0, 0, 1, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 0, 1, 0, 0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0, 0, 0, 1, 0, 1, 0, 1, 0, 0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 1, 0, 0, 0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 0, 1, 0, 0, 0, 0, 0, 0],
      [1, 0, 1, 0, 1, 0, 1, 0, 0, 1, 1, 0, 1, 0, 1, 0, 1, 0],
      [0, 1, 0, 1, 0, 1, 0, 1, 0, 0, 1, 1, 0, 1, 0, 1, 0, 1],
      [1, 0, 0, 1, 1, 0, 0, 1, 1, 0, 0, 1, 1, 0, 0, 1, 1, 0],
      [0, 1, 1, 0, 0, 1, 1, 0, 0, 1, 1, 0, 0, 1, 1, 0, 0, 1],
      [1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0],
      [0, 0, 0, 0, 0, 0, 0, 1, 0, 1, 1, 0, 1, 0, 0, 1, 0, 1],
      [0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 1, 0, 1, 1, 0, 1, 0],
      [0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 0, 1, 1, 0, 0, 1, 0, 1],
      [0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 1, 0, 1, 0, 1, 0],
      [0, 0, 0, 0, 0, 0, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1],
      [0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0],
    ];

    for (int r = 0; r < mockGrid.length; r++) {
      for (int c = 0; c < mockGrid[r].length; c++) {
        if (mockGrid[r][c] == 1) {
          canvas.drawRect(
            Rect.fromLTWH(c * blockSize, r * blockSize, blockSize, blockSize),
            darkPaint,
          );
        }
      }
    }
  }

  void _drawFinderPattern(
    Canvas canvas,
    double x,
    double y,
    double size,
    Paint paint,
  ) {
    // Outer square
    canvas.drawRect(Rect.fromLTWH(x, y, size, size), paint);
    // Inner white space square
    final whitePaint = Paint()..color = Colors.white;
    final double strokeWidth = size * 0.14;
    canvas.drawRect(
      Rect.fromLTWH(
        x + strokeWidth,
        y + strokeWidth,
        size - strokeWidth * 2,
        size - strokeWidth * 2,
      ),
      whitePaint,
    );
    // Center filled square
    final double centerOffset = size * 0.28;
    final double centerSize = size * 0.44;
    canvas.drawRect(
      Rect.fromLTWH(x + centerOffset, y + centerOffset, centerSize, centerSize),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// Simple Horizontal Dashed Line Widget
class _DashedLine extends StatelessWidget {
  final Color color;

  const _DashedLine({required this.color});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final boxWidth = constraints.constrainWidth();
        const dashWidth = 4.0;
        final dashHeight = 1.0.h;
        final dashCount = (boxWidth / (2 * dashWidth)).floor();
        return Flex(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          direction: Axis.horizontal,
          children: List.generate(dashCount, (_) {
            return SizedBox(
              width: dashWidth,
              height: dashHeight,
              child: DecoratedBox(decoration: BoxDecoration(color: color)),
            );
          }),
        );
      },
    );
  }
}

// Vertical Dotted Divider line painter
class _VerticalDottedLinePainter extends CustomPainter {
  final Color color;

  _VerticalDottedLinePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final double height = size.height;
    final paint = Paint()
      ..color = color
      ..strokeWidth = size.width
      ..strokeCap = StrokeCap.round;

    const double dashHeight = 3.0;
    const double dashSpace = 4.0;

    double startY = 0;
    while (startY < height) {
      canvas.drawLine(Offset(0, startY), Offset(0, startY + dashHeight), paint);
      startY += dashHeight + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant _VerticalDottedLinePainter oldDelegate) {
    return oldDelegate.color != color;
  }
}
