import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import '../../../gen/colors.gen.dart';
import '../../../constants/text_font_style.dart';
import '../../../helpers/ui_helpers.dart';
import '../../../common_widgets/ticket_toggle_button.dart';
import '../../../networks/api_acess.dart';
import '../model/my_orders_response_model.dart';
import '../widgets/ticket_card.dart';
import '../../../helpers/navigation_service.dart';
import '../../../helpers/all_routes.dart';

class MyTicketScreen extends StatefulWidget {
  const MyTicketScreen({super.key});

  @override
  State<MyTicketScreen> createState() => _MyTicketScreenState();
}

class _MyTicketScreenState extends State<MyTicketScreen> {
  int _tabIndex = 0; // 0 = Upcoming, 1 = Past Ticket, 2 = Refunded Tickets
  final ScrollController _scrollController = ScrollController();

  static const int _limit = 10;
  int _currentPage = 1;
  bool _isLoading = true;
  bool _isLoadingMore = false;
  bool _hasMore = true;
  bool _paginationError = false;

  String get _currentStatus {
    switch (_tabIndex) {
      case 0:
        return 'PAID';
      case 1:
        return 'COMPLETED';
      case 2:
        return 'CANCELLED';
      default:
        return 'PAID';
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchOrders();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.hasClients &&
        _scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 200 &&
        !_isLoadingMore &&
        !_isLoading &&
        !_paginationError &&
        _hasMore) {
      _loadMore();
    }
  }

  Future<void> _fetchOrders() async {
    setState(() {
      _isLoading = true;
      _currentPage = 1;
      _hasMore = true;
      _isLoadingMore = false;
      _paginationError = false;
    });

    try {
      final res = await getMyOrdersRxObj.fetchMyOrders(
        page: 1,
        limit: _limit,
        status: _currentStatus,
      );
      final totalPage = res.meta?.totalPage ?? 1;
      final count = res.data?.length ?? 0;
      if (mounted) {
        setState(() {
          _currentPage = 1;
          _hasMore = _currentPage < totalPage && count >= _limit;
        });
      }
    } catch (_) {
      // Error is handled via stream/Rx
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _onRefresh() async {
    _currentPage = 1;
    _hasMore = true;
    _isLoadingMore = false;
    _paginationError = false;

    try {
      final res = await getMyOrdersRxObj.fetchMyOrders(
        page: 1,
        limit: _limit,
        status: _currentStatus,
      );
      final totalPage = res.meta?.totalPage ?? 1;
      final count = res.data?.length ?? 0;
      if (mounted) {
        setState(() {
          _currentPage = 1;
          _hasMore = _currentPage < totalPage && count >= _limit;
        });
      }
    } catch (_) {}
  }

  Future<void> _loadMore() async {
    if (_isLoadingMore || !_hasMore || _isLoading) return;

    final currentModel = getMyOrdersRxObj.getMyOrdersData.valueOrNull;
    final totalPage = currentModel?.meta?.totalPage ?? 1;
    final currentOrders = currentModel?.data ?? [];

    // After 10 items, increase page number (e.g. 10 items -> page 2, 20 items -> page 3)
    final nextPage = (currentOrders.length ~/ _limit) + 1;

    if (nextPage > totalPage ||
        (currentOrders.length < _limit && _currentPage >= 1)) {
      if (mounted) {
        setState(() {
          _hasMore = false;
        });
      }
      return;
    }

    setState(() {
      _isLoadingMore = true;
      _paginationError = false;
    });

    try {
      final res = await getMyOrdersRxObj.fetchMyOrders(
        page: nextPage,
        limit: _limit,
        status: _currentStatus,
      );
      final newTotalPage = res.meta?.totalPage ?? totalPage;
      final newTotalCount = res.data?.length ?? 0;

      if (mounted) {
        setState(() {
          _currentPage = nextPage;
          _hasMore = _currentPage < newTotalPage &&
              newTotalCount > currentOrders.length;
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() {
          _paginationError = true;
        });
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoadingMore = false;
        });
      }
    }
  }

  void _onTabChanged(int index) {
    if (_tabIndex == index) return;
    if (_scrollController.hasClients) {
      _scrollController.jumpTo(0.0);
    }
    setState(() {
      _tabIndex = index;
      _currentPage = 1;
      _hasMore = true;
      _isLoadingMore = false;
      _paginationError = false;
    });
    getMyOrdersRxObj.clean();
    _fetchOrders();
  }

  String _formatDateTime(DateTime? dateTime) {
    if (dateTime == null) return '';
    try {
      return DateFormat("dd MMM – hh:mm a").format(dateTime.toLocal());
    } catch (_) {
      return dateTime.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldColor,
      body: Column(
        children: [
          UIHelper.verticalSpace(24.h),

          // ── Tab toggle ────────────────────────────────────────
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: TicketToggleButton(
              tabs: const ['Upcoming', 'Past Ticket', 'Refunded'],
              selectedIndex: _tabIndex,
              onChanged: _onTabChanged,
              height: 50.h,
            ),
          ),

          UIHelper.verticalSpace(20.h),

          // ── Ticket list ───────────────────────────────────────
          Expanded(
            child: RefreshIndicator(
              color: Colors.orange,
              onRefresh: _onRefresh,
              child: StreamBuilder<MyOrdersResponseModel>(
                stream: getMyOrdersRxObj.getMyOrdersData,
                builder: (context, snapshot) {
                  if (_isLoading) {
                    return const Center(
                      child: CircularProgressIndicator(color: Colors.orange),
                    );
                  }

                  if (snapshot.hasError) {
                    return Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.error_outline_rounded,
                            size: 48.sp,
                            color: Colors.white.withValues(alpha: 0.3),
                          ),
                          UIHelper.verticalSpace(12.h),
                          Text(
                            'Failed to load tickets',
                            style: TextFontStyle
                                .textStyle14cFFFFFFSFProRounded400
                                .copyWith(
                              fontFamily: 'SF Pro',
                              fontSize: 16.sp,
                              color: Colors.white.withValues(alpha: 0.4),
                            ),
                          ),
                          UIHelper.verticalSpace(12.h),
                          TextButton(
                            onPressed: _fetchOrders,
                            child: const Text(
                              'Try Again',
                              style: TextStyle(color: Colors.orange),
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  final orders = snapshot.data?.data ?? [];

                  if (orders.isEmpty) {
                    return Center(
                      child: SingleChildScrollView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        child: _EmptyState(
                          key: ValueKey(_tabIndex),
                          tabIndex: _tabIndex,
                        ),
                      ),
                    );
                  }

                  return AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: ListView.builder(
                      controller: _scrollController,
                      physics: const AlwaysScrollableScrollPhysics(),
                      key: ValueKey(_tabIndex),
                      padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 24.h),
                      itemCount: orders.length +
                          (_isLoadingMore || _paginationError ? 1 : 0),
                      itemBuilder: (context, index) {
                        // Trigger load more near bottom
                        if (index >= orders.length - 2 &&
                            !_isLoadingMore &&
                            !_isLoading &&
                            !_paginationError &&
                            _hasMore) {
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            _loadMore();
                          });
                        }

                        // Pagination loading / error footer
                        if (index == orders.length) {
                          if (_paginationError) {
                            return Padding(
                              padding: EdgeInsets.symmetric(vertical: 16.h),
                              child: Center(
                                child: TextButton.icon(
                                  onPressed: _loadMore,
                                  icon: const Icon(
                                    Icons.refresh_rounded,
                                    color: Colors.orange,
                                    size: 18,
                                  ),
                                  label: Text(
                                    'Failed to load more. Tap to retry',
                                    style: TextFontStyle
                                        .textStyle14cFFFFFFSFProRounded400
                                        .copyWith(
                                      fontFamily: 'SF Pro',
                                      fontSize: 13.sp,
                                      color: Colors.orange,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }
                          return Padding(
                            padding: EdgeInsets.symmetric(vertical: 16.h),
                            child: const Center(
                              child: SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.5,
                                  color: Colors.orange,
                                ),
                              ),
                            ),
                          );
                        }

                        final order = orders[index];
                        final event = order.eventId;
                        final eventName = event?.title ?? 'Event';
                        final dateTime = _formatDateTime(event?.startDate);
                        final location = event?.placeName ?? '';
                        final ticketCount = order.totalTicketQuantity ??
                            order.tickets?.fold<int>(
                              0,
                              (sum, t) => sum + (t.quantity ?? 0),
                            ) ??
                            1;
                        final price =
                            '\$${order.totalAmount != null ? order.totalAmount!.toStringAsFixed(2) : '0.00'}';
                        final flyerUrl =
                            (event?.images != null && event!.images!.isNotEmpty)
                                ? event.images!.first
                                : null;

                        return Padding(
                          padding: EdgeInsets.only(bottom: 16.h),
                          child: GestureDetector(
                            onTap: () {
                              NavigationService.navigateToWithArgs(
                                Routes.ticketDetailsScreen,
                                {
                                  'orderId': order.id,
                                },
                              );
                            },
                            child: TicketCard(
                              eventName: eventName,
                              dateTime: dateTime,
                              location: location,
                              ticketCount: ticketCount,
                              price: price,
                              imageUrl: flyerUrl,
                              showActions: _tabIndex == 0,
                              viewLabel: 'View My Ticket',
                              onViewPressed: () {
                                NavigationService.navigateToWithArgs(
                                  Routes.ticketDetailsScreen,
                                  {
                                    'orderId': order.id,
                                  },
                                );
                              },
                            ),
                          ),
                        );
                      },
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
  const _EmptyState({super.key, required this.tabIndex});

  final int tabIndex;

  @override
  Widget build(BuildContext context) {
    final String message;
    final IconData icon;

    switch (tabIndex) {
      case 0:
        message = 'No upcoming tickets';
        icon = Icons.confirmation_num_outlined;
        break;
      case 1:
        message = 'No past tickets';
        icon = Icons.history_rounded;
        break;
      case 2:
      default:
        message = 'No refunded tickets';
        icon = Icons.cancel_outlined;
        break;
    }

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 64.sp,
            color: Colors.white.withValues(alpha: 0.15),
          ),
          UIHelper.verticalSpace(16.h),
          Text(
            message,
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
