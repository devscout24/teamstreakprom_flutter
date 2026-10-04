import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:teamstreakpromo/features/host_features/host_events/model/get_events_response_model.dart';
import 'package:teamstreakpromo/gen/colors.gen.dart';
import 'package:teamstreakpromo/helpers/ui_helpers.dart';
import '../widget/host_events_header.dart';
import '../widget/host_events_tab_bar.dart';
import '../widget/host_event_list_card.dart';
import 'package:teamstreakpromo/features/event/presentation/event_details_screen.dart';
import 'package:teamstreakpromo/helpers/all_routes.dart';
import 'package:teamstreakpromo/helpers/navigation_service.dart';
import 'package:teamstreakpromo/helpers/di.dart';
import 'package:teamstreakpromo/features/host_features/host_events/data/rx_get_events/rx.dart';
import 'package:teamstreakpromo/constants/app_constants.dart';
import 'package:teamstreakpromo/networks/api_acess.dart';
import 'package:teamstreakpromo/common_widgets/custom_toast.dart';

class HostEventsScreen extends StatefulWidget {
  final VoidCallback onBack;

  const HostEventsScreen({super.key, required this.onBack});

  @override
  State<HostEventsScreen> createState() => _HostEventsScreenState();
}

class _HostEventsScreenState extends State<HostEventsScreen> {
  String _activeTab = "Upcoming Events";

  @override
  void initState() {
    super.initState();
    final String? hostId = appData.read('id');
    final String? accountType = appData.read(kAccountType);

    bool isHost =
        accountType != null &&
        (accountType.toLowerCase() == "host" ||
            accountType == "AccountType.host");

    if (isHost && (hostId == null || hostId.isEmpty)) {
      debugPrint("Skipping GetEvents API: User is host but no hostId is set.");
    } else {
      locator<GetEventsRx>().fetchEvents(hostId: hostId);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldColor,
      body: SafeArea(
        child: Column(
          children: [
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

            // Toggle Bar (Upcoming Events / Past Events / Canceled Events)
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
              child: StreamBuilder<GetEventsResponseModel>(
                stream: locator<GetEventsRx>().getGetEventsData,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primaryColorSecond,
                      ),
                    );
                  }
                  if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        "Error fetching events",
                        style: TextStyle(
                          fontFamily: "SF Pro",
                          fontSize: 14.sp,
                          color: Colors.white.withValues(alpha: 0.4),
                        ),
                      ),
                    );
                  }

                  List<EventItem> activeList = [];
                  if (_activeTab == "Upcoming Events") {
                    activeList = snapshot.data?.data ?? [];
                  }

                  return activeList.isEmpty
                      ? Center(
                          child: Text(
                            "No ${_activeTab.toLowerCase()} found",
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
                            final imageUrl =
                                (event.images != null &&
                                    event.images!.isNotEmpty)
                                ? event.images!.first
                                : "";

                            // Format date if possible
                            String formattedDate = event.startDate ?? "TBD";
                            try {
                              if (event.startDate != null) {
                                DateTime date = DateTime.parse(
                                  event.startDate!,
                                );
                                formattedDate = DateFormat(
                                  "d MMM, yyyy • ha",
                                ).format(date);
                              }
                            } catch (_) {}

                            return GestureDetector(
                              onTap: () {
                                NavigationService.navigateToWithArgs(
                                  Routes.eventDetailsScreen,
                                  {
                                    'title': event.title ?? "Unknown",
                                    'location':
                                        event.placeName ?? "Unknown Location",
                                    'date': formattedDate,
                                    'price': "\$ ${event.ticketPrice ?? 0}",
                                    'imageUrl': imageUrl,
                                    'description':
                                        event.description ??
                                        "Join us for an unforgettable experience at ${event.title}. A spectacular event not to be missed!",
                                    'eventId': event.sId,
                                  },
                                );
                              },
                              child: HostEventListCard(
                                imageUrl: imageUrl,
                                title: event.title ?? "Unknown",
                                location: event.placeName ?? "Unknown Location",
                                date: formattedDate,
                                price: "\$ ${event.ticketPrice ?? 0}",
                                ticketsSold:
                                    0, // Using 0 since api doesn't provide it directly
                                capacity: event.stock ?? 0,
                                onEdit: () async {
                                  if (event.sId != null) {
                                    try {
                                      final response =
                                          await getEventDetailsRxObj
                                              .getEventDetails(event.sId!);
                                      if (response?.data != null &&
                                          context.mounted) {
                                        NavigationService.navigateToWithArgs(
                                          Routes.createEventScreen,
                                          {'eventData': response!.data},
                                        );
                                      }
                                    } catch (e) {
                                      customToastMessage(
                                        "Error",
                                        "Failed to load event details for editing",
                                        isError: true,
                                      );
                                    }
                                  }
                                },
                                onDelete: () async {
                                  if (event.sId != null) {
                                    try {
                                      final success = await deleteEventRxObj
                                          .deleteEvent(event.sId!);
                                      if (success) {
                                        final String? hostId = appData.read(
                                          'id',
                                        );
                                        locator<GetEventsRx>().fetchEvents(
                                          hostId: hostId,
                                        );
                                        customToastMessage(
                                          "Success",
                                          "Event deleted successfully!",
                                        );
                                      }
                                    } catch (e) {
                                      customToastMessage(
                                        "Error",
                                        "Failed to delete event",
                                        isError: true,
                                      );
                                    }
                                  } else {
                                    customToastMessage(
                                      "Error",
                                      "Invalid event ID",
                                      isError: true,
                                    );
                                  }
                                },
                              ),
                            );
                          },
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
