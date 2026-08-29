import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:teamstreakpromo/gen/colors.gen.dart';
import 'package:teamstreakpromo/helpers/ui_helpers.dart';
import 'package:teamstreakpromo/helpers/all_routes.dart';
import '../widget/host_stat_card.dart';
import '../widget/revenue_chart_card.dart';
import '../widget/ticket_sales_chart_card.dart';
import '../widget/host_event_card.dart';
import 'package:teamstreakpromo/common_widgets/host_app_bar.dart';
import 'package:teamstreakpromo/networks/dio/dio.dart';
import 'package:teamstreakpromo/networks/endpoints.dart';
import 'package:teamstreakpromo/features/host_features/host_home/model/profile_information_model.dart';
import 'package:teamstreakpromo/helpers/di.dart';
import 'package:teamstreakpromo/features/host_features/host_events/data/rx_get_events/rx.dart';

class HostHomeScreen extends StatefulWidget {
  const HostHomeScreen({super.key});

  @override
  State<HostHomeScreen> createState() => _HostHomeScreenState();
}

class _HostHomeScreenState extends State<HostHomeScreen> {
  final List<Map<String, String>> _homeEvents = const [
    {
      "imageUrl":
          "https://images.unsplash.com/photo-1506157786151-b8491531f063?q=80&w=300&auto=format&fit=crop",
      "title": "SoundWave Music Festival",
      "location": "Divine Art Festival",
      "revenue": "\$7,420 revenue",
      "going": "220 going",
    },
    {
      "imageUrl":
          "https://images.unsplash.com/photo-1470225620780-dba8ba36b745?q=80&w=300&auto=format&fit=crop",
      "title": "Neon Beat Rave Night",
      "location": "Central Techno Arena",
      "revenue": "\$12,150 revenue",
      "going": "540 going",
    },
    {
      "imageUrl":
          "https://images.unsplash.com/photo-1516450360452-9312f5e86fc7?q=80&w=300&auto=format&fit=crop",
      "title": "Acoustic Sunset Session",
      "location": "Golden Bay Resort",
      "revenue": "\$3,800 revenue",
      "going": "150 going",
    },
  ];

  @override
  void initState() {
    super.initState();
    _fetchProfileAndEvents();
  }

  Future<void> _fetchProfileAndEvents() async {
    try {
      final response = await getHttp(Endpoints.authMe());
      if (response.statusCode == 200 || response.statusCode == 201) {
        final profile = ProfileInformationModel.fromJson(response.data);
        final id = profile.data?.id;
        if (id != null) {
          appData.write('id', id);
          locator<GetEventsRx>().fetchEvents(hostId: id);
        }
      }
    } catch (e) {
      debugPrint("Error fetching profile: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldColor,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const HostAppBar(),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    UIHelper.verticalSpace(16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                Routes.earningOverviewScreen,
                              );
                            },
                            child: HostStatCard(
                              title: "Total Revenue",
                              value: "\$12,450",
                              icon: Icons.access_time_rounded,
                              iconColor: Colors.greenAccent,
                              circleBgColor: Colors.greenAccent.withValues(
                                alpha: 0.15,
                              ),
                            ),
                          ),
                        ),
                        UIHelper.horizontalSpace(16),
                        Expanded(
                          child: HostStatCard(
                            title: "Ticket Sold",
                            value: "12,450",
                            icon: Icons.north_east_rounded,
                            iconColor: Colors.blueAccent,
                            circleBgColor: Colors.blueAccent.withValues(
                              alpha: 0.15,
                            ),
                          ),
                        ),
                      ],
                    ),
                    UIHelper.verticalSpace(24),
                    const RevenueChartCard(),
                    UIHelper.verticalSpace(24),
                    const TicketSalesChartCard(),
                    UIHelper.verticalSpace(24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Upcoming Events",
                          style: TextStyle(
                            fontFamily: "SF Pro Rounded",
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              Routes.allEventsScreen,
                            );
                          },
                          behavior: HitTestBehavior.opaque,
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 8.w,
                              vertical: 4.h,
                            ),
                            child: Text(
                              "See All",
                              style: TextStyle(
                                fontFamily: "SF Pro",
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w600,
                                color: AppColors.primaryColorFirst,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    UIHelper.verticalSpace(16),
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _homeEvents.length,
                      separatorBuilder: (context, index) =>
                          UIHelper.verticalSpace(16),
                      itemBuilder: (context, index) {
                        final event = _homeEvents[index];
                        return HostEventCard(
                          imageUrl: event["imageUrl"]!,
                          title: event["title"]!,
                          location: event["location"]!,
                          revenue: event["revenue"]!,
                          going: event["going"]!,
                        );
                      },
                    ),
                    UIHelper.verticalSpace(24),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
