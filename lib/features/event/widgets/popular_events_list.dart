import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../gen/colors.gen.dart';
import '../../../constants/text_font_style.dart';
import '../../../helpers/ui_helpers.dart';
import 'event_card.dart';

import '../presentation/popular_events_screen.dart';
import '../../../networks/api_acess.dart';
import '../../home/model/event_fetch_by_category_model.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:intl/intl.dart';

class PopularEventsList extends StatefulWidget {
  const PopularEventsList({super.key});

  @override
  State<PopularEventsList> createState() => _PopularEventsListState();
}

class _PopularEventsListState extends State<PopularEventsList> {
  bool _isLoadingMore = false;

  Future<void> _loadMore() async {
    final meta = getEventsByCategoryRxObj.getEventsData.valueOrNull?.meta;
    if (meta != null) {
      int currentPage = meta.page ?? 1;
      int totalPages = meta.totalPage ?? 1;

      if (currentPage < totalPages) {
        setState(() {
          _isLoadingMore = true;
        });

        await getEventsByCategoryRxObj.fetchEvents(page: currentPage + 1);

        if (mounted) {
          setState(() {
            _isLoadingMore = false;
          });
        }
      }
    }
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
                "Popular Events",
                style: TextFontStyle.textStyle24cFFFFFFSFPro590.copyWith(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const PopularEventsScreen(),
                    ),
                  );
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
          height: 500.h,
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
                  child: Text(
                    "No events found.",
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.6),
                    ),
                  ),
                );
              }

              return CarouselSlider.builder(
                itemCount: eventsList.length,
                options: CarouselOptions(
                  height: 500.h,
                  viewportFraction: 0.76,
                  enlargeCenterPage: true,
                  enlargeFactor: 0.2,
                  enlargeStrategy: CenterPageEnlargeStrategy.zoom,
                  enableInfiniteScroll: false,
                  autoPlay: false,
                  padEnds: true,
                  onPageChanged: (index, reason) {
                    if (index >= eventsList.length - 2 && !_isLoadingMore) {
                      _loadMore();
                    }
                  },
                ),
                itemBuilder: (context, index, realIndex) {
                  final event = eventsList[index];
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
                    padding: EdgeInsets.symmetric(horizontal: 6.w),
                    child: EventCard(
                      width: double.infinity,
                      title: event.title ?? 'No Title',
                      location: event.placeName ?? 'No Location',
                      date: formattedDate,
                      price: event.ticketPrice != null
                          ? "\$${event.ticketPrice!.toStringAsFixed(0)}"
                          : "Free",
                      imageUrl: imgUrl,
                      isOverlayStyle: false,
                      eventId: event.id,
                      onBuyPressed: () {},
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
