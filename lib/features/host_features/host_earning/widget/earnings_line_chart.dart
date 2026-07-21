import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:teamstreakpromo/gen/colors.gen.dart';
import 'package:teamstreakpromo/helpers/ui_helpers.dart';
import 'package:teamstreakpromo/common_widgets/gradient_container.dart';

class EarningsLineChart extends StatefulWidget {
  const EarningsLineChart({super.key});

  @override
  State<EarningsLineChart> createState() => _EarningsLineChartState();
}

class _EarningsLineChartState extends State<EarningsLineChart> {
  String _selectedStatPeriod = "Week";
  int? _activeIndex = 10;

  // Data values representing the mockup curve (15 points)
  final List<double> _chartValues = [
    200,
    320,
    260,
    290,
    210,
    230,
    280,
    180,
    260,
    250,
    380,
    280,
    310,
    220,
    190,
  ];

  // X axis labels
  final List<String> _xAxisMonths = ["Jan", "Feb", "Mar", "Apr", "May", "Jun"];

  @override
  Widget build(BuildContext context) {
    return GradientContainer(
      padding: EdgeInsets.all(20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Statistics Card Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Earning statistics",
                style: TextStyle(
                  fontFamily: "SF Pro Rounded",
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
              PopupMenuButton<String>(
                onSelected: (value) {
                  setState(() {
                    _selectedStatPeriod = value;
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
                    color: AppColors.primaryColorSecond.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Row(
                    children: [
                      Text(
                        _selectedStatPeriod,
                        style: TextStyle(
                          fontFamily: "SF Pro",
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primaryColorSecond,
                        ),
                      ),
                      UIHelper.horizontalSpace(4),
                      Icon(
                        Icons.keyboard_arrow_down_rounded,
                        color: AppColors.primaryColorSecond,
                        size: 16.w,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          UIHelper.verticalSpace(24),

          // Earning statistics Line Chart Canvas
          SizedBox(
            height: 220.h,
            width: double.infinity,
            child: LayoutBuilder(
              builder: (context, constraints) {
                return GestureDetector(
                  onTapUp: (details) {
                    final double labelWidth = 30.w;
                    final double graphWidth = constraints.maxWidth - labelWidth;
                    final double segmentWidth = graphWidth / (_chartValues.length - 1);
                    final double tapX = details.localPosition.dx;
                    int index = ((tapX - labelWidth) / segmentWidth).round();
                    index = index.clamp(0, _chartValues.length - 1);
                    setState(() {
                      _activeIndex = index;
                    });
                  },
                  child: CustomPaint(
                    painter: _EarningsLineChartPainter(
                      values: _chartValues,
                      xMonths: _xAxisMonths,
                      activeIndex: _activeIndex,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// Custom Painter to draw the beautiful line chart with dynamic tooltip
class _EarningsLineChartPainter extends CustomPainter {
  final List<double> values;
  final List<String> xMonths;
  final int? activeIndex;

  _EarningsLineChartPainter({
    required this.values,
    required this.xMonths,
    this.activeIndex,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final double labelWidth = 30.w;
    final double graphWidth = size.width - labelWidth;
    final double graphHeight = size.height - 30.h;

    // 1. Draw horizontal gridlines and Y axis labels
    final textPainter = TextPainter(textDirection: TextDirection.ltr);
    final List<int> yLabels = [400, 300, 200, 100, 0];
    final gridPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.08)
      ..strokeWidth = 1.h;

    for (int i = 0; i < yLabels.length; i++) {
      final double y = (i / (yLabels.length - 1)) * graphHeight;

      // Draw Y label
      textPainter.text = TextSpan(
        text: yLabels[i].toString(),
        style: TextStyle(
          fontFamily: "SF Pro",
          fontSize: 10.sp,
          color: Colors.white.withValues(alpha: 0.4),
        ),
      );
      textPainter.layout();
      textPainter.paint(canvas, Offset(0, y - textPainter.height / 2));

      // Draw grid line
      canvas.drawLine(Offset(labelWidth, y), Offset(size.width, y), gridPaint);
    }

    if (values.isEmpty) return;

    // 2. Draw X labels
    final double xStep = graphWidth / (xMonths.length - 1);
    for (int i = 0; i < xMonths.length; i++) {
      final double x = labelWidth + i * xStep;
      textPainter.text = TextSpan(
        text: xMonths[i],
        style: TextStyle(
          fontFamily: "SF Pro",
          fontSize: 10.sp,
          color: Colors.white.withValues(alpha: 0.4),
        ),
      );
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(x - textPainter.width / 2, graphHeight + 10.h),
      );
    }

    // 3. Draw gradient area fill and green line chart
    final double segmentWidth = graphWidth / (values.length - 1);
    final List<Offset> points = [];
    for (int i = 0; i < values.length; i++) {
      final double x = labelWidth + i * segmentWidth;
      final double y = graphHeight - (values[i] / 400.0) * graphHeight;
      points.add(Offset(x, y));
    }

    // Generate smooth Bezier path
    final path = Path();
    path.moveTo(points[0].dx, points[0].dy);
    for (int i = 0; i < points.length - 1; i++) {
      final p0 = points[i];
      final p1 = points[i + 1];
      final controlX = (p0.dx + p1.dx) / 2;
      path.cubicTo(controlX, p0.dy, controlX, p1.dy, p1.dx, p1.dy);
    }

    // Draw gradient fill below path
    final fillPath = Path.from(path);
    fillPath.lineTo(points.last.dx, graphHeight);
    fillPath.lineTo(points.first.dx, graphHeight);
    fillPath.close();

    final fillPaint = Paint()
      ..shader = LinearGradient(
        colors: [
          const Color(0xFF72E84F).withValues(alpha: 0.35),
          const Color(0xFF72E84F).withValues(alpha: 0.0),
        ],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(Rect.fromLTWH(labelWidth, 0, graphWidth, graphHeight));

    canvas.drawPath(fillPath, fillPaint);

    // Draw glowing green line
    final linePaint = Paint()
      ..color = const Color(0xFF72E84F)
      ..strokeWidth = 2.5.w
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawPath(path, linePaint);

    // 4. Draw tool-tip callout if an index is active
    if (activeIndex != null && activeIndex! >= 0 && activeIndex! < points.length) {
      final activePoint = points[activeIndex!];
      final double activeValue = values[activeIndex!];

    // Tooltip point highlight circle
    final activeDotPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    final activeDotBorderPaint = Paint()
      ..color = const Color(0xFF1E222B)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5.w;

    canvas.drawCircle(activePoint, 5.r, activeDotPaint);
    canvas.drawCircle(activePoint, 5.r, activeDotBorderPaint);

    // Draw Tooltip Box ($500 Income) above activePoint
    final double tooltipWidth = 60.w;
    final double tooltipHeight = 35.h;
    final double tooltipX = activePoint.dx - tooltipWidth / 2;
    final double tooltipY = activePoint.dy - tooltipHeight - 12.h;

    final RRect tooltipRRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(tooltipX, tooltipY, tooltipWidth, tooltipHeight),
      Radius.circular(8.r),
    );

    // Tooltip gradient paint
    final tooltipPaint = Paint()
      ..shader =
          const LinearGradient(
            colors: [Color(0xFFE2C94F), Color(0xFFB1D842)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ).createShader(
            Rect.fromLTWH(tooltipX, tooltipY, tooltipWidth, tooltipHeight),
          );

    canvas.drawRRect(tooltipRRect, tooltipPaint);

    // Draw small downward triangle tip for callout
    final tipPath = Path();
    tipPath.moveTo(activePoint.dx - 5.w, tooltipY + tooltipHeight);
    tipPath.lineTo(activePoint.dx + 5.w, tooltipY + tooltipHeight);
    tipPath.lineTo(activePoint.dx, tooltipY + tooltipHeight + 5.h);
    tipPath.close();

    final tipPaint = Paint()..color = const Color(0xFFB1D842);
    canvas.drawPath(tipPath, tipPaint);

    // Tooltip text (dynamic value)
    textPainter.text = TextSpan(
      text: "\$${activeValue.toInt()}",
      style: TextStyle(
        fontFamily: "SF Pro Rounded",
        fontSize: 11.sp,
        fontWeight: FontWeight.w800,
        color: Colors.black87,
      ),
    );
    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(activePoint.dx - textPainter.width / 2, tooltipY + 4.h),
    );

    // Tooltip text "Income"
    textPainter.text = TextSpan(
      text: "Income",
      style: TextStyle(
        fontFamily: "SF Pro",
        fontSize: 8.sp,
        fontWeight: FontWeight.w600,
        color: Colors.black54,
      ),
    );
    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(activePoint.dx - textPainter.width / 2, tooltipY + 18.h),
    );
    }
  }

  @override
  bool shouldRepaint(covariant _EarningsLineChartPainter oldDelegate) {
    return oldDelegate.values != values ||
        oldDelegate.xMonths != xMonths ||
        oldDelegate.activeIndex != activeIndex;
  }
}
