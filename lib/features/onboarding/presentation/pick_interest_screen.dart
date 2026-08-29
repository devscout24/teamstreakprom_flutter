import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../common_widgets/custom_back_button.dart';
import '../../../constants/text_font_style.dart';
import '../../../gen/colors.gen.dart';
import '../../../helpers/ui_helpers.dart';
import '../../../helpers/navigation_service.dart';
import '../../../helpers/all_routes.dart';
import '../../../common_widgets/custom_gradient_button.dart';

import '../../../networks/api_acess.dart';
import '../model/intrest_category_model.dart';

class PickInterestScreen extends StatefulWidget {
  const PickInterestScreen({super.key});

  @override
  State<PickInterestScreen> createState() => _PickInterestScreenState();
}

class _PickInterestScreenState extends State<PickInterestScreen> {
  final Set<String> _selectedCategoryIds = {};

  @override
  void initState() {
    super.initState();
    getCategoriesRxObj.fetchCategories();
  }

  void _toggle(String id) {
    setState(() {
      if (_selectedCategoryIds.contains(id)) {
        _selectedCategoryIds.remove(id);
      } else {
        _selectedCategoryIds.add(id);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldColor,
      body: SafeArea(
        child: SizedBox.expand(
          child: Stack(
            children: [
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Header ──────────────────────────────
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        UIHelper.verticalSpace(16),
                        const CustomBackButton(),
                        UIHelper.verticalSpace(24),
                        Text(
                          'Select the category you like',
                          style: TextFontStyle.textStyle24cFFFFFFSFPro590
                              .copyWith(
                                fontSize: 22.sp,
                                fontWeight: FontWeight.w600,
                                fontFamily: 'SF Pro',
                              ),
                        ),
                        UIHelper.verticalSpace(8),
                        Text(
                          'Choose between 3 interests, and we\'ll curate the\nbest events for you feed.',
                          style: TextFontStyle.textStyle14cFFFFFFSFProRounded400
                              .copyWith(
                                color: AppColors.c9B9C9A,
                                fontFamily: 'SF Pro',
                              ),
                        ),
                        UIHelper.verticalSpace(20),
                      ],
                    ),
                  ),

                  // ── Grid ────────────────────────────────
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: StreamBuilder<IntrestCategoryModel>(
                      stream: getCategoriesRxObj.getCategoriesData,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting && !snapshot.hasData) {
                          return SizedBox(
                            height: 300.h,
                            child: const Center(
                              child: CircularProgressIndicator(
                                color: AppColors.primaryColorFirst,
                              ),
                            ),
                          );
                        }

                        final dataList = snapshot.data?.data ?? [];
                        if (dataList.isEmpty) {
                          return const Center(child: Text('No categories found', style: TextStyle(color: Colors.white)));
                        }

                        return GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 12.w,
                            mainAxisSpacing: 12.h,
                            childAspectRatio: 2.4,
                          ),
                          itemCount: dataList.length,
                          itemBuilder: (context, index) {
                            final category = dataList[index];
                            final categoryId = category.id ?? index.toString();
                            final isSelected = _selectedCategoryIds.contains(categoryId);
                            return _InterestChip(
                              category: category,
                              isSelected: isSelected,
                              onTap: () => _toggle(categoryId),
                            );
                          },
                        );
                      },
                    ),
                  ),

                  UIHelper.verticalSpace(100.h),
                ],
              ),
            ),
            // ── Floating Bottom Buttons ───────────────────────
            if (_selectedCategoryIds.isNotEmpty)
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        AppColors.scaffoldColor.withValues(alpha: 0.0),
                        AppColors.scaffoldColor,
                      ],
                      stops: const [0.0, 0.4],
                    ),
                  ),
                  padding: EdgeInsets.fromLTRB(20.w, 24.h, 20.w, 24.h),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Container(
                          height: 50.h,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(26.r),
                            gradient: const LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                AppColors.primaryColorFirst,
                                AppColors.primaryColorSecond,
                              ],
                            ),
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(1.w),
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                color: AppColors.scaffoldColor,
                                borderRadius: BorderRadius.circular(25.r),
                              ),
                              child: ElevatedButton(
                                onPressed: () {
                                  NavigationService.navigateToReplacement(
                                    Routes.navigationScreen,
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.transparent,
                                  shadowColor: Colors.transparent,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(25.r),
                                  ),
                                  padding: EdgeInsets.zero,
                                ),
                                child: ShaderMask(
                                  shaderCallback: (bounds) =>
                                      const LinearGradient(
                                        colors: [
                                          AppColors.primaryColorFirst,
                                          AppColors.primaryColorSecond,
                                        ],
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                      ).createShader(bounds),
                                  child: Text(
                                    'Skip',
                                    style: TextFontStyle
                                        .textStyle16c000000SFPro590
                                        .copyWith(
                                          color: Colors.white,
                                          fontFamily: 'SF Pro',
                                          fontWeight: FontWeight.w600,
                                          fontSize: 16.sp,
                                        ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      UIHelper.horizontalSpace(12.w),
                      // Save button
                      Expanded(
                        flex: 2,
                        child: CustomGradientButton(
                          height: 50.h,
                          onPressed: () {
                            NavigationService.navigateToReplacement(
                              Routes.navigationScreen,
                            );
                          },
                          title: 'Save',
                          textStyle: TextFontStyle.textStyle16c000000SFPro590
                              .copyWith(
                                color: AppColors.c262824,
                                fontFamily: 'SF Pro',
                                fontWeight: FontWeight.w700,
                                fontSize: 16.sp,
                              ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InterestChip extends StatelessWidget {
  final Datum category;
  final bool isSelected;
  final VoidCallback onTap;

  const _InterestChip({
    required this.category,
    required this.isSelected,
    required this.onTap,
  });

  String _getIconForCategory(String name) {
    final lowerName = name.toLowerCase();
    if (lowerName.contains('music')) return 'assets/icons/music_icon.png';
    if (lowerName.contains('art')) return 'assets/icons/visual_arts_icon.png';
    if (lowerName.contains('book')) return 'assets/icons/book_icon.png';
    if (lowerName.contains('business')) return 'assets/icons/business_icon.png';
    if (lowerName.contains('holiday')) return 'assets/icons/holiday_icon.png';
    if (lowerName.contains('health')) return 'assets/icons/health_icon.png';
    if (lowerName.contains('food')) return 'assets/icons/food_icon.png';
    if (lowerName.contains('sport')) return 'assets/icons/sports_icon.png';
    if (lowerName.contains('gam')) return 'assets/icons/gaming_icon.png';
    if (lowerName.contains('coffee')) return 'assets/icons/coffee_icon.png';
    if (lowerName.contains('community')) return 'assets/icons/community_icon.png';
    if (lowerName.contains('film')) return 'assets/icons/films_icon.png';
    if (lowerName.contains('fit')) return 'assets/icons/fitness_icon.png';
    if (lowerName.contains('travel')) return 'assets/icons/travel_icon.png';
    return 'assets/icons/community_icon.png'; // fallback
  }

  static const _gradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [AppColors.primaryColorFirst, AppColors.primaryColorSecond],
  );

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        decoration: isSelected
            ? BoxDecoration(
                gradient: _gradient,
                borderRadius: BorderRadius.circular(14.r),
              )
            : BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(14.r),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.08),
                  width: 1.w,
                ),
              ),
        padding: isSelected ? EdgeInsets.all(1.5.w) : EdgeInsets.zero,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF1E222B) : Colors.transparent,
            borderRadius: BorderRadius.circular(isSelected ? 13.r : 14.r),
          ),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInOut,
            decoration: BoxDecoration(
              gradient: isSelected
                  ? LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        const Color(0xFFF28F31).withValues(alpha: 0.10),
                        const Color(0xFF72E84F).withValues(alpha: 0.10),
                      ],
                    )
                  : null,
              borderRadius: BorderRadius.circular(isSelected ? 13.r : 14.r),
            ),
            padding: EdgeInsets.symmetric(horizontal: 14.w),
            child: isSelected
                ? ShaderMask(
                    shaderCallback: (bounds) => _gradient.createShader(bounds),
                    blendMode: BlendMode.srcIn,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Image.asset(
                          _getIconForCategory(category.name ?? ''),
                          width: 20.sp,
                          height: 20.sp,
                          color: Colors.white,
                        ),
                        UIHelper.horizontalSpace(8.w),
                        Flexible(
                          child: Text(
                            category.name ?? 'Unknown',
                            overflow: TextOverflow.ellipsis,
                            style: TextFontStyle
                                .textStyle14cFFFFFFSFProRounded400
                                .copyWith(
                                  color: Colors.white,
                                  fontFamily: 'SF Pro',
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14.sp,
                                ),
                          ),
                        ),
                      ],
                    ),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Image.asset(
                        _getIconForCategory(category.name ?? ''),
                        width: 20.sp,
                        height: 20.sp,
                        color: AppColors.c9B9C9A,
                      ),
                      UIHelper.horizontalSpace(8.w),
                      Flexible(
                        child: Text(
                          category.name ?? 'Unknown',
                          overflow: TextOverflow.ellipsis,
                          style: TextFontStyle.textStyle14cFFFFFFSFProRounded400
                              .copyWith(
                                color: AppColors.c9B9C9A,
                                fontFamily: 'SF Pro',
                                fontWeight: FontWeight.w400,
                                fontSize: 14.sp,
                              ),
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
