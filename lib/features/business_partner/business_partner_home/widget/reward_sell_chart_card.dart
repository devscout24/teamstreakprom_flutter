import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:teamstreakpromo/common_widgets/gradient_container.dart';
import 'package:teamstreakpromo/gen/colors.gen.dart';
import 'package:teamstreakpromo/helpers/ui_helpers.dart';

class RewardSellChartCard extends StatefulWidget {
  const RewardSellChartCard({super.key});

  @override
  State<RewardSellChartCard> createState() => _RewardSellChartCardState();
}

class _RewardSellChartCardState extends State<RewardSellChartCard> {
  String _selectedTicketType = "Month";
  int _activeTicketIndex = 7; // May is index 7 in the 10-point dataset

  // 10-point dataset matching the mockup design exactly
  final List<String> _ticketMonthLabels = [
    "Jan",
    "",
    "Feb",
    "Mar",
    "",
    "Apr",
    "",
    "May",
    "",
    "Jun",
  ];
  final List<double> _ticketMonthValues = [
    130.0,
    210.0,
    180.0,
    310.0,
    270.0,
    300.0,
    105.0,
    200.0,
    52.0,
    400.0,
  ];
  final List<double> _ticketMonthXFractions = [
    0.0,
    0.12,
    0.24,
    0.36,
    0.48,
    0.60,
    0.72,
    0.84,
    0.94,
    1.0,
  ];

  // 7-point dataset for Week
  final List<String> _ticketWeekLabels = [
    "Mon",
    "Tue",
    "Wed",
    "Thu",
    "Fri",
    "Sat",
    "Sun",
  ];
  final List<double> _ticketWeekValues = [
    120.0,
    200.0,
    150.0,
    320.0,
    90.0,
    240.0,
    350.0,
  ];
  final List<double> _ticketWeekXFractions = [
    0.0,
    0.166,
    0.333,
    0.5,
    0.666,
    0.833,
    1.0,
  ];

  @override
  Widget build(BuildContext context) {
    final isWeek = _selectedTicketType == "Week";
    final activeLabels = isWeek ? _ticketWeekLabels : _ticketMonthLabels;
    final activeValues = isWeek ? _ticketWeekValues : _ticketMonthValues;
    final activeFractions = isWeek
        ? _ticketWeekXFractions
        : _ticketMonthXFractions;

    // Calculate dynamic maxValue limit at the parent level to share between Y-axis and chart
    double maxVal = activeValues.isEmpty
        ? 100.0
        : activeValues.reduce((curr, next) => curr > next ? curr : next);
    if (maxVal <= 0) maxVal = 100.0;

    final double targetLimit = maxVal / 0.8;
    double interval;
    if (targetLimit > 500) {
      interval = 200.0;
    } else if (targetLimit > 200) {
      interval = 100.0;
    } else {
      interval = 50.0;
    }
    final double maxValue = (targetLimit / interval).ceil() * interval;

    return GradientContainer(
      padding: EdgeInsets.all(20.w),
      borderRadius: BorderRadius.circular(24.r),
      border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Reward Sell",
                style: TextStyle(
                  fontFamily: "SF Pro Rounded",
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
              // Dropdown selection pill using PopupMenuButton
              PopupMenuButton<String>(
                onSelected: (value) {
                  setState(() {
                    _selectedTicketType = value;
                    _activeTicketIndex = value == "Week" ? 3 : 7;
                  });
                },
                color: const Color(0xFF1E222B),
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: "Week",
                    child: Text(
                      "Week",
                      style: TextStyle(color: Colors.white, fontSize: 13.sp),
                    ),
                  ),
                  PopupMenuItem(
                    value: "Month",
                    child: Text(
                      "Month",
                      style: TextStyle(color: Colors.white, fontSize: 13.sp),
                    ),
                  ),
                ],
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 14.w,
                    vertical: 6.h,
                  ),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Color(0xFFF8FFF5), Color(0xFFB3E588)],
                    ),
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Row(
                    children: [
                      Text(
                        _selectedTicketType,
                        style: TextStyle(
                          fontFamily: "SF Pro",
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF1A2E0F),
                        ),
                      ),
                      UIHelper.horizontalSpace(4),
                      Icon(
                        Icons.keyboard_arrow_down_rounded,
                        color: const Color(0xFF1A2E0F),
                        size: 16.w,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          UIHelper.verticalSpace(24),

          // Layout split: Left Y-Axis is frozen, Right chart area is scrollable
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Frozen Left Y-Axis labels (30.w width)
              SizedBox(
                width: 30.w,
                height: 210.h,
                child: CustomPaint(
                  painter: _YAxisLabelsPainter(maxValue: maxValue),
                ),
              ),
              UIHelper.horizontalSpace(8),

              // 2. Scrollable Chart Canvas
              Expanded(
                child: isWeek
                    ? LayoutBuilder(
                        builder: (context, constraints) {
                          final chartWidth = constraints.maxWidth;
                          return GestureDetector(
                            onTapUp: (details) {
                              _handleLineChartTap(
                                details.localPosition.dx,
                                chartWidth,
                                activeFractions,
                              );
                            },
                            child: SizedBox(
                              height: 210.h,
                              width: double.infinity,
                              child: CustomPaint(
                                painter: _LineChartPainter(
                                  labels: activeLabels,
                                  values: activeValues,
                                  xFractions: activeFractions,
                                  activeIndex: _activeTicketIndex,
                                  maxValue: maxValue,
                                  lineColor: AppColors.primaryColorSecond,
                                  gradientColorFirst:
                                      AppColors.primaryColorFirst,
                                  gradientColorSecond:
                                      AppColors.primaryColorSecond,
                                ),
                              ),
                            ),
                          );
                        },
                      )
                    : SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: GestureDetector(
                          onTapUp: (details) {
                            _handleLineChartTap(
                              details.localPosition.dx,
                              580.w,
                              activeFractions,
                            );
                          },
                          child: SizedBox(
                            height: 210.h,
                            width: 580.w, // scroll container width
                            child: CustomPaint(
                              painter: _LineChartPainter(
                                labels: activeLabels,
                                values: activeValues,
                                xFractions: activeFractions,
                                activeIndex: _activeTicketIndex,
                                maxValue: maxValue,
                                lineColor: AppColors.primaryColorSecond,
                                gradientColorFirst: AppColors.primaryColorFirst,
                                gradientColorSecond:
                                    AppColors.primaryColorSecond,
                              ),
                            ),
                          ),
                        ),
                      ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _handleLineChartTap(
    double tapX,
    double totalWidth,
    List<double> fractions,
  ) {
    const double startX = 10.0;
    final double endX = totalWidth - 10.0;
    final double totalGraphWidth = endX - startX;

    int closestIndex = 0;
    double minDistance = double.infinity;

    for (int i = 0; i < fractions.length; i++) {
      final double targetX = startX + fractions[i] * totalGraphWidth;
      final double distance = (tapX - targetX).abs();
      if (distance < minDistance) {
        minDistance = distance;
        closestIndex = i;
      }
    }

    setState(() {
      _activeTicketIndex = closestIndex;
    });
  }
}

// Frozen Y-Axis Labels Painter
class _YAxisLabelsPainter extends CustomPainter {
  final double maxValue;

  _YAxisLabelsPainter({required this.maxValue});

  @override
  void paint(Canvas canvas, Size size) {
    final double topPadding = 55.h;
    final double graphHeight = size.height - 30.h - topPadding;

    final textPainter = TextPainter(textDirection: TextDirection.ltr);

    final List<double> yGridValues = [
      maxValue,
      maxValue * 0.75,
      maxValue * 0.50,
      maxValue * 0.25,
      0.0,
    ];

    for (int i = 0; i < yGridValues.length; i++) {
      final double y =
          topPadding + graphHeight - (yGridValues[i] / maxValue) * graphHeight;

      textPainter.text = TextSpan(
        text: yGridValues[i].toInt().toString(),
        style: TextStyle(
          fontFamily: "SF Pro",
          fontSize: 10.sp,
          color: Colors.white.withValues(alpha: 0.4),
        ),
      );
      textPainter.layout();
      textPainter.paint(canvas, Offset(0, y - textPainter.height / 2));
    }
  }

  @override
  bool shouldRepaint(covariant _YAxisLabelsPainter oldDelegate) {
    return oldDelegate.maxValue != maxValue;
  }
}

// Scrollable Line Chart Painter
class _LineChartPainter extends CustomPainter {
  final List<String> labels;
  final List<double> values;
  final List<double> xFractions;
  final int activeIndex;
  final double maxValue;
  final Color lineColor;
  final Color gradientColorFirst;
  final Color gradientColorSecond;

  _LineChartPainter({
    required this.labels,
    required this.values,
    required this.xFractions,
    required this.activeIndex,
    required this.maxValue,
    required this.lineColor,
    required this.gradientColorFirst,
    required this.gradientColorSecond,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Left start margin is small (10.0) since Y-labels are drawn in a separate frozen widget on the left
    const double startX = 10.0;
    final double endX = size.width - 10.0;
    final double totalGraphWidth = endX - startX;

    final double topPadding = 55.h;
    final double graphHeight = size.height - 30.h - topPadding;

    final gridPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.25)
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;

    // Draw horizontal solid grid lines
    final List<double> yGridValues = [
      maxValue,
      maxValue * 0.75,
      maxValue * 0.50,
      maxValue * 0.25,
      0.0,
    ];

    for (int i = 0; i < yGridValues.length; i++) {
      final double y =
          topPadding + graphHeight - (yGridValues[i] / maxValue) * graphHeight;
      canvas.drawLine(Offset(startX, y), Offset(endX, y), gridPaint);
    }

    // 2. Data Points mapping using the precise xFractions, topPadding, and dynamic maxValue scaling
    final List<Offset> points = [];
    for (int i = 0; i < labels.length; i++) {
      final double x = startX + xFractions[i] * totalGraphWidth;
      final double normalizedY =
          topPadding + graphHeight - (values[i] / maxValue) * graphHeight;
      points.add(Offset(x, normalizedY));
    }

    // 3. Highlighted Solid Dark Vertical Bar under active point (behind everything)
    if (activeIndex >= 0 && activeIndex < points.length) {
      final Offset activePoint = points[activeIndex];
      final rect = Rect.fromLTRB(
        activePoint.dx - 12.w,
        activePoint.dy,
        activePoint.dx + 12.w,
        topPadding + graphHeight,
      );
      canvas.drawRect(rect, Paint()..color = const Color(0xFF1B1F26));
    }

    // 4. Shaded Area under the curve (straight/corner-based polygonal path)
    final fillPath = Path();
    fillPath.moveTo(points[0].dx, topPadding + graphHeight);
    fillPath.lineTo(points[0].dx, points[0].dy);
    for (int i = 1; i < points.length; i++) {
      fillPath.lineTo(points[i].dx, points[i].dy);
    }
    fillPath.lineTo(points.last.dx, topPadding + graphHeight);
    fillPath.close();

    // 5. Draw Dense Vertical Shaded Lines/Hatching underneath the curve
    canvas.save();
    canvas.clipPath(fillPath);
    final hatchingPaint = Paint()
      ..color = lineColor.withValues(alpha: 0.12)
      ..strokeWidth = 1.w;
    for (double x = startX; x <= endX; x += 3.w) {
      canvas.drawLine(
        Offset(x, topPadding),
        Offset(x, topPadding + graphHeight),
        hatchingPaint,
      );
    }
    canvas.restore();

    // 6. Draw straight line segments (corner-based polygonal line matching design exactly)
    final linePaint = Paint()
      ..shader =
          LinearGradient(
            colors: [gradientColorFirst, gradientColorSecond],
          ).createShader(
            Rect.fromLTWH(startX, topPadding, endX - startX, graphHeight),
          )
      ..strokeWidth = 2.5.w
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final path = Path();
    path.moveTo(points[0].dx, points[0].dy);
    for (int i = 1; i < points.length; i++) {
      path.lineTo(points[i].dx, points[i].dy);
    }
    canvas.drawPath(path, linePaint);

    // 7. Draw Vertex Dots
    final dotPaint = Paint()
      ..shader =
          LinearGradient(
            colors: [gradientColorFirst, gradientColorSecond],
          ).createShader(
            Rect.fromLTWH(startX, topPadding, endX - startX, graphHeight),
          )
      ..style = PaintingStyle.fill;

    final dotBorderPaint = Paint()
      ..color = const Color(0xFF1E222B)
      ..strokeWidth = 2.w
      ..style = PaintingStyle.stroke;

    for (int i = 0; i < points.length; i++) {
      canvas.drawCircle(points[i], 5.w, dotPaint);
      canvas.drawCircle(points[i], 5.w, dotBorderPaint);
    }

    // 8. Draw active tooltip (completely unclipped due to dynamic scaling + top clearance padding)
    if (activeIndex >= 0 && activeIndex < points.length) {
      final Offset activePoint = points[activeIndex];
      final tooltipPaint = Paint()
        ..shader =
            LinearGradient(
              colors: [gradientColorFirst, gradientColorSecond],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ).createShader(
              Rect.fromLTWH(
                activePoint.dx - 28.w,
                activePoint.dy - 44.h,
                56.w,
                28.h,
              ),
            )
        ..style = PaintingStyle.fill;

      // Tooltip RRect Box
      final Rect tooltipRect = Rect.fromLTWH(
        activePoint.dx - 28.w,
        activePoint.dy - 44.h,
        56.w,
        28.h,
      );
      final RRect tooltipRRect = RRect.fromRectAndRadius(
        tooltipRect,
        Radius.circular(8.r),
      );
      canvas.drawRRect(tooltipRRect, tooltipPaint);

      // Tooltip Downward Triangle pointer
      final Path pointerPath = Path()
        ..moveTo(activePoint.dx - 4.w, activePoint.dy - 17.h)
        ..lineTo(activePoint.dx + 4.w, activePoint.dy - 17.h)
        ..lineTo(activePoint.dx, activePoint.dy - 12.h)
        ..close();
      canvas.drawPath(pointerPath, tooltipPaint);

      // Tooltip Text based on active point value (May shows "300 Sell" per mockup)
      final int activeVal = (activeIndex == 7 && values[activeIndex] == 200.0)
          ? 300
          : values[activeIndex].toInt();

      final tooltipTextPainter = TextPainter(
        text: TextSpan(
          text: "$activeVal\nSells",
          style: TextStyle(
            fontFamily: "SF Pro Rounded",
            fontSize: 9.sp,
            fontWeight: FontWeight.w700,
            color: Colors.black,
            height: 1.1,
          ),
        ),
        textAlign: TextAlign.center,
        textDirection: TextDirection.ltr,
      );
      tooltipTextPainter.layout();
      tooltipTextPainter.paint(
        canvas,
        Offset(
          tooltipRect.left + (tooltipRect.width - tooltipTextPainter.width) / 2,
          tooltipRect.top +
              (tooltipRect.height - tooltipTextPainter.height) / 2,
        ),
      );
    }

    // 9. Draw Month Labels at the bottom (only for items that have a label string)
    final textPainter = TextPainter(textDirection: TextDirection.ltr);
    for (int i = 0; i < labels.length; i++) {
      if (labels[i].isEmpty) continue;

      final isSelected = (i == activeIndex);
      textPainter.text = TextSpan(
        text: labels[i],
        style: TextStyle(
          fontFamily: "SF Pro",
          fontSize: 12.sp,
          color: isSelected
              ? AppColors.primaryColorSecond
              : Colors.white.withValues(alpha: isSelected ? 1.0 : 0.4),
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
        ),
      );
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(
          points[i].dx - textPainter.width / 2,
          size.height - textPainter.height,
        ),
      );
    }
  }

  @override
  bool shouldRepaint(covariant _LineChartPainter oldDelegate) {
    return oldDelegate.labels != labels ||
        oldDelegate.values != values ||
        oldDelegate.xFractions != xFractions ||
        oldDelegate.activeIndex != activeIndex ||
        oldDelegate.maxValue != maxValue ||
        oldDelegate.lineColor != lineColor ||
        oldDelegate.gradientColorFirst != gradientColorFirst ||
        oldDelegate.gradientColorSecond != gradientColorSecond;
  }
}
