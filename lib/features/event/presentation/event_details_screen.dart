import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:teamstreakpromo/helpers/all_routes.dart';
import 'package:teamstreakpromo/helpers/navigation_service.dart';
import '../../../gen/colors.gen.dart';
import '../../../constants/text_font_style.dart';
import '../../../helpers/ui_helpers.dart';

import '../../../common_widgets/ticket_toggle_button.dart';
import '../widgets/invite_friend_bottom_sheet.dart';
import '../widgets/reward_success_dialog.dart';
import '../widgets/event_details_widgets.dart';
import 'stripe_checkout_webview_screen.dart';
import '../widgets/event_info_tab.dart';
import '../widgets/event_bottom_actions.dart';
import '../widgets/ticket_type_list.dart';
import '../model/event_ticket_type.dart';
import '../../../constants/app_constants.dart';
import '../../../helpers/di.dart';
import 'package:teamstreakpromo/networks/api_acess.dart';
import 'package:teamstreakpromo/features/event/model/host_event_details_model.dart';
import 'package:teamstreakpromo/features/host_features/host_events/data/rx_get_events/rx.dart';
import 'package:intl/intl.dart';

class EventDetailsScreen extends StatefulWidget {
  final String title;
  final String location;
  final String date;
  final String price;
  final String imageUrl;
  final String description;
  final String? points;
  final bool isReward;
  final String? eventId;

  const EventDetailsScreen({
    super.key,
    required this.title,
    required this.location,
    required this.date,
    required this.price,
    required this.imageUrl,
    required this.description,
    this.points,
    this.isReward = false,
    this.eventId,
  });

  @override
  State<EventDetailsScreen> createState() => _EventDetailsScreenState();
}

class _EventDetailsScreenState extends State<EventDetailsScreen> {
  int _selectedTabIndex = 0; // 0: Event Info, 1: Reward Info
  int _ticketCount = 1;
  int _selectedTicketTypeIndex = 0;
  late List<EventTicketType> _ticketTypes;
  int _currentCarouselIndex = 0;
  final PageController _pageController = PageController();
  Timer? _carouselTimer;
  int? _selectedRewardProductIndex;

  bool _isLoadingDetails = false;
  bool _isDeleting = false;
  HostEventDetailsModel? _eventDetails;

  late String _displayTitle;
  late String _displayLocation;
  late String _displayDate;
  late String _displayPrice;
  late String _displayDescription;
  List<ArtistInfo> _artists = [];

  // Mock list of carousel images
  late List<String> _carouselImages;

  EventTicketType? get _selectedTicketType =>
      (_selectedTicketTypeIndex >= 0 &&
              _selectedTicketTypeIndex < _ticketTypes.length)
          ? _ticketTypes[_selectedTicketTypeIndex]
          : (_ticketTypes.isNotEmpty ? _ticketTypes.first : null);

  @override
  void initState() {
    super.initState();
    _displayTitle = widget.title;
    _displayLocation = widget.location;
    _displayDate = widget.date;
    _displayPrice = widget.price;
    _displayDescription = widget.description;

    _ticketTypes = [];

    _selectedTabIndex = widget.isReward ? 1 : 0;
    _carouselImages = [
      widget.imageUrl,
      "https://images.unsplash.com/photo-1470225620780-dba8ba36b745?auto=format&fit=crop&w=600&q=80",
      "https://images.unsplash.com/photo-1511192336575-5a79af67a629?auto=format&fit=crop&w=600&q=80",
    ];

    if (widget.eventId != null) {
      _fetchEventDetails();
    }

    _carouselTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (mounted && _pageController.hasClients) {
        try {
          final page = _pageController.page;
          if (page != null) {
            int nextPageIndex = (page.round() + 1) % _carouselImages.length;
            _pageController.animateToPage(
              nextPageIndex,
              duration: const Duration(milliseconds: 350),
              curve: Curves.easeInOut,
            );
          }
        } catch (e) {
          debugPrint("Carousel timer error: $e");
        }
      }
    });
  }

  Data? _getMatchedEvent(HostEventDetailsModel? model) {
    if (model == null || model.data == null || model.data!.isEmpty) {
      return null;
    }
    if (widget.eventId != null && widget.eventId!.isNotEmpty) {
      final matched = model.data!.where((e) => e.id == widget.eventId);
      if (matched.isNotEmpty) return matched.first;
    }
    return model.data!.first;
  }

  Data? get _currentEventData => _getMatchedEvent(_eventDetails);

  Future<void> _fetchEventDetails() async {
    setState(() => _isLoadingDetails = true);
    try {
      final response = await getEventDetailsRxObj.getEventDetails(
        widget.eventId!,
      );
      setState(() {
        _eventDetails = response;
        final data = _getMatchedEvent(response);
        if (data != null) {
          _displayTitle = data.title ?? _displayTitle;
          _displayLocation = data.placeName ?? _displayLocation;
          _displayDate = data.startDate != null
              ? DateFormat("d MMM, yyyy • ha").format(data.startDate!)
              : _displayDate;

          // Populate ticket types from API priceCategories if available
          if (data.priceCategories != null &&
              data.priceCategories!.isNotEmpty) {
            _ticketTypes = data.priceCategories!.map((pc) {
              return EventTicketType(
                id: pc.id ?? pc.name ?? 'ticket',
                title: pc.name ?? 'General',
                price: pc.price ?? 0.0,
                subtitle: pc.stock != null ? "${pc.stock} seats remaining" : null,
              );
            }).toList();
            _selectedTicketTypeIndex = 0;

            final minPrice = _ticketTypes
                .map((t) => t.price.round())
                .reduce((a, b) => a < b ? a : b);
            final maxPrice = _ticketTypes
                .map((t) => t.price.round())
                .reduce((a, b) => a > b ? a : b);
            _displayPrice = minPrice == maxPrice
                ? "\$ $minPrice"
                : "\$ $minPrice - \$ $maxPrice";
          } else if (data.ticketPrice != null && data.ticketPrice! > 0) {
            _displayPrice = "\$ ${data.ticketPrice}";
            _ticketTypes = [];
          } else {
            _ticketTypes = [];
          }

          final validImages = (data.images ?? [])
              .map((img) => img.trim())
              .where((img) => img.isNotEmpty)
              .toList();
          if (validImages.isNotEmpty) {
            _carouselImages = validImages;
          }

          _displayDescription = data.description ?? _displayDescription;

          if (data.artistInfo != null) {
            _artists = data.artistInfo!;
          }

          if (data.rewards != null) {
            _rewardProducts = data.rewards!
                .map(
                  (r) => RewardProduct(
                    title: r.title ?? "Reward",
                    description: r.description ?? "",
                    imageUrls: (r.images != null && r.images!.isNotEmpty)
                        ? r.images!.where((x) => x.isNotEmpty).toList()
                        : (r.image != null && r.image!.isNotEmpty)
                            ? [r.image!]
                            : ["https://via.placeholder.com/400"],
                    isStockIn: (r.stock ?? 0) > 0,
                    points: r.pointsRequired?.toString() ?? "0",
                    stock: r.stock ?? 0,
                  ),
                )
                .toList();
          }
        }
      });
    } catch (e) {
      debugPrint("Failed to fetch event details: $e");
    } finally {
      if (mounted) setState(() => _isLoadingDetails = false);
    }
  }

  String get _formattedEndDate {
    final event = _currentEventData;
    if (event?.endDate != null) {
      return DateFormat(
        "MMM d, yyyy · h:mm a",
      ).format(event!.endDate!);
    }
    return "N/A";
  }

  String get _timeLeft {
    final event = _currentEventData;
    if (event?.endDate == null) return "";
    final now = DateTime.now();
    final end = event!.endDate!;
    if (now.isAfter(end)) return "Ended";

    final diff = end.difference(now);
    if (diff.inDays > 0) {
      final hours = diff.inHours % 24;
      return "${diff.inDays}d ${hours}h left";
    }
    if (diff.inHours > 0) {
      final mins = diff.inMinutes % 60;
      return "${diff.inHours}h ${mins}m left";
    }
    if (diff.inMinutes > 0) return "${diff.inMinutes}m left";
    return "Ending soon";
  }

  @override
  void dispose() {
    _carouselTimer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  void _redeemRewardDirectly() {
    if (_selectedRewardProductIndex == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Please select a reward item first.",
            style: TextFontStyle.textStyle14cFFFFFFSFProRounded400.copyWith(
              color: Colors.white,
            ),
          ),
          backgroundColor: const Color(0xFFDD1F1F),
        ),
      );
      return;
    }

    // If called from the bottom sheet, we might want to pop it first, but Flutter
    // allows showing dialogs over bottom sheets. For a better UX, popping the bottom sheet
    // before showing the dialog would be ideal, but requires context.
    // We'll leave the dialog logic as is for now.
    _showRewardSuccessDialog();
  }

  Future<void> _createCheckoutSession() async {
    if (widget.eventId == null) return;

    final body = {
      "eventId": widget.eventId,
      "tickets": [
        if (_selectedTicketType != null)
          {
            "priceCategoryId": _selectedTicketType!.id,
            "quantity": _ticketCount
          }
      ],
      "rewards": [
        if (_selectedRewardProductIndex != null &&
            _selectedRewardProductIndex! >= 0 &&
            _selectedRewardProductIndex! < _rewardProducts.length)
          {
            "rewardId": "6ab0a7a6414da18a92f27b04", // Note: Need actual rewardId if available in RewardProduct model
            "quantity": 1
          }
      ],
      "successUrl": "https://yourfrontend.com/payment-success",
      "cancelUrl": "https://yourfrontend.com/payment-cancel"
    };

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );

    try {
      final response = await createCheckoutSessionRxObj.createCheckoutSession(body);
      if (!mounted) return;
      Navigator.of(context).pop(); // Close loading dialog

      if (response.success == true &&
          response.data != null &&
          response.data!.url != null) {
        final result = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => StripeCheckoutWebViewScreen(
              url: response.data!.url!,
              successUrl: "https://yourfrontend.com/payment-success",
              cancelUrl: "https://yourfrontend.com/payment-cancel",
            ),
          ),
        );

        if (!mounted) return;
        if (result == true) {
          _showBookingSuccessDialog();
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(response.message ?? "Failed to create checkout session"),
            backgroundColor: const Color(0xFFDD1F1F),
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      Navigator.of(context).pop(); // Close loading dialog
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error: $e"),
          backgroundColor: const Color(0xFFDD1F1F),
        ),
      );
    }
  }

  void _showRewardSuccessDialog() {
    showDialog(
      context: context,
      builder: (context) {
        String rewardTitle = "the reward";
        if (_selectedRewardProductIndex != null &&
            _selectedRewardProductIndex! >= 0 &&
            _selectedRewardProductIndex! < _rewardProducts.length) {
          rewardTitle = _rewardProducts[_selectedRewardProductIndex!].title;
        }
        return RewardSuccessDialog(rewardTitle: rewardTitle);
      },
    );
  }

  void _showBookingSuccessDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1E222B),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.r),
        ),
        title: Text(
          "Booking Successful",
          style: TextFontStyle.textStyle24cFFFFFFSFPro590.copyWith(
            fontSize: 18.sp,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Successfully booked $_ticketCount ticket(s) for $_displayTitle!",
              style: TextFontStyle.textStyle14cFFFFFFSFProRounded400.copyWith(
                color: Colors.white.withValues(alpha: 0.8),
              ),
            ),
            UIHelper.verticalSpace(14.h),
            Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: const Color(0xFF13151B),
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
              ),
              child: Column(
                children: [
                  if (_selectedTicketType != null) ...[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Ticket Type",
                          style: TextFontStyle.textStyle14cFFFFFFSFProRounded400
                              .copyWith(
                                color: Colors.white.withValues(alpha: 0.5),
                                fontSize: 12.sp,
                              ),
                        ),
                        UIHelper.horizontalSpace(8.w),
                        Flexible(
                          child: Text(
                            _selectedTicketType!.title,
                            style: TextFontStyle.textStyle14cFFFFFFSFProRounded400
                                .copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12.sp,
                                ),
                            textAlign: TextAlign.end,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    UIHelper.verticalSpace(6.h),
                  ],
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Quantity",
                        style: TextFontStyle.textStyle14cFFFFFFSFProRounded400
                            .copyWith(
                              color: Colors.white.withValues(alpha: 0.5),
                              fontSize: 12.sp,
                            ),
                      ),
                      Text(
                        "$_ticketCount",
                        style: TextFontStyle.textStyle14cFFFFFFSFProRounded400
                            .copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 12.sp,
                            ),
                      ),
                    ],
                  ),
                  UIHelper.verticalSpace(6.h),
                  Divider(color: Colors.white.withValues(alpha: 0.08)),
                  UIHelper.verticalSpace(6.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Total Amount",
                        style: TextFontStyle.textStyle14cFFFFFFSFProRounded400
                            .copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 13.sp,
                            ),
                      ),
                      Text(
                        "\$${NumberFormat('#,##0').format(((_selectedTicketType?.price ?? _currentEventData?.ticketPrice?.toDouble() ?? 0.0) * _ticketCount).round())}",
                        style: TextFontStyle.textStyle14cFFFFFFSFProRounded400
                            .copyWith(
                              color: AppColors.primaryColorSecond,
                              fontWeight: FontWeight.bold,
                              fontSize: 15.sp,
                            ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              "OK",
              style: TextFontStyle.textStyle14cFFFFFFSFProRounded400.copyWith(
                color: AppColors.primaryColorSecond,
                fontSize: 16.sp,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    debugPrint("Account Type: ${appData.read(kAccountType)}");
    final String accountType =
        appData.read(kAccountType)?.toString().toLowerCase() ?? '';
    final bool isHost =
        accountType == "host" || accountType == "accounttype.host";

    return Scaffold(
      backgroundColor: AppColors.scaffoldColor,
      bottomNavigationBar: (_isLoadingDetails || _eventDetails == null)
          ? const SizedBox.shrink()
          : EventBottomActions(
              isHost: isHost,
              selectedTabIndex: _selectedTabIndex,
              ticketCount: _ticketCount,
              isDeleting: _isDeleting,
              ticketPrice: _selectedTicketType?.price ??
                  (_currentEventData?.ticketPrice?.toDouble() ?? 0.0),
              selectedTicketTitle: _selectedTicketType?.title,
              onChangeTicketType: _ticketTypes.length > 1
                  ? () {
                      showTicketTypePickerBottomSheet(
                        context: context,
                        ticketTypes: _ticketTypes,
                        selectedIndex: _selectedTicketTypeIndex,
                        onSelect: (index) {
                          setState(() {
                            _selectedTicketTypeIndex = index;
                          });
                        },
                      );
                    }
                  : null,
              onTicketCountIncrement: () {
                setState(() {
                  _ticketCount++;
                });
              },
              onTicketCountDecrement: () {
                if (_ticketCount > 1) {
                  setState(() {
                    _ticketCount--;
                  });
                }
              },
              onBuyTicket: _createCheckoutSession,
              onRedeemReward: _redeemRewardDirectly,
              onEditEvent: () {
                NavigationService.navigateToWithArgs(Routes.createEventScreen, {
                  'eventData': _currentEventData,
                });
              },
              onDeleteEvent: () async {
                if (widget.eventId != null) {
                  setState(() {
                    _isDeleting = true;
                  });
                  try {
                    bool success = await deleteEventRxObj.deleteEvent(
                      widget.eventId!,
                    );
                    if (success && mounted) {
                      final String? hostId = appData.read('id');
                      if (hostId != null) {
                        locator<GetEventsRx>().fetchEvents(hostId: hostId);
                      }
                      NavigationService.goBack(); // Go back to event list
                    }
                  } catch (e) {
                    debugPrint("Error deleting event: $e");
                  } finally {
                    if (mounted) {
                      setState(() {
                        _isDeleting = false;
                      });
                    }
                  }
                }
              },
            ),
      body: Stack(
        children: [
          if (_isLoadingDetails || _eventDetails == null)
            const Center(
              child: CircularProgressIndicator(
                color: AppColors.primaryColorFirst,
              ),
            )
          else
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Image Slider Header ────────────────────────────────────
                  SizedBox(
                    height: 300.h,
                    child: Stack(
                      children: [
                        // PageView
                        PageView.builder(
                          controller: _pageController,
                          itemCount: _carouselImages.length,
                          onPageChanged: (index) {
                            if (mounted) {
                              setState(() {
                                _currentCarouselIndex = index;
                              });
                            }
                          },
                          itemBuilder: (context, index) {
                            return CachedNetworkImage(
                              imageUrl: _carouselImages[index],
                              fit: BoxFit.cover,
                              width: double.infinity,
                              height: double.infinity,
                              placeholder: (context, url) => Container(
                                color: const Color(0xFF1E222B),
                                child: const Center(
                                  child: CircularProgressIndicator(),
                                ),
                              ),
                              errorWidget: (context, url, error) => const Icon(
                                Icons.image_not_supported,
                                color: Colors.grey,
                              ),
                            );
                          },
                        ),
                        // Dark overlay gradient
                        Positioned.fill(
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.black.withValues(alpha: 0.4),
                                  Colors.transparent,
                                  Colors.black.withValues(alpha: 0.8),
                                ],
                                stops: const [0.0, 0.5, 1.0],
                              ),
                            ),
                          ),
                        ),

                        // Carousel Dot Indicators
                        Positioned(
                          bottom: 24.h,
                          left: 0,
                          right: 0,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(
                              _carouselImages.length,
                              (index) => AnimatedContainer(
                                duration: const Duration(milliseconds: 250),
                                width: _currentCarouselIndex == index
                                    ? 20.w
                                    : 8.w,
                                height: 8.h,
                                margin: EdgeInsets.symmetric(horizontal: 4.w),
                                decoration: BoxDecoration(
                                  color: _currentCarouselIndex == index
                                      ? AppColors.primaryColorSecond
                                      : Colors.white.withValues(alpha: 0.5),
                                  borderRadius: BorderRadius.circular(100.r),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // ── Details Body ─────────────────────────────────────────
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 20.w,
                      vertical: 10.h,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Title and Category Badge row
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text(
                                _displayTitle,
                                style: TextFontStyle.textStyle24cFFFFFFSFPro590
                                    .copyWith(
                                      fontSize: 22.sp,
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                            ),
                            UIHelper.horizontalSpace(8.w),
                            Text(
                              _displayPrice,
                              style: TextFontStyle.textStyle24cFFFFFFSFPro590
                                  .copyWith(
                                    fontSize: 18.sp,
                                    color: AppColors.primaryColorSecond,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ],
                        ),
                        UIHelper.verticalSpace(8.h),

                        // Location
                        Row(
                          children: [
                            Icon(
                              Icons.location_on_outlined,
                              color: Colors.white.withValues(alpha: 0.6),
                              size: 16.sp,
                            ),
                            UIHelper.horizontalSpace(6.w),
                            Text(
                              _displayLocation,
                              style: TextFontStyle
                                  .textStyle14cFFFFFFSFProRounded400
                                  .copyWith(
                                    color: Colors.white.withValues(alpha: 0.6),
                                    fontSize: 13.sp,
                                  ),
                            ),
                          ],
                        ),
                        UIHelper.verticalSpace(24.h),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 16.w,
                            vertical: 8.h,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primaryColorSecond.withValues(
                              alpha: 0.1,
                            ),
                            borderRadius: BorderRadius.circular(100.r),
                            border: Border.all(
                              color: AppColors.primaryColorSecond.withValues(
                                alpha: 0.3,
                              ),
                              width: 1.w,
                            ),
                          ),
                          child: Text(
                            _currentEventData?.categoryId?.name ?? "Event",
                            style: TextFontStyle
                                .textStyle14cFFFFFFSFProRounded400
                                .copyWith(
                                  color: AppColors.primaryColorSecond,
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                        ),
                        UIHelper.verticalSpace(8.h),

                        // Info toggle buttons (Event Info vs Reward Info)
                        ClipRRect(
                          borderRadius: BorderRadius.circular(83.r),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 26, sigmaY: 26),
                            child: TicketToggleButton(
                              leftLabel: "Event Info",
                              rightLabel: "Reward Info",
                              selectedIndex: _selectedTabIndex,
                              onChanged: (index) {
                                setState(() {
                                  _selectedTabIndex = index;
                                });
                              },
                              height: 50.h,
                            ),
                          ),
                        ),
                        UIHelper.verticalSpace(24.h),

                        // Tab Content
                        if (_selectedTabIndex == 0) ...[
                          EventInfoTab(
                            isHost: isHost,
                            displayDescription: _displayDescription,
                            artists: _artists,
                            formattedEndDate: _formattedEndDate,
                            timeLeft: _timeLeft,
                            ageRestriction: _currentEventData?.ageRestriction,
                            stock: _currentEventData?.stock ??
                                (_currentEventData?.priceCategories?.fold<int>(
                                      0,
                                      (sum, pc) => sum + (pc.stock ?? 0),
                                    ) ??
                                    0),
                            host: _currentEventData?.hostId,
                          ),
                          if (_ticketTypes.isNotEmpty) ...[
                            UIHelper.verticalSpace(24.h),
                            TicketTypesSection(
                              ticketTypes: _ticketTypes,
                              selectedIndex: _selectedTicketTypeIndex,
                              onSelect: (index) {
                                setState(() {
                                  _selectedTicketTypeIndex = index;
                                });
                              },
                            ),
                          ],
                          UIHelper.verticalSpace(20.h),
                        ] else ...[
                          // ── Reward Info Tab Content (Product List) ──
                          if (_rewardProducts.isEmpty)
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 40.h),
                              child: Center(
                                child: Text(
                                  "No rewards available for this event.",
                                  style: TextFontStyle
                                      .textStyle14cFFFFFFSFProRounded400
                                      .copyWith(
                                        color: Colors.white.withValues(
                                          alpha: 0.6,
                                        ),
                                        fontSize: 14.sp,
                                      ),
                                ),
                              ),
                            )
                          else
                            ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              padding: EdgeInsets.zero,
                              itemCount: _rewardProducts.length,
                              itemBuilder: (context, index) {
                                return RewardProductCard(
                                  product: _rewardProducts[index],
                                  isSelected:
                                      _selectedRewardProductIndex == index,
                                  displayLocation: _displayLocation,
                                  onTap: () {
                                    setState(() {
                                      _selectedRewardProductIndex = index;
                                    });
                                  },
                                  onContinueToPay: _redeemRewardDirectly,
                                );
                              },
                            ),
                        ],
                      ],
                    ),
                  ),

                  // Bottom actions moved to bottomNavigationBar
                ],
              ),
            ),
          // Static Top back & share bar
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        width: 40.w,
                        height: 40.w,
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.4),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.arrow_back_rounded,
                          color: Colors.white,
                          size: 20.sp,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => showInviteFriendBottomSheet(context),
                      child: Container(
                        width: 40.w,
                        height: 40.w,
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.4),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.share_outlined,
                          color: Colors.white,
                          size: 18.sp,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<RewardProduct> _rewardProducts = [];
}
