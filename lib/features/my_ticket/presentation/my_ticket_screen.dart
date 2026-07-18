import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../gen/colors.gen.dart';
import '../../../constants/text_font_style.dart';
import '../../../helpers/ui_helpers.dart';
import '../../../common_widgets/ticket_toggle_button.dart';
import '../widgets/ticket_card.dart';
import 'ticket_details_screen.dart';
import '../widgets/cancel_ticket_bottom_sheet.dart';

// ── Minimal data model ──────────────────────────────────────────────────
class _TicketModel {
  const _TicketModel({
    required this.eventName,
    required this.dateTime,
    required this.location,
    required this.ticketCount,
    required this.price,
    this.isPast = false,
  });

  final String eventName;
  final String dateTime;
  final String location;
  final int ticketCount;
  final String price;
  final bool isPast;
}

class MyTicketScreen extends StatefulWidget {
  const MyTicketScreen({super.key});

  @override
  State<MyTicketScreen> createState() => _MyTicketScreenState();
}

class _MyTicketScreenState extends State<MyTicketScreen> {
  int _tabIndex = 0; // 0 = Upcoming, 1 = Past Ticket

  static const _tickets = [
    _TicketModel(
      eventName: 'Disco Tehran – Goodbye Party',
      dateTime: '23 Oct – 08:00 PM',
      location: 'Jakarta International Stadium',
      ticketCount: 1,
      price: '\$56.00',
    ),
    _TicketModel(
      eventName: 'Jazz Night – Blue Horizon',
      dateTime: '15 Nov – 07:30 PM',
      location: 'Grand City Concert Hall',
      ticketCount: 2,
      price: '\$120.00',
    ),
    _TicketModel(
      eventName: 'EDM Festival 2024',
      dateTime: '30 Dec – 10:00 PM',
      location: 'Gelora Bung Karno',
      ticketCount: 1,
      price: '\$85.00',
    ),
    _TicketModel(
      eventName: 'Rock Legends Reunion',
      dateTime: '05 Jan – 06:00 PM',
      location: 'Istora Senayan',
      ticketCount: 3,
      price: '\$210.00',
      isPast: true,
    ),
    _TicketModel(
      eventName: 'Classical Gala Night',
      dateTime: '10 Feb – 07:00 PM',
      location: 'Taman Ismail Marzuki',
      ticketCount: 1,
      price: '\$45.00',
      isPast: true,
    ),
  ];

  List<_TicketModel> get _filtered =>
      _tickets.where((t) => t.isPast == (_tabIndex == 1)).toList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldColor,

      body: Column(
        children: [
          UIHelper.verticalSpace(8.h),

          // ── Tab toggle ────────────────────────────────────────
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: TicketToggleButton(
              leftLabel: 'Upcoming',
              rightLabel: 'Past Ticket',
              selectedIndex: _tabIndex,
              onChanged: (i) => setState(() => _tabIndex = i),
              height: 50.h,
            ),
          ),

          UIHelper.verticalSpace(20.h),

          // ── Ticket list ───────────────────────────────────────
          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: _filtered.isEmpty
                  ? _EmptyState(
                      key: ValueKey(_tabIndex),
                      isPast: _tabIndex == 1,
                    )
                  : ListView.builder(
                      key: ValueKey(_tabIndex),
                      padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 24.h),
                      itemCount: _filtered.length,
                      itemBuilder: (context, index) {
                        final ticket = _filtered[index];
                        return Padding(
                          padding: EdgeInsets.only(bottom: 16.h),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => TicketDetailsScreen(
                                    eventName: ticket.eventName,
                                    dateTime: ticket.dateTime,
                                    location: ticket.location,
                                    ticketCount: ticket.ticketCount,
                                    price: ticket.price,
                                  ),
                                ),
                              );
                            },
                            child: TicketCard(
                              eventName: ticket.eventName,
                              dateTime: ticket.dateTime,
                              location: ticket.location,
                              ticketCount: ticket.ticketCount,
                              price: ticket.price,
                              showActions: _tabIndex == 0,
                              viewLabel: 'View',
                              cancelLabel: 'Cancel',
                              onViewPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => TicketDetailsScreen(
                                      eventName: ticket.eventName,
                                      dateTime: ticket.dateTime,
                                      location: ticket.location,
                                      ticketCount: ticket.ticketCount,
                                      price: ticket.price,
                                    ),
                                  ),
                                );
                              },
                              onCancelPressed: () {
                                showCancelTicketBottomSheet(context);
                              },
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({super.key, required this.isPast});

  final bool isPast;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isPast ? Icons.history_rounded : Icons.confirmation_num_outlined,
            size: 64.sp,
            color: Colors.white.withValues(alpha: 0.15),
          ),
          UIHelper.verticalSpace(16.h),
          Text(
            isPast ? 'No past tickets' : 'No upcoming tickets',
            style: TextFontStyle.textStyle14cFFFFFFSFProRounded400.copyWith(
              fontFamily: 'SF Pro',
              fontSize: 16.sp,
              color: Colors.white.withValues(alpha: 0.4),
            ),
          ),
        ],
      ),
    );
  }
}
