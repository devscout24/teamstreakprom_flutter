import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import '../../../../gen/colors.gen.dart';
import '../../../../constants/text_font_style.dart';
import '../../../../helpers/ui_helpers.dart';
import '../../event/widgets/event_card.dart';
import '../../home/data/rx_get_events/api.dart';
import '../../home/model/event_fetch_by_category_model.dart';
import 'package:shimmer/shimmer.dart';

class CategoryEventsRow extends StatefulWidget {
  final String categoryId;
  final String categoryName;
  final String? seed;

  const CategoryEventsRow({
    super.key,
    required this.categoryId,
    required this.categoryName,
    this.seed,
  });

  @override
  State<CategoryEventsRow> createState() => _CategoryEventsRowState();
}

class _CategoryEventsRowState extends State<CategoryEventsRow> {
  final ScrollController _scrollController = ScrollController();
  final List<Datum> _events = [];
  bool _isLoading = false;
  bool _hasMore = true;
  int _currentPage = 1;

  @override
  void initState() {
    super.initState();
    _fetchEvents();
    _scrollController.addListener(_onScroll);
  }

  @override
  void didUpdateWidget(covariant CategoryEventsRow oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.seed != widget.seed ||
        oldWidget.categoryId != widget.categoryId) {
      _currentPage = 1;
      _events.clear();
      _hasMore = true;
      _fetchEvents();
    }
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 100 &&
        !_isLoading &&
        _hasMore) {
      _fetchEvents();
    }
  }

  Future<void> _fetchEvents() async {
    if (_isLoading || !_hasMore) return;
    setState(() {
      _isLoading = true;
    });

    try {
      final response = await GetEventsByCategoryApi.instance.getEvents(
        page: _currentPage,
        limit: 10,
        categoryId: widget.categoryId,
        seed: widget.seed,
      );

      setState(() {
        final newEvents = response.data ?? [];
        if (newEvents.isEmpty) {
          _hasMore = false;
        } else {
          _events.addAll(newEvents);
          _currentPage++;
        }
      });
    } catch (e) {
      debugPrint(
        "Failed to fetch events for category ${widget.categoryId}: $e",
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.categoryName,
                style: TextFontStyle.textStyle24cFFFFFFSFPro590.copyWith(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              GestureDetector(
                onTap: () {
                  // Navigate to see all events for this category
                },
                child: Text(
                  "See All",
                  style: TextFontStyle.textStyle14cFFFFFFSFProRounded400
                      .copyWith(
                        color: AppColors.cFFFFFF,
                        fontWeight: FontWeight.w500,
                        fontSize: 12.sp,
                        decoration: TextDecoration.underline,
                        decorationColor: AppColors.cFFFFFF,
                      ),
                ),
              ),
            ],
          ),
        ),
        UIHelper.verticalSpace(16.h),
        SizedBox(
          height: _events.isEmpty && !_isLoading ? 100.h : 425.h,
          child: _events.isEmpty && _isLoading
              ? const Center(
                  child: CircularProgressIndicator(
                    color: AppColors.primaryColorFirst,
                  ),
                )
              : _events.isEmpty
                  ? Center(
                      child: Text(
                        "No events available.",
                        style: TextFontStyle.textStyle14cFFFFFFSFProRounded400.copyWith(
                          color: Colors.white.withValues(alpha: 0.5),
                        ),
                      ),
                    )
                  : ListView.builder(
                  controller: _scrollController,
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.symmetric(horizontal: 12.w),
                  itemCount: _events.length + (_isLoading ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index >= _events.length) {
                      return Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.w),
                        child: const Center(child: CircularProgressIndicator()),
                      );
                    }

                    final event = _events[index];
                    String formattedDate = '';
                    if (event.startDate != null) {
                      formattedDate = DateFormat(
                        'MMM d · h:mm a',
                      ).format(event.startDate!).toUpperCase();
                    }

                    String imgUrl =
                        "https://images.unsplash.com/photo-1514525253161-7a46d19cd819?auto=format&fit=crop&w=600&q=80"; // fallback
                    if (event.images != null && event.images!.isNotEmpty) {
                      imgUrl = event.images!.first;
                    }

                    return Padding(
                      padding: EdgeInsets.only(right: 16.w),
                      child: EventCard(
                        title: event.title ?? 'No Title',
                        location: event.placeName ?? 'No Location',
                        date: formattedDate,
                        price: event.ticketPrice != null
                            ? "\$${event.ticketPrice!.toStringAsFixed(2).replaceAll(RegExp(r'\.00$'), '')}"
                            : "Free",
                        imageUrl: imgUrl,
                        isOverlayStyle: false,
                        eventId: event.id,
                        onBuyPressed: () {},
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }

}
