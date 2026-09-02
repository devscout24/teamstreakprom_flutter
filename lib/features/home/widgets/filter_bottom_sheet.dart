import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../gen/colors.gen.dart';
import '../../../constants/text_font_style.dart';
import '../../../helpers/ui_helpers.dart';
import '../../../common_widgets/custom_gradient_button.dart';
import '../../../../networks/api_acess.dart';
import '../../onboarding/model/intrest_category_model.dart';

class FilterBottomSheet extends StatefulWidget {
  const FilterBottomSheet({super.key});

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  // Filter States
  String _selectedContentType = 'Events';
  String _selectedCategory = '';
  String _selectedSubCategory = '';
  String _selectedEventDate = '';
  RangeValues _priceRange = const RangeValues(10, 95);
  String _selectedDistance = '';
  String _selectedAvailability = '';
  String _selectedRewardsAvailable = '';

  // Constants lists
  static const List<String> _contentTypes = ['Events', 'Business Rewards'];
  static const List<String> _eventDates = [
    'Today',
    'Tomorrow',
    'This Week',
    'Custom',
  ];
  static const List<String> _distances = [
    '5 miles',
    '10 miles',
    '15 miles',
    '20 miles',
    'Anywhere',
  ];
  static const List<String> _availabilities = [
    'Available',
    'Sold Out',
    'Few Left',
  ];
  static const List<String> _rewardsAvailableOptions = [
    'Has Rewards',
    'No Rewards',
  ];

  String _selectedCompany = '';
  String _selectedRewardType = '';
  String _selectedPoint = '';
  RangeValues _pointRange = const RangeValues(10, 95);
  DateTime? _fromDate;
  DateTime? _toDate;

  static const List<String> _companies = [
    'Adidas',
    'Nike',
    'Convers',
    'Vans',
    'Piero',
  ];
  static const List<String> _rewardTypes = [
    'Running Show',
    'Slipper',
    'Casual Shoes',
    'Cuban collar Shirt',
    'T shirt',
    'Drop Shoulder',
  ];
  static const List<String> _points = [
    '10 pts',
    '15 pts',
    '20 pts',
    '25 pts',
    '30 pts',
    '35 pts',
  ];

  void _resetFilters() {
    setState(() {
      _selectedContentType = 'Events';
      _selectedCategory = '';
      _selectedSubCategory = '';
      _selectedEventDate = '';
      _priceRange = const RangeValues(10, 95);
      _selectedDistance = '';
      _selectedAvailability = '';
      _selectedRewardsAvailable = '';

      _selectedCompany = '';
      _selectedRewardType = '';
      _selectedPoint = '';
      _pointRange = const RangeValues(10, 95);
      _fromDate = null;
      _toDate = null;
    });
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
            // Solid gradient style
            return GestureDetector(
              onTap: () => onSelected(option),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100.r),
                  gradient: const LinearGradient(
                    colors: [
                      AppColors.primaryColorFirst,
                      AppColors.primaryColorSecond,
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: Text(
                  option,
                  style: TextFontStyle.textStyle14cFFFFFFSFProRounded400
                      .copyWith(
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                        fontSize: 13.sp,
                      ),
                ),
              ),
            );
          } else {
            // Gradient border style (with inner container matching the background)
            return GestureDetector(
              onTap: () => onSelected(option),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100.r),
                  gradient: const LinearGradient(
                    colors: [
                      AppColors.primaryColorFirst,
                      AppColors.primaryColorSecond,
                    ],
                  ),
                ),
                child: Container(
                  margin: EdgeInsets.all(1.w),
                  padding: EdgeInsets.symmetric(
                    horizontal: 15.w,
                    vertical: 7.h,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E222B),
                    borderRadius: BorderRadius.circular(100.r),
                  ),
                  child: Text(
                    option,
                    style: TextFontStyle.textStyle14cFFFFFFSFProRounded400
                        .copyWith(
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

        // Unselected style (grey border)
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

  Future<void> _selectDate(
    BuildContext context, {
    required bool isFromDate,
  }) async {
    final DateTime initialDate = isFromDate
        ? (_fromDate ?? DateTime.now())
        : (_toDate ?? _fromDate ?? DateTime.now());
    final DateTime firstDate = isFromDate
        ? DateTime(2000)
        : (_fromDate ?? DateTime(2000));
    final DateTime lastDate = DateTime(2100);

    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: const ColorScheme.dark(
              primary: AppColors.primaryColorSecond, // Selected date background
              onPrimary: Colors.black, // Selected date text
              surface: Color(0xFF1E222B), // Calendar background
              onSurface: Colors.white, // Default text color
            ),
            dialogBackgroundColor: const Color(0xFF1E222B),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null) {
      setState(() {
        if (isFromDate) {
          _fromDate = pickedDate;
          if (_toDate != null && _toDate!.isBefore(pickedDate)) {
            _toDate = null;
          }
        } else {
          _toDate = pickedDate;
        }
      });
    }
  }

  Widget _buildDatePickerField(
    String label,
    DateTime? selectedDate,
    VoidCallback onTap,
  ) {
    final String dateString = selectedDate != null
        ? "${selectedDate.day.toString().padLeft(2, '0')}/${selectedDate.month.toString().padLeft(2, '0')}/${selectedDate.year}"
        : "DD/MM/YYYY";

    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextFontStyle.textStyle14cFFFFFFSFProRounded400.copyWith(
                fontSize: 12.sp,
                color: Colors.white.withValues(alpha: 0.8),
              ),
            ),
            UIHelper.verticalSpace(8.h),
            Container(
              height: 48.h,
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(100.r),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.2),
                  width: 1.w,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.calendar_month_outlined,
                    color: Colors.white.withValues(alpha: 0.5),
                    size: 20.sp,
                  ),
                  UIHelper.horizontalSpace(8.w),
                  Expanded(
                    child: Text(
                      dateString,
                      style: TextFontStyle.textStyle14cFFFFFFSFProRounded400
                          .copyWith(
                            fontSize: 14.sp,
                            color: selectedDate != null
                                ? Colors.white
                                : Colors.white.withValues(alpha: 0.3),
                          ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
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
          // Drag Handle & Header Section
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
                  "Filters",
                  style: TextFontStyle.textStyle24cFFFFFFSFPro590.copyWith(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),

          // Scrollable content
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle("Content Type"),
                  _buildPillWrap(
                    options: _contentTypes,
                    selectedValue: _selectedContentType,
                    onSelected: (val) =>
                        setState(() => _selectedContentType = val),
                    isGradientSolid: true,
                  ),

                  _buildSectionTitle("Categories"),
                  StreamBuilder<IntrestCategoryModel>(
                    stream: getCategoriesRxObj.getCategoriesData,
                    builder: (context, snapshot) {
                      final categories = snapshot.data?.data ?? [];
                      final options = categories
                          .map((e) => e.name ?? "")
                          .where((e) => e.isNotEmpty)
                          .toList();

                      if (options.isEmpty) {
                        return Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8.w),
                          child: CircularProgressIndicator(
                            color: AppColors.primaryColorSecond,
                          ),
                        );
                      }
                      return _buildPillWrap(
                        options: options,
                        selectedValue: _selectedCategory,
                        onSelected: (val) {
                          setState(() {
                            _selectedCategory = val;
                            _selectedSubCategory = '';
                          });
                          final selectedCat = categories.firstWhere(
                            (e) => e.name == val,
                          );
                          if (selectedCat.id != null) {
                            getSubCategoriesRxObj.fetchSubCategories(
                              selectedCat.id!,
                            );
                          }
                        },
                      );
                    },
                  ),

                  if (_selectedCategory.isNotEmpty) ...[
                    _buildSectionTitle("Sub Categories"),
                    StreamBuilder<IntrestCategoryModel>(
                      stream: getSubCategoriesRxObj.getSubCategoriesData,
                      builder: (context, snapshot) {
                        final subcategories = snapshot.data?.data ?? [];
                        final options = subcategories
                            .map((e) => e.name ?? "")
                            .where((e) => e.isNotEmpty)
                            .toList();

                        if (snapshot.connectionState ==
                                ConnectionState.waiting &&
                            options.isEmpty) {
                          return Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8.w),
                            child: CircularProgressIndicator(
                              color: AppColors.primaryColorSecond,
                            ),
                          );
                        }

                        if (options.isEmpty) {
                          return Text(
                            "No subcategories available",
                            style: TextFontStyle
                                .textStyle14cFFFFFFSFProRounded400
                                .copyWith(
                                  color: Colors.white.withValues(alpha: 0.5),
                                ),
                          );
                        }

                        return _buildPillWrap(
                          options: options,
                          selectedValue: _selectedSubCategory,
                          onSelected: (val) {
                            setState(() {
                              _selectedSubCategory = val;
                            });
                          },
                        );
                      },
                    ),
                  ],

                  if (_selectedContentType == 'Events') ...[
                    _buildSectionTitle("Event Date"),
                    _buildPillWrap(
                      options: _eventDates,
                      selectedValue: _selectedEventDate,
                      onSelected: (val) =>
                          setState(() => _selectedEventDate = val),
                    ),

                    if (_selectedEventDate == 'Custom') ...[
                      UIHelper.verticalSpace(12.h),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          _buildDatePickerField(
                            "From",
                            _fromDate,
                            () => _selectDate(context, isFromDate: true),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 12.w,
                              vertical: 12.h,
                            ),
                            child: Icon(
                              Icons.swap_horiz,
                              color: Colors.white,
                              size: 24.sp,
                            ),
                          ),
                          _buildDatePickerField(
                            "To",
                            _toDate,
                            () => _selectDate(context, isFromDate: false),
                          ),
                        ],
                      ),
                    ],

                    _buildSectionTitle("Price Range"),
                    SliderTheme(
                      data: SliderTheme.of(context).copyWith(
                        activeTrackColor: AppColors.primaryColorSecond,
                        inactiveTrackColor: Colors.white.withValues(alpha: 0.1),
                        trackHeight: 4.h,
                        rangeTrackShape: const GradientRangeSliderTrackShape(),
                        rangeThumbShape: const GradientRangeSliderThumbShape(
                          enabledThumbRadius: 10,
                        ),
                        overlayColor: AppColors.primaryColorSecond.withValues(
                          alpha: 0.12,
                        ),
                      ),
                      child: RangeSlider(
                        values: _priceRange,
                        min: 0,
                        max: 100,
                        onChanged: (values) {
                          setState(() {
                            _priceRange = values;
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
                            "${_priceRange.start.round()} \$",
                            style: TextFontStyle
                                .textStyle14cFFFFFFSFProRounded400
                                .copyWith(
                                  color: Colors.white.withValues(alpha: 0.5),
                                  fontSize: 12.sp,
                                ),
                          ),
                          Text(
                            "${_priceRange.end.round()} \$",
                            style: TextFontStyle
                                .textStyle14cFFFFFFSFProRounded400
                                .copyWith(
                                  color: Colors.white.withValues(alpha: 0.5),
                                  fontSize: 12.sp,
                                ),
                          ),
                        ],
                      ),
                    ),

                    _buildSectionTitle("Distance"),
                    _buildPillWrap(
                      options: _distances,
                      selectedValue: _selectedDistance,
                      onSelected: (val) =>
                          setState(() => _selectedDistance = val),
                    ),

                    _buildSectionTitle("Ticket Availability"),
                    _buildPillWrap(
                      options: _availabilities,
                      selectedValue: _selectedAvailability,
                      onSelected: (val) =>
                          setState(() => _selectedAvailability = val),
                    ),

                    _buildSectionTitle("Rewards Available"),
                    _buildPillWrap(
                      options: _rewardsAvailableOptions,
                      selectedValue: _selectedRewardsAvailable,
                      onSelected: (val) =>
                          setState(() => _selectedRewardsAvailable = val),
                    ),
                  ] else ...[
                    _buildSectionTitle("Company"),
                    _buildPillWrap(
                      options: _companies,
                      selectedValue: _selectedCompany,
                      onSelected: (val) =>
                          setState(() => _selectedCompany = val),
                    ),

                    _buildSectionTitle("Reward Type"),
                    _buildPillWrap(
                      options: _rewardTypes,
                      selectedValue: _selectedRewardType,
                      onSelected: (val) =>
                          setState(() => _selectedRewardType = val),
                    ),

                    _buildSectionTitle("Expiry Date"),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        _buildDatePickerField(
                          "From",
                          _fromDate,
                          () => _selectDate(context, isFromDate: true),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 12.w,
                            vertical: 12.h,
                          ),
                          child: Icon(
                            Icons.swap_horiz,
                            color: Colors.white,
                            size: 24.sp,
                          ),
                        ),
                        _buildDatePickerField(
                          "To",
                          _toDate,
                          () => _selectDate(context, isFromDate: false),
                        ),
                      ],
                    ),

                    _buildSectionTitle("Point Range"),
                    SliderTheme(
                      data: SliderTheme.of(context).copyWith(
                        activeTrackColor: AppColors.primaryColorSecond,
                        inactiveTrackColor: Colors.white.withValues(alpha: 0.1),
                        trackHeight: 4.h,
                        rangeTrackShape: const GradientRangeSliderTrackShape(),
                        rangeThumbShape: const GradientRangeSliderThumbShape(
                          enabledThumbRadius: 10,
                        ),
                        overlayColor: AppColors.primaryColorSecond.withValues(
                          alpha: 0.12,
                        ),
                      ),
                      child: RangeSlider(
                        values: _pointRange,
                        min: 0,
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
                            style: TextFontStyle
                                .textStyle14cFFFFFFSFProRounded400
                                .copyWith(
                                  color: Colors.white.withValues(alpha: 0.5),
                                  fontSize: 12.sp,
                                ),
                          ),
                          Text(
                            "${_pointRange.end.round()} pts",
                            style: TextFontStyle
                                .textStyle14cFFFFFFSFProRounded400
                                .copyWith(
                                  color: Colors.white.withValues(alpha: 0.5),
                                  fontSize: 12.sp,
                                ),
                          ),
                        ],
                      ),
                    ),

                    _buildSectionTitle("Points"),
                    _buildPillWrap(
                      options: _points,
                      selectedValue: _selectedPoint,
                      onSelected: (val) => setState(() => _selectedPoint = val),
                    ),
                  ],
                  UIHelper.verticalSpace(24.h),
                ],
              ),
            ),
          ),

          // Sticky bottom Reset and Apply row
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
                          style: TextFontStyle.textStyle14cFFFFFFSFProRounded400
                              .copyWith(
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
                      String? categoryId;
                      String? subCategoryId;

                      if (_selectedCategory.isNotEmpty) {
                        final categories =
                            getCategoriesRxObj
                                .getCategoriesData
                                .valueOrNull
                                ?.data ??
                            [];
                        try {
                          final cat = categories.firstWhere(
                            (e) => e.name == _selectedCategory,
                          );
                          categoryId = cat.id;
                        } catch (_) {}
                      }

                      if (_selectedSubCategory.isNotEmpty) {
                        final subcategories =
                            getSubCategoriesRxObj
                                .getSubCategoriesData
                                .valueOrNull
                                ?.data ??
                            [];
                        try {
                          final subcat = subcategories.firstWhere(
                            (e) => e.name == _selectedSubCategory,
                          );
                          subCategoryId = subcat.id;
                        } catch (_) {}
                      }

                      if (_selectedContentType == 'Events') {
                        String? apiTicketAvailability;
                        switch (_selectedAvailability) {
                          case 'Available':
                            apiTicketAvailability = 'AVAILABLE';
                            break;
                          case 'Sold Out':
                            apiTicketAvailability = 'SOLD_OUT';
                            break;
                          case 'Few Left':
                            apiTicketAvailability = 'FEW_LEFT';
                            break;
                        }

                        String? getFormattedDateString() {
                          if (_selectedEventDate.isEmpty) return null;
                          final now = DateTime.now();
                          String formatDate(DateTime date) {
                            return "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
                          }

                          if (_selectedEventDate == 'Today') {
                            return formatDate(now);
                          } else if (_selectedEventDate == 'Tomorrow') {
                            return formatDate(now.add(const Duration(days: 1)));
                          } else if (_selectedEventDate == 'This Week') {
                            final int daysToSunday =
                                DateTime.sunday - now.weekday;
                            final endOfWeek = now.add(
                              Duration(
                                days: daysToSunday >= 0 ? daysToSunday : 0,
                              ),
                            );
                            return "${formatDate(now)} to ${formatDate(endOfWeek)}";
                          } else if (_selectedEventDate == 'Custom') {
                            if (_fromDate != null && _toDate != null) {
                              return "${formatDate(_fromDate!)} to ${formatDate(_toDate!)}";
                            } else if (_fromDate != null) {
                              return formatDate(_fromDate!);
                            } else if (_toDate != null) {
                              return formatDate(_toDate!);
                            }
                          }
                          return null;
                        }

                        getEventsByCategoryRxObj.fetchEvents(
                          categoryId: categoryId,
                          subCategoryId: subCategoryId,
                          minPrice: _priceRange.start,
                          maxPrice: _priceRange.end,
                          ticketAvailability: apiTicketAvailability,
                          rewardsAvailable: _selectedRewardsAvailable.isEmpty
                              ? null
                              : _selectedRewardsAvailable == 'Has Rewards',
                          date: getFormattedDateString(),
                        );
                      }

                      Navigator.pop(context);
                    },
                    title: "Apply",
                    height: 48.h,
                    borderRadius: BorderRadius.circular(100.r),
                    textStyle: TextFontStyle.textStyle14cFFFFFFSFProRounded400
                        .copyWith(
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
    final double trackTop =
        offset.dy + (parentBox.size.height - trackHeight) / 2;
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

    // Paint inactive left track
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

    // Paint active track with gradient
    final Paint activePaint = Paint()
      ..shader = const LinearGradient(
        colors: [AppColors.primaryColorFirst, AppColors.primaryColorSecond],
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

    // Paint inactive right track
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

    // Draw white outer circle
    final Paint outerPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, enabledThumbRadius, outerPaint);

    // Draw inner gradient circle
    final Paint innerPaint = Paint()
      ..shader =
          const LinearGradient(
            colors: [AppColors.primaryColorFirst, AppColors.primaryColorSecond],
          ).createShader(
            Rect.fromCircle(center: center, radius: enabledThumbRadius - 2.5.w),
          )
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, enabledThumbRadius - 2.5.w, innerPaint);
  }
}
