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
import '../../../helpers/all_routes.dart';
import '../../../helpers/navigation_service.dart';
import '../../../gen/assets.gen.dart';
import '../../../common_widgets/app_network_image.dart';

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

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.fromLTRB(24.w, 16.h, 24.w, 12.h),
      color: AppColors.c121212,
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              NavigationService.navigateTo(Routes.editProfileScreen);
            },
            child: Container(
              width: 44.w,
              height: 44.w,
              decoration: const BoxDecoration(shape: BoxShape.circle),
              child: const AppNetworkImage(
                imageUrl:
                    "https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?auto=format&fit=crop&w=200&q=80",
                borderRadius: BorderRadius.all(Radius.circular(100)),
              ),
            ),
          ),
          UIHelper.horizontalSpace(12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                GestureDetector(
                  onTap: () {
                    NavigationService.navigateTo(Routes.editProfileScreen);
                  },
                  child: Text(
                    "Wilson Culhane",
                    style: TextFontStyle.textStyle16cFFFFFFSFPro590,
                  ),
                ),
                UIHelper.verticalSpace(4.h),
                Row(
                  children: [
                    Icon(
                      Icons.location_on_rounded,
                      size: 16.sp,
                      color: AppColors.primaryColorSecond,
                    ),
                    UIHelper.horizontalSpace(4.w),
                    Flexible(
                      child: Text(
                        "Divine Art Festival",
                        overflow: TextOverflow.ellipsis,
                        style: TextFontStyle.textStyle14cFFFFFFSFPro590
                            .copyWith(
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w400,
                              color: Colors.white.withValues(alpha: 0.6),
                            ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          UIHelper.horizontalSpace(12.w),
          GestureDetector(
            onTap: () {
              NavigationService.navigateTo(Routes.rewardsPointDetailsScreen);
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
              decoration: BoxDecoration(
                color: const Color(0xFF1E222B),
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ShaderMask(
                    shaderCallback: (bounds) => const LinearGradient(
                      colors: [
                        AppColors.primaryColorFirst,
                        AppColors.primaryColorSecond,
                      ],
                    ).createShader(bounds),
                    blendMode: BlendMode.srcIn,
                    child: Image.asset(
                      Assets.icons.pointIcon.path,
                      width: 18.w,
                      height: 18.w,
                      color: Colors.white,
                    ),
                  ),
                  UIHelper.horizontalSpace(6.w),
                  RichText(
                    text: TextSpan(
                      text: "95 ",
                      style: TextFontStyle.textStyle14cFFFFFFSFPro590.copyWith(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primaryColorSecond,
                      ),
                      children: [
                        TextSpan(
                          text: "pts",
                          style: TextFontStyle.textStyle14cFFFFFFSFPro590
                              .copyWith(
                                fontSize: 11.sp,
                                fontWeight: FontWeight.w400,
                                color: AppColors.primaryColorSecond.withValues(
                                  alpha: 0.8,
                                ),
                              ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          UIHelper.horizontalSpace(12.w),
          GestureDetector(
            onTap: () {
              NavigationService.navigateTo(Routes.notificationScreen);
            },
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Image.asset(
                  Assets.icons.notificationIcon.path,
                  width: 24.w,
                  height: 24.w,
                  color: Colors.white,
                ),
                Positioned(
                  top: -2.h,
                  right: -2.w,
                  child: Container(
                    padding: EdgeInsets.all(4.w),
                    decoration: const BoxDecoration(
                      color: Color(0xFFF28F31),
                      shape: BoxShape.circle,
                    ),
                    constraints: BoxConstraints(
                      minWidth: 14.w,
                      minHeight: 14.w,
                    ),
                    child: Center(
                      child: Text(
                        "3",
                        style: TextFontStyle.textStyle14cFFFFFFSFPro590
                            .copyWith(
                              fontSize: 8.sp,
                              fontWeight: FontWeight.w700,
                            ),
                      ),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.c121212,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              UIHelper.verticalSpace(16.h),
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
              const RewardsMarketplaceList(),
            ],
          ),
        ),
      ),
    );
  }
}
