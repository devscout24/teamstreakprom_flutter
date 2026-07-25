import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../gen/colors.gen.dart';
import '../../../constants/text_font_style.dart';
import '../../../helpers/ui_helpers.dart';
import '../model/event_model.dart';
import 'event_card.dart';

import '../presentation/popular_events_screen.dart';

class PopularEventsList extends StatelessWidget {
  const PopularEventsList({super.key});

  static const List<EventModel> _popularEvents = [
    EventModel(
      title: "Ella's Creative Showcase",
      location: "Divine Art Festival",
      date: "SEP 21 · 11:00 AM",
      price: "\$50",
      imageUrl:
          "https://images.unsplash.com/photo-1514525253161-7a46d19cd819?auto=format&fit=crop&w=600&q=80",
    ),
    EventModel(
      title: "Ella's Creative Showcase",
      location: "Divine Art Festival",
      date: "SEP 21 · 11:00 AM",
      price: "\$50",
      imageUrl:
          "https://images.unsplash.com/photo-1470225620780-dba8ba36b745?auto=format&fit=crop&w=600&q=80",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Popular Events",
                style: TextFontStyle.textStyle24cFFFFFFSFPro590.copyWith(
                  fontSize: 20.sp,
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
          height: 425.h,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            itemCount: _popularEvents.length,
            itemBuilder: (context, index) {
              final event = _popularEvents[index];
              return Padding(
                padding: EdgeInsets.only(right: 16.w),
                child: EventCard(
                  title: event.title,
                  location: event.location,
                  date: event.date,
                  price: event.price,
                  imageUrl: event.imageUrl,
                  isOverlayStyle: false,
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
