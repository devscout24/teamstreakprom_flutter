import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../gen/colors.gen.dart';
import '../../../constants/text_font_style.dart';
import '../../../helpers/ui_helpers.dart';
import '../../../common_widgets/custom_back_button.dart';
import '../../../common_widgets/custom_app_bar.dart';
import '../../home/widgets/filter_bottom_sheet.dart';
import '../widgets/event_card.dart';
import '../model/event_model.dart';

class JazzEventsScreen extends StatefulWidget {
  const JazzEventsScreen({super.key});

  @override
  State<JazzEventsScreen> createState() => _JazzEventsScreenState();
}

class _JazzEventsScreenState extends State<JazzEventsScreen> {
  int _selectedCategoryIndex = 0;

  static const List<String> _categories = [
    'All',
    'Music',
    'Nightlife',
    'Festival',
    'Sports',
  ];

  static const List<EventModel> _jazzEvents = [
    EventModel(
      title: "Lois Photographic Event",
      location: "Kamisama Art Club",
      date: "Sep 21 - 11:00 AM",
      price: "\$.30",
      imageUrl:
          "https://images.unsplash.com/photo-1511192336575-5a79af67a629?auto=format&fit=crop&w=600&q=80",
    ),
    EventModel(
      title: "Ella's Creative Showcase",
      location: "Divine Art Festival",
      date: "Sep 21 · 11:00 AM",
      price: "\$.50",
      imageUrl:
          "https://images.unsplash.com/photo-1514525253161-7a46d19cd819?auto=format&fit=crop&w=600&q=80",
    ),
    EventModel(
      title: "Sunset Jazz & Blues",
      location: "The Blue Note Club",
      date: "OCT 12 · 08:00 PM",
      price: "\$45",
      imageUrl:
          "https://images.unsplash.com/photo-1486591978090-58e619d37fe7?auto=format&fit=crop&w=600&q=80",
    ),
  ];

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
      backgroundColor: AppColors.c121212,
      appBar: const CustomAppBar(title: "Jazz Events", showRightIcon: false),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          UIHelper.verticalSpace(12.h),

          // Search Bar
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
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

          // Categories list
          SizedBox(
            height: 38.h,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 24.w),
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
                          style: TextFontStyle.textStyle14cFFFFFFSFProRounded400
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

          // List screen
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              itemCount: _jazzEvents.length,
              itemBuilder: (context, index) {
                final event = _jazzEvents[index];
                return Padding(
                  padding: EdgeInsets.only(bottom: 20.h),
                  child: EventCard(
                    title: event.title,
                    location: event.location,
                    date: event.date,
                    price: event.price,
                    imageUrl: event.imageUrl,
                    isOverlayStyle: false,
                    width: double.infinity,
                    onBuyPressed: () {},
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
