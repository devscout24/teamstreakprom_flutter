import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:teamstreakpromo/gen/colors.gen.dart';
import 'package:teamstreakpromo/helpers/ui_helpers.dart';
import 'package:teamstreakpromo/common_widgets/custom_app_bar.dart';
import '../widget/host_event_card.dart';

class AllEventsScreen extends StatelessWidget {
  const AllEventsScreen({super.key});

  final List<Map<String, String>> _mockEvents = const [
    {
      "imageUrl": "https://images.unsplash.com/photo-1506157786151-b8491531f063?q=80&w=300&auto=format&fit=crop",
      "title": "SoundWave Music Festival",
      "location": "Divine Art Festival",
      "revenue": "\$7,420 revenue",
      "going": "220 going"
    },
    {
      "imageUrl": "https://images.unsplash.com/photo-1470225620780-dba8ba36b745?q=80&w=300&auto=format&fit=crop",
      "title": "Neon Beat Rave Night",
      "location": "Central Techno Arena",
      "revenue": "\$12,150 revenue",
      "going": "540 going"
    },
    {
      "imageUrl": "https://images.unsplash.com/photo-1516450360452-9312f5e86fc7?q=80&w=300&auto=format&fit=crop",
      "title": "Acoustic Sunset Session",
      "location": "Golden Bay Resort",
      "revenue": "\$3,800 revenue",
      "going": "150 going"
    },
    {
      "imageUrl": "https://images.unsplash.com/photo-1459749411175-04bf5292ceea?q=80&w=300&auto=format&fit=crop",
      "title": "Rock & Riot Open Air",
      "location": "Thunder Mountain Arena",
      "revenue": "\$18,400 revenue",
      "going": "850 going"
    },
    {
      "imageUrl": "https://images.unsplash.com/photo-1514525253161-7a46d19cd819?q=80&w=300&auto=format&fit=crop",
      "title": "Jazz & Wine Chillout",
      "location": "Green Valley Vineyards",
      "revenue": "\$5,200 revenue",
      "going": "180 going"
    },
    {
      "imageUrl": "https://images.unsplash.com/photo-1484755560693-a4074577af3a?q=80&w=300&auto=format&fit=crop",
      "title": "Electro Carnival 2026",
      "location": "Metropolis Expo Plaza",
      "revenue": "\$22,60 revenue",
      "going": "1,200 going"
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldColor,
      appBar: const CustomAppBar(
        title: "Upcoming Events",
        showRightIcon: false,
      ),
      body: SafeArea(
        child: ListView.separated(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
          itemCount: _mockEvents.length,
          separatorBuilder: (context, index) => UIHelper.verticalSpace(16),
          itemBuilder: (context, index) {
            final event = _mockEvents[index];
            return HostEventCard(
              imageUrl: event["imageUrl"]!,
              title: event["title"]!,
              location: event["location"]!,
              revenue: event["revenue"]!,
              going: event["going"]!,
            );
          },
        ),
      ),
    );
  }
}
