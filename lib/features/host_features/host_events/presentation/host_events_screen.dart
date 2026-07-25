import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:teamstreakpromo/gen/colors.gen.dart';
import 'package:teamstreakpromo/helpers/ui_helpers.dart';
import '../widget/host_events_header.dart';
import '../widget/host_events_tab_bar.dart';
import '../widget/host_event_list_card.dart';
import 'package:teamstreakpromo/features/event/presentation/event_details_screen.dart';
import 'package:teamstreakpromo/helpers/all_routes.dart';

class HostEventsScreen extends StatefulWidget {
  final VoidCallback onBack;

  const HostEventsScreen({super.key, required this.onBack});

  @override
  State<HostEventsScreen> createState() => _HostEventsScreenState();
}

class _HostEventsScreenState extends State<HostEventsScreen> {
  String _activeTab = "Upcoming";

  final List<Map<String, dynamic>> _upcomingEvents = [
    {
      "imageUrl":
          "https://images.unsplash.com/photo-1506157786151-b8491531f063?q=80&w=300&auto=format&fit=crop",
      "title": "Gala Galactica: New Year's",
      "location": "Sydney, Australia",
      "date": "23 Oct, 2024 • 2pm",
      "price": "\$ 50",
      "ticketsSold": 30,
      "capacity": 200,
    },
    {
      "imageUrl":
          "https://images.unsplash.com/photo-1516450360452-9312f5e86fc7?q=80&w=300&auto=format&fit=crop",
      "title": "Ella's Creative Showcase",
      "location": "Divine Art Festival",
      "date": "23 Oct, 2024 • 2pm",
      "price": "\$ 90",
      "ticketsSold": 30,
      "capacity": 200,
    },
  ];

  final List<Map<String, dynamic>> _pastEvents = [
    {
      "imageUrl":
          "https://images.unsplash.com/photo-1470225620780-dba8ba36b745?q=80&w=300&auto=format&fit=crop",
      "title": "Retro Beats Rock Concert",
      "location": "Stadium Central, UK",
      "date": "10 Aug, 2024 • 8pm",
      "price": "\$ 40",
      "ticketsSold": 150,
      "capacity": 150,
    },
  ];

  final List<Map<String, dynamic>> _cancelledEvents = [
    {
      "imageUrl":
          "https://images.unsplash.com/photo-1459749411175-04bf5292ceea?q=80&w=300&auto=format&fit=crop",
      "title": "Acoustic Forest Live Sessions",
      "location": "Whispering Pines Forest",
      "date": "15 Sep, 2024 • 4pm",
      "price": "\$ 25",
      "ticketsSold": 0,
      "capacity": 80,
    },
  ];

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> activeList;
    if (_activeTab == "Past") {
      activeList = _pastEvents;
    } else if (_activeTab == "Cancel") {
      activeList = _cancelledEvents;
    } else {
      activeList = _upcomingEvents;
    }

    return Scaffold(
      backgroundColor: AppColors.scaffoldColor,
      body: SafeArea(
        child: Column(
          children: [
            UIHelper.verticalSpace(20),
            // Header Row (back button goes back to Dashboard index 0)
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: HostEventsHeader(
                onBack: widget.onBack,
                onCreateEvent: () {
                  Navigator.pushNamed(context, Routes.createEventScreen);
                },
              ),
            ),
            UIHelper.verticalSpace(24),

            // Toggle Bar (Upcoming / Past / Cancel)
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: HostEventsTabBar(
                activeTab: _activeTab,
                onTabSelected: (tab) {
                  setState(() {
                    _activeTab = tab;
                  });
                },
              ),
            ),
            UIHelper.verticalSpace(20),

            // Scrollable Event Cards List
            Expanded(
              child: activeList.isEmpty
                  ? Center(
                      child: Text(
                        "No ${_activeTab.toLowerCase()} events found",
                        style: TextStyle(
                          fontFamily: "SF Pro",
                          fontSize: 14.sp,
                          color: Colors.white.withValues(alpha: 0.4),
                        ),
                      ),
                    )
                  : ListView.separated(
                      padding: EdgeInsets.symmetric(
                        horizontal: 24.w,
                        vertical: 4.h,
                      ),
                      itemCount: activeList.length,
                      separatorBuilder: (context, index) =>
                          UIHelper.verticalSpace(20),
                      itemBuilder: (context, index) {
                        final event = activeList[index];
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => EventDetailsScreen(
                                  title: event["title"]!,
                                  location: event["location"]!,
                                  date: event["date"]!,
                                  price: event["price"]!,
                                  imageUrl: event["imageUrl"]!,
                                  description:
                                      "Join us for an unforgettable experience at ${event['title']}. A spectacular event not to be missed!",
                                ),
                              ),
                            );
                          },
                          child: HostEventListCard(
                            imageUrl: event["imageUrl"]!,
                            title: event["title"]!,
                            location: event["location"]!,
                            date: event["date"]!,
                            price: event["price"]!,
                            ticketsSold: event["ticketsSold"]!,
                            capacity: event["capacity"]!,
                            onDelete: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    "Delete event: ${event['title']}",
                                  ),
                                  behavior: SnackBarBehavior.floating,
                                ),
                              );
                            },
                            onEdit: () {
                              Navigator.pushNamed(context, Routes.createEventScreen);
                            },
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
