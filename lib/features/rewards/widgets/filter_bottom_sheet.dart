import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../gen/colors.gen.dart';
import '../../../constants/text_font_style.dart';
import '../../../helpers/ui_helpers.dart';
import '../../../common_widgets/custom_gradient_button.dart';
// We can reuse the slider shapes from the home filter or redefine them here if needed.
// For self-containment, I'll redefine them or use them if they are public.
// But they are private to that file or in the same package. I'll copy the slider classes.

class RewardsFilterBottomSheet extends StatefulWidget {
  const RewardsFilterBottomSheet({super.key});

  @override
  State<RewardsFilterBottomSheet> createState() => _RewardsFilterBottomSheetState();
}

class _RewardsFilterBottomSheetState extends State<RewardsFilterBottomSheet> {
  // Filter States
  String _selectedCategory = 'Sandals';
  String _selectedCompany = 'Nike';
  String _selectedRewardType = 'Drop Shoulder';
  RangeValues _pointRange = const RangeValues(10, 95);
  String _selectedPoints = '25 pts';
  DateTime? _fromDate;
  DateTime? _toDate;

  // Constants lists
  static const List<String> _categories = ['T-shirt', 'Jersey', 'Shoes', 'Sandals', 'Boots'];
  static const List<String> _companies = ['Adidas', 'Nike', 'Convers', 'Vans', 'Piero'];
  static const List<String> _rewardTypes = ['Running Show', 'Slipper', 'Casual Shoes', 'Cuban collar Shirt', 'T shirt', 'Drop Shoulder'];
  static const List<String> _pointsOptions = ['10 pts', '15 pts', '20 pts', '25 pts', '30 pts', '35 pts'];

  void _resetFilters() {
    setState(() {
      _selectedCategory = 'Sandals';
      _selectedCompany = 'Nike';
      _selectedRewardType = 'Drop Shoulder';
      _pointRange = const RangeValues(10, 95);
      _selectedPoints = '25 pts';
      _fromDate = null;
      _toDate = null;
    });
  }

  Future<void> _selectDate(BuildContext context, bool isFrom) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.dark(
              primary: AppColors.primaryColorSecond, // header background color
              onPrimary: Colors.black, // header text color
              onSurface: Colors.white, // body text color
              surface: Color(0xFF1E222B), // dialog background color
            ),
            dialogBackgroundColor: const Color(0xFF1E222B),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        if (isFrom) {
          _fromDate = picked;
        } else {
          _toDate = picked;
        }
      });
    }
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: EdgeInsets.only(top: 18.h, bottom: 8.h),
      child: Text(
        title,
        style: TextFontStyle.textStyle24cFFFFFFSFPro590.copyWith(
          fontSize: 15.sp,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildPillWrap({
    required List<String> options,
    required String selectedValue,
    required ValueChanged<String> onSelected,
    bool isGradientSolid = false,
  }) {
    return Wrap(
      spacing: 8.w,
      runSpacing: 8.h,
      children: options.map((option) {
        final isSelected = option == selectedValue;

        if (isSelected) {
          if (isGradientSolid) {
            return GestureDetector(
              onTap: () => onSelected(option),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100.r),
                  gradient: const LinearGradient(
                    colors: [AppColors.primaryColorFirst, AppColors.primaryColorSecond],
                  ),
                ),
                child: Text(
                  option,
                  style: TextFontStyle.textStyle14cFFFFFFSFProRounded400.copyWith(
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                    fontSize: 13.sp,
                  ),
                ),
              ),
            );
          } else {
            return GestureDetector(
              onTap: () => onSelected(option),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100.r),
                  gradient: const LinearGradient(
                    colors: [AppColors.primaryColorFirst, AppColors.primaryColorSecond],
                  ),
                ),
                child: Container(
                  margin: EdgeInsets.all(1.w),
                  padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 7.h),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E222B),
                    borderRadius: BorderRadius.circular(100.r),
                  ),
                  child: Text(
                    option,
                    style: TextFontStyle.textStyle14cFFFFFFSFProRounded400.copyWith(
                      color: AppColors.cA8FF8E,
                      fontWeight: FontWeight.w600,
                      fontSize: 13.sp,
                    ),
                  ),
                ),
              ),
            );
          }
        }

        return GestureDetector(
          onTap: () => onSelected(option),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            decoration: BoxDecoration(
              color: const Color(0xFF1E222B),
              borderRadius: BorderRadius.circular(100.r),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.1),
                width: 1.w,
              ),
            ),
            child: Text(
              option,
              style: TextFontStyle.textStyle14cFFFFFFSFProRounded400.copyWith(
                color: Colors.white.withValues(alpha: 0.5),
                fontWeight: FontWeight.w400,
                fontSize: 13.sp,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildDatePickerBox(String label, DateTime? date, bool isFrom) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextFontStyle.textStyle14cFFFFFFSFProRounded400.copyWith(
            color: Colors.white.withValues(alpha: 0.5),
            fontSize: 12.sp,
          ),
        ),
        UIHelper.verticalSpace(8.h),
        GestureDetector(
          onTap: () => _selectDate(context, isFrom),
          child: Container(
            height: 48.h,
            padding: EdgeInsets.symmetric(horizontal: 12.w),
            decoration: BoxDecoration(
              color: const Color(0xFF1E222B),
              borderRadius: BorderRadius.circular(24.r),
              border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
            ),
            child: Row(
              children: [
                Icon(Icons.calendar_today_outlined, color: Colors.white.withValues(alpha: 0.5), size: 16.sp),
                UIHelper.horizontalSpace(8.w),
                Text(
                  date != null 
                    ? "${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}" 
                    : "DD/MM/YYYY",
                  style: TextFontStyle.textStyle14cFFFFFFSFProRounded400.copyWith(
                    color: date != null ? Colors.white : Colors.white.withValues(alpha: 0.5),
                    fontSize: 13.sp,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: BoxDecoration(
        color: const Color(0xFF1E222B),
        borderRadius: BorderRadius.vertical(top: Radius.circular(28.r)),
      ),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(top: 12.h, bottom: 8.h),
            child: Column(
              children: [
                Container(
                  width: 40.w,
                  height: 4.h,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(2.r),
                  ),
                ),
                UIHelper.verticalSpace(12.h),
                Text(
                  "Filter Events",
                  style: TextFontStyle.textStyle24cFFFFFFSFPro590.copyWith(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle("Categories"),
                  _buildPillWrap(
                    options: _categories,
                    selectedValue: _selectedCategory,
                    onSelected: (val) => setState(() => _selectedCategory = val),
                  ),

                  _buildSectionTitle("Company"),
                  _buildPillWrap(
                    options: _companies,
                    selectedValue: _selectedCompany,
                    onSelected: (val) => setState(() => _selectedCompany = val),
                  ),

                  _buildSectionTitle("Reward Type"),
                  _buildPillWrap(
                    options: _rewardTypes,
                    selectedValue: _selectedRewardType,
                    onSelected: (val) => setState(() => _selectedRewardType = val),
                  ),

                  _buildSectionTitle("Expiry Date"),
                  Row(
                    children: [
                      Expanded(child: _buildDatePickerBox("From", _fromDate, true)),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.w).copyWith(top: 24.h),
                        child: Icon(Icons.sync_alt_rounded, color: Colors.white, size: 24.sp),
                      ),
                      Expanded(child: _buildDatePickerBox("To", _toDate, false)),
                    ],
                  ),

                  _buildSectionTitle("Point Range"),
                  SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      activeTrackColor: AppColors.primaryColorSecond,
                      inactiveTrackColor: Colors.white.withValues(alpha: 0.1),
                      trackHeight: 4.h,
                      rangeTrackShape: const GradientRangeSliderTrackShape(),
                      rangeThumbShape: const GradientRangeSliderThumbShape(enabledThumbRadius: 10),
                      overlayColor: AppColors.primaryColorSecond.withValues(alpha: 0.12),
                    ),
                    child: RangeSlider(
                      values: _pointRange,
                      min: 10,
                      max: 100,
                      onChanged: (values) {
                        setState(() {
                          _pointRange = values;
                        });
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.w),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "${_pointRange.start.round()} pts",
                          style: TextFontStyle.textStyle14cFFFFFFSFProRounded400.copyWith(
                            color: Colors.white.withValues(alpha: 0.5),
                            fontSize: 12.sp,
                          ),
                        ),
                        Text(
                          "${_pointRange.end.round()} pts",
                          style: TextFontStyle.textStyle14cFFFFFFSFProRounded400.copyWith(
                            color: Colors.white.withValues(alpha: 0.5),
                            fontSize: 12.sp,
                          ),
                        ),
                      ],
                    ),
                  ),

                  _buildSectionTitle("Points"),
                  _buildPillWrap(
                    options: _pointsOptions,
                    selectedValue: _selectedPoints,
                    onSelected: (val) => setState(() => _selectedPoints = val),
                  ),
                  
                  UIHelper.verticalSpace(24.h),
                ],
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(24.w, 16.h, 24.w, 24.h),
            decoration: BoxDecoration(
              color: const Color(0xFF1E222B),
              border: Border(
                top: BorderSide(
                  color: Colors.white.withValues(alpha: 0.05),
                  width: 1.w,
                ),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: _resetFilters,
                    child: Container(
                      height: 48.h,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100.r),
                        border: Border.all(
                          color: AppColors.primaryColorSecond,
                          width: 1.w,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          "Reset",
                          style: TextFontStyle.textStyle14cFFFFFFSFProRounded400.copyWith(
                            color: AppColors.primaryColorSecond,
                            fontWeight: FontWeight.w600,
                            fontSize: 15.sp,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                UIHelper.horizontalSpace(16.w),
                Expanded(
                  child: CustomGradientButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    title: "Apply",
                    height: 48.h,
                    borderRadius: BorderRadius.circular(100.r),
                    textStyle: TextFontStyle.textStyle14cFFFFFFSFProRounded400.copyWith(
                      color: const Color(0xFF262824),
                      fontWeight: FontWeight.w700,
                      fontSize: 15.sp,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Custom Gradient RangeSlider Track Painter ─────────────────────
class GradientRangeSliderTrackShape extends RangeSliderTrackShape {
  const GradientRangeSliderTrackShape();

  @override
  Rect getPreferredRect({
    required RenderBox parentBox,
    Offset offset = Offset.zero,
    required SliderThemeData sliderTheme,
    bool isEnabled = false,
    bool isDiscrete = false,
  }) {
    final double trackHeight = sliderTheme.trackHeight ?? 4.0;
    const double minThumbGap = 16.0;
    final double trackLeft = offset.dx + minThumbGap;
    final double trackTop = offset.dy + (parentBox.size.height - trackHeight) / 2;
    final double trackWidth = parentBox.size.width - minThumbGap * 2;
    return Rect.fromLTWH(trackLeft, trackTop, trackWidth, trackHeight);
  }

  @override
  void paint(
    PaintingContext context,
    Offset offset, {
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required Animation<double> enableAnimation,
    required Offset startThumbCenter,
    required Offset endThumbCenter,
    bool isEnabled = false,
    bool isDiscrete = false,
    required TextDirection textDirection,
  }) {
    final Canvas canvas = context.canvas;
    final double trackHeight = sliderTheme.trackHeight ?? 4.0;
    final Rect preferredRect = getPreferredRect(
      parentBox: parentBox,
      offset: offset,
      sliderTheme: sliderTheme,
      isEnabled: isEnabled,
      isDiscrete: isDiscrete,
    );

    final Paint inactivePaint = Paint()
      ..color = sliderTheme.inactiveTrackColor ?? Colors.grey
      ..style = PaintingStyle.fill;
    
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTRB(
          preferredRect.left,
          preferredRect.top,
          startThumbCenter.dx,
          preferredRect.bottom,
        ),
        Radius.circular(trackHeight / 2),
      ),
      inactivePaint,
    );

    final Paint activePaint = Paint()
      ..shader = const LinearGradient(
        colors: [
          AppColors.primaryColorFirst,
          AppColors.primaryColorSecond,
        ],
      ).createShader(preferredRect)
      ..style = PaintingStyle.fill;

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTRB(
          startThumbCenter.dx,
          preferredRect.top,
          endThumbCenter.dx,
          preferredRect.bottom,
        ),
        Radius.circular(trackHeight / 2),
      ),
      activePaint,
    );

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTRB(
          endThumbCenter.dx,
          preferredRect.top,
          preferredRect.right,
          preferredRect.bottom,
        ),
        Radius.circular(trackHeight / 2),
      ),
      inactivePaint,
    );
  }
}

// ── Custom Gradient RangeSlider Thumb Painter ─────────────────────
class GradientRangeSliderThumbShape extends RangeSliderThumbShape {
  final double enabledThumbRadius;

  const GradientRangeSliderThumbShape({this.enabledThumbRadius = 10.0});

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return Size.fromRadius(enabledThumbRadius);
  }

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    required Animation<double> activationAnimation,
    required Animation<double> enableAnimation,
    bool isDiscrete = false,
    bool isEnabled = false,
    bool isOnTop = false,
    bool isPressed = false,
    required SliderThemeData sliderTheme,
    TextDirection textDirection = TextDirection.ltr,
    Thumb thumb = Thumb.start,
  }) {
    final Canvas canvas = context.canvas;

    final Paint outerPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, enabledThumbRadius, outerPaint);

    final Paint innerPaint = Paint()
      ..shader = const LinearGradient(
        colors: [AppColors.primaryColorFirst, AppColors.primaryColorSecond],
      ).createShader(Rect.fromCircle(center: center, radius: enabledThumbRadius - 2.5.w))
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, enabledThumbRadius - 2.5.w, innerPaint);
  }
}
