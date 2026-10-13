import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:teamstreakpromo/common_widgets/gradient_container.dart';
import 'package:teamstreakpromo/gen/colors.gen.dart';
import 'package:teamstreakpromo/helpers/ui_helpers.dart';

class RevenueChartCard extends StatefulWidget {
  const RevenueChartCard({super.key});

  @override
  State<RevenueChartCard> createState() => _RevenueChartCardState();
}

class _RevenueChartCardState extends State<RevenueChartCard> {
  String _selectedRevenueType = "Week";
  int _activeRevenueIndex = 3; // Thu (Week) or Apr (Month) by default

  // Data sets for Revenue bar chart
  final List<Map<String, dynamic>> _revenueWeekData = [
    {"label": "Mon", "value": 35.0, "tooltip": "\$175\nIncome"},
    {"label": "Tue", "value": 75.0, "tooltip": "\$375\nIncome"},
    {"label": "Wed", "value": 50.0, "tooltip": "\$250\nIncome"},
    {"label": "Thu", "value": 100.0, "tooltip": "\$500\nIncome"},
    {"label": "Fri", "value": 35.0, "tooltip": "\$175\nIncome"},
    {"label": "Sat", "value": 50.0, "tooltip": "\$250\nIncome"},
  ];

  final List<Map<String, dynamic>> _revenueMonthData = [
    {"label": "Jan", "value": 30.0, "tooltip": "\$150\nIncome"},
    {"label": "Feb", "value": 60.0, "tooltip": "\$300\nIncome"},
    {"label": "Mar", "value": 45.0, "tooltip": "\$225\nIncome"},
    {"label": "Apr", "value": 100.0, "tooltip": "\$500\nIncome"},
    {"label": "May", "value": 30.0, "tooltip": "\$150\nIncome"},
    {"label": "Jun", "value": 45.0, "tooltip": "\$225\nIncome"},
    {"label": "Jul", "value": 55.0, "tooltip": "\$275\nIncome"},
    {"label": "Aug", "value": 80.0, "tooltip": "\$400\nIncome"},
    {"label": "Sep", "value": 60.0, "tooltip": "\$300\nIncome"},
    {"label": "Oct", "value": 75.0, "tooltip": "\$375\nIncome"},
    {"label": "Nov", "value": 40.0, "tooltip": "\$200\nIncome"},
    {"label": "Dec", "value": 70.0, "tooltip": "\$350\nIncome"},
  ];

  @override
  Widget build(BuildContext context) {
    final gradient = LinearGradient(
      colors: [AppColors.primaryColorFirst, AppColors.primaryColorSecond],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
    );

    final isWeek = _selectedRevenueType == "Week";
    final activeData = isWeek ? _revenueWeekData : _revenueMonthData;

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
                "Revenue Stream",
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
                    _selectedRevenueType = value;
                    _activeRevenueIndex = 3; // Reset default
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
                        _selectedRevenueType,
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
          UIHelper.verticalSpace(36),

          // Scrollable/Fixed Chart content with tap detection
          Stack(
            children: [
              // Horizontal grid lines
              Positioned(
                left: 0,
                right: 0,
                bottom: 24.h, // Aligns with the bottom of the bars
                child: Column(
                  children: [
                    Divider(color: Colors.white.withValues(alpha: 0.25), height: 1, thickness: 1),
                    SizedBox(height: 33.h),
                    Divider(color: Colors.white.withValues(alpha: 0.25), height: 1, thickness: 1),
                    SizedBox(height: 33.h),
                    Divider(color: Colors.white.withValues(alpha: 0.25), height: 1, thickness: 1),
                    SizedBox(height: 33.h),
                    Divider(color: Colors.white.withValues(alpha: 0.25), height: 1, thickness: 1),
                  ],
                ),
              ),
              isWeek
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: List.generate(activeData.length, (index) {
                        final item = activeData[index];
                        final isItemActive = _activeRevenueIndex == index;
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              _activeRevenueIndex = index;
                            });
                          },
                          behavior: HitTestBehavior.opaque,
                          child: isItemActive
                              ? _buildActiveBarWithTooltip(
                                  month: item["label"],
                                  height: (item["value"] as double).h,
                                  tooltip: item["tooltip"],
                                  gradient: gradient,
                                )
                              : _buildBar(
                                  month: item["label"],
                                  height: (item["value"] as double).h,
                                ),
                        );
                      }),
                    )
                  : SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Padding(
                        padding: EdgeInsets.only(top: 20.h), // spacing for tooltips
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: List.generate(activeData.length, (index) {
                            final item = activeData[index];
                            final isItemActive = _activeRevenueIndex == index;
                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  _activeRevenueIndex = index;
                                });
                              },
                              behavior: HitTestBehavior.opaque,
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 10.w),
                                child: isItemActive
                                    ? _buildActiveBarWithTooltip(
                                        month: item["label"],
                                        height: (item["value"] as double).h,
                                        tooltip: item["tooltip"],
                                        gradient: gradient,
                                      )
                                    : _buildBar(
                                        month: item["label"],
                                        height: (item["value"] as double).h,
                                      ),
                              ),
                            );
                          }),
                        ),
                      ),
                    ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBar({required String month, required double height}) {
    return Column(
      children: [
        Container(
          width: 32.w,
          height: height,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(6.r),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.08),
              width: 1.w,
            ),
          ),
        ),
        UIHelper.verticalSpace(10),
        Text(
          month,
          style: TextStyle(
            fontFamily: "SF Pro",
            fontSize: 12.sp,
            color: Colors.white.withValues(alpha: 0.4),
          ),
        ),
      ],
    );
  }

  Widget _buildActiveBarWithTooltip({
    required String month,
    required double height,
    required String tooltip,
    required Gradient gradient,
  }) {
    return Column(
      children: [
        // Tooltip pill pointing down
        Stack(
          alignment: Alignment.bottomCenter,
          clipBehavior: Clip.none,
          children: [
            Container(
              margin: EdgeInsets.only(bottom: 6.h),
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
              decoration: BoxDecoration(
                color: AppColors.primaryColorSecond,
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Text(
                tooltip,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: "SF Pro Rounded",
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                  height: 1.2,
                ),
              ),
            ),
            // Downward triangle indicator for tooltip
            Positioned(
              bottom: 1.h,
              child: ClipPath(
                clipper: _TriangleClipper(),
                child: Container(
                  width: 10.w,
                  height: 5.h,
                  color: AppColors.primaryColorSecond,
                ),
              ),
            ),
          ],
        ),
        Container(
          width: 32.w,
          height: height,
          decoration: BoxDecoration(
            gradient: gradient,
            borderRadius: BorderRadius.circular(6.r),
          ),
        ),
        UIHelper.verticalSpace(10),
        Text(
          month,
          style: TextStyle(
            fontFamily: "SF Pro",
            fontSize: 12.sp,
            color: AppColors.primaryColorSecond,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class _TriangleClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width, 0)
      ..lineTo(size.width / 2, size.height)
      ..close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
