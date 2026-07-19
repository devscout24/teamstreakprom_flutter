import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../gen/colors.gen.dart';
import '../../../constants/text_font_style.dart';
import '../../../helpers/ui_helpers.dart';
import '../../event/widgets/popular_events_list.dart';
import '../../event/widgets/jazz_events_list.dart';
import '../../event/widgets/rock_events_list.dart';
import '../widgets/rewards_marketplace_list.dart';
import '../widgets/filter_bottom_sheet.dart';

const List<String> _categories = [
  'All',
  'Music',
  'Nightlife',
  'Festival',
  'Sports',
];

class HomeScreen extends StatefulWidget {
  final VoidCallback? onNavigateToRewards;
  const HomeScreen({super.key, this.onNavigateToRewards});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedCategoryIndex = 0;

  void _showFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const FilterBottomSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldColor,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 16.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Search & Filter Row ──────────────────
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Container(
                  height: 52.h,
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E222B),
                    borderRadius: BorderRadius.circular(100.r),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.05),
                      width: 1.w,
                    ),
                  ),
                  padding: EdgeInsets.only(left: 16.w, right: 6.w),
                  child: Row(
                    children: [
                      Icon(
                        Icons.search,
                        color: Colors.white.withValues(alpha: 0.5),
                        size: 24.sp,
                      ),
                      UIHelper.horizontalSpace(12.w),
                      Expanded(
                        child: TextField(
                          style: TextFontStyle.textStyle14cFFFFFFSFProRounded400
                              .copyWith(color: Colors.white),
                          decoration: InputDecoration(
                            hintText: "Search...",
                            hintStyle: TextFontStyle
                                .textStyle14cFFFFFFSFProRounded400
                                .copyWith(
                                  color: Colors.white.withValues(alpha: 0.4),
                                ),
                            border: InputBorder.none,
                            isDense: true,
                            contentPadding: EdgeInsets.zero,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: _showFilterBottomSheet,
                        child: Container(
                          width: 40.h,
                          height: 40.h,
                          decoration: const BoxDecoration(
                            color: Color(0xFF232D26),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.tune_rounded,
                            color: Colors.white,
                            size: 18.sp,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              UIHelper.verticalSpace(24.h),

              // ── Categories Horizontal List ──────────
              SizedBox(
                height: 38.h,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  itemCount: _categories.length,
                  itemBuilder: (context, index) {
                    final isSelected = _selectedCategoryIndex == index;
                    return Padding(
                      padding: EdgeInsets.only(right: 8.w),
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedCategoryIndex = index;
                          });
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 20.w),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppColors.cA8FF8E
                                : const Color(0xFF1E222B),
                            borderRadius: BorderRadius.circular(100.r),
                            border: Border.all(
                              color: isSelected
                                  ? Colors.transparent
                                  : Colors.white.withValues(alpha: 0.05),
                              width: 1.w,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              _categories[index],
                              style: TextFontStyle
                                  .textStyle14cFFFFFFSFProRounded400
                                  .copyWith(
                                    color: isSelected
                                        ? Colors.black
                                        : Colors.white.withValues(alpha: 0.7),
                                    fontWeight: isSelected
                                        ? FontWeight.w600
                                        : FontWeight.w400,
                                  ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              UIHelper.verticalSpace(24.h),

              // ── Popular Events List ─────────────────
              const PopularEventsList(),
              UIHelper.verticalSpace(24.h),

              // ── Jazz Events List ────────────────────
              const JazzEventsList(),
              UIHelper.verticalSpace(24.h),

              // ── Rock and Roll Events List ───────────
              const RockEventsList(),
              UIHelper.verticalSpace(24.h),
              RewardsMarketplaceList(onSeeAllTapped: widget.onNavigateToRewards),
            ],
          ),
        ),
      ),
    );
  }
}
