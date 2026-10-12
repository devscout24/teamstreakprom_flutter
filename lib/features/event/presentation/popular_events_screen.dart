import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import '../../../gen/colors.gen.dart';
import '../../../constants/text_font_style.dart';
import '../../../helpers/ui_helpers.dart';
import '../../../common_widgets/custom_app_bar.dart';
import '../../home/widgets/filter_bottom_sheet.dart';
import '../widgets/event_card.dart';
import '../../home/model/event_fetch_by_category_model.dart';
import '../../../networks/api_acess.dart';
import '../../onboarding/model/intrest_category_model.dart';

class PopularEventsScreen extends StatefulWidget {
  final String? categoryId;
  final String? categoryName;

  const PopularEventsScreen({
    super.key,
    this.categoryId,
    this.categoryName,
  });

  @override
  State<PopularEventsScreen> createState() => _PopularEventsScreenState();
}

class _PopularEventsScreenState extends State<PopularEventsScreen> {
  String? _selectedCategoryId;
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  Timer? _debounceTimer;
  bool _isLoadingMore = false;

  @override
  void initState() {
    super.initState();
    _selectedCategoryId = widget.categoryId;

    // Fetch categories if not yet fetched
    if (getCategoriesRxObj.getCategoriesData.valueOrNull?.data == null ||
        getCategoriesRxObj.getCategoriesData.valueOrNull!.data!.isEmpty) {
      getCategoriesRxObj.fetchCategories();
    }

    _scrollController.addListener(_onScroll);

    // Initial event fetch
    getEventsByCategoryRxObj.fetchEvents(
      page: 1,
      categoryId: _selectedCategoryId,
    );
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      final meta = getEventsByCategoryRxObj.getEventsData.valueOrNull?.meta;
      final currentPage = meta?.page ?? 1;
      final totalPage = meta?.totalPage ?? 1;
      if (!_isLoadingMore && currentPage < totalPage) {
        _loadMore(currentPage + 1);
      }
    }
  }

  Future<void> _loadMore(int nextPage) async {
    setState(() => _isLoadingMore = true);
    await getEventsByCategoryRxObj.fetchEvents(page: nextPage);
    if (mounted) {
      setState(() => _isLoadingMore = false);
    }
  }

  void _onSearchChanged(String query) {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 400), () {
      getEventsByCategoryRxObj.fetchEvents(
        page: 1,
        search: query.trim().isNotEmpty ? query.trim() : null,
        categoryId: _selectedCategoryId != null &&
                _selectedCategoryId!.isNotEmpty &&
                _selectedCategoryId != "All"
            ? _selectedCategoryId
            : null,
      );
    });
  }

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
      appBar: CustomAppBar(
        title: widget.categoryName ?? "Popular Events",
        showRightIcon: false,
      ),
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
                      controller: _searchController,
                      onChanged: _onSearchChanged,
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
                  if (_searchController.text.isNotEmpty)
                    GestureDetector(
                      onTap: () {
                        _searchController.clear();
                        getEventsByCategoryRxObj.fetchEvents(
                          page: 1,
                          categoryId: _selectedCategoryId,
                        );
                      },
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8.w),
                        child: Icon(
                          Icons.close,
                          color: Colors.white.withValues(alpha: 0.5),
                          size: 18.sp,
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
          UIHelper.verticalSpace(20.h),

          // Dynamic Categories list from API
          StreamBuilder<IntrestCategoryModel>(
            stream: getCategoriesRxObj.getCategoriesData,
            builder: (context, snapshot) {
              final categories = snapshot.data?.data ?? [];

              return SizedBox(
                height: 38.h,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.symmetric(horizontal: 24.w),
                  itemCount: categories.length + 1,
                  itemBuilder: (context, index) {
                    final isAll = index == 0;
                    final category = isAll ? null : categories[index - 1];
                    final categoryId = isAll ? null : category?.id;
                    final categoryName = isAll ? 'All' : (category?.name ?? '');

                    final isSelected = isAll
                        ? (_selectedCategoryId == null ||
                            _selectedCategoryId == '' ||
                            _selectedCategoryId == 'All')
                        : (_selectedCategoryId == categoryId);

                    return Padding(
                      padding: EdgeInsets.only(right: 8.w),
                      child: GestureDetector(
                        onTap: () {
                          if (_selectedCategoryId != categoryId) {
                            setState(() {
                              _selectedCategoryId = categoryId;
                            });
                            getEventsByCategoryRxObj.fetchEvents(
                              page: 1,
                              categoryId: _selectedCategoryId,
                              search: _searchController.text.trim().isNotEmpty
                                  ? _searchController.text.trim()
                                  : null,
                            );
                          }
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
                              categoryName,
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
              );
            },
          ),
          UIHelper.verticalSpace(20.h),

          // Vertical Events List
          Expanded(
            child: StreamBuilder<EventFetchByCategoryModel>(
              stream: getEventsByCategoryRxObj.getEventsData,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting &&
                    !snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: AppColors.primaryColorFirst,
                    ),
                  );
                }

                final eventsList = snapshot.data?.data ?? [];

                if (eventsList.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.event_busy_outlined,
                          size: 64.sp,
                          color: Colors.white.withValues(alpha: 0.3),
                        ),
                        UIHelper.verticalSpace(16.h),
                        Text(
                          "No events found",
                          style: TextFontStyle.textStyle14cFFFFFFSFProRounded400
                              .copyWith(
                                color: Colors.white.withValues(alpha: 0.6),
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w500,
                              ),
                        ),
                      ],
                    ),
                  );
                }

                return RefreshIndicator(
                  color: AppColors.primaryColorFirst,
                  onRefresh: () async {
                    await getEventsByCategoryRxObj.fetchEvents(
                      page: 1,
                      categoryId: _selectedCategoryId,
                      search: _searchController.text.trim().isNotEmpty
                          ? _searchController.text.trim()
                          : null,
                    );
                  },
                  child: ListView.builder(
                    controller: _scrollController,
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: EdgeInsets.symmetric(horizontal: 24.w),
                    itemCount: eventsList.length + (_isLoadingMore ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index == eventsList.length) {
                        return Padding(
                          padding: EdgeInsets.symmetric(vertical: 16.h),
                          child: const Center(
                            child: CircularProgressIndicator(
                              color: AppColors.primaryColorFirst,
                            ),
                          ),
                        );
                      }

                      final event = eventsList[index];
                      String formattedDate = '';
                      if (event.startDate != null) {
                        formattedDate = DateFormat(
                          'MMM d · h:mm a',
                        ).format(event.startDate!).toUpperCase();
                      }

                      String imgUrl =
                          "https://images.unsplash.com/photo-1514525253161-7a46d19cd819?auto=format&fit=crop&w=600&q=80";
                      if (event.images != null && event.images!.isNotEmpty) {
                        imgUrl = event.images!.first;
                      }

                      return Padding(
                        padding: EdgeInsets.only(bottom: 20.h),
                        child: EventCard(
                          title: event.title ?? 'No Title',
                          location: event.placeName ?? 'No Location',
                          date: formattedDate,
                          price: event.ticketPrice != null
                              ? "\$${event.ticketPrice!.toStringAsFixed(0)}"
                              : "Free",
                          imageUrl: imgUrl,
                          imageHeight: 200.h,
                          isOverlayStyle: false,
                          width: double.infinity,
                          eventId: event.id,
                          onBuyPressed: () {},
                        ),
                      );
                    },
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
