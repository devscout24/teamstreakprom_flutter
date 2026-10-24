import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import '../../../gen/colors.gen.dart';
import '../../../constants/text_font_style.dart';
import '../../../gen/assets.gen.dart';
import '../../../helpers/ui_helpers.dart';
import '../../../networks/api_acess.dart';
import '../model/my_reward_orders_response_model.dart';
import '../widgets/reward_filter_chips.dart';
import '../widgets/my_reward_card.dart';
import 'reward_details_screen.dart';
import 'marketplace_reward_details_screen.dart';
import 'rewards_point_details_screen.dart';

class RewardsScreen extends StatefulWidget {
  const RewardsScreen({super.key});

  @override
  State<RewardsScreen> createState() => _RewardsScreenState();
}

class _RewardsScreenState extends State<RewardsScreen> {
  int _selectedFilterIndex = 0;
  final ScrollController _scrollController = ScrollController();

  static const int _limit = 10;
  int _currentPage = 1;
  bool _isLoading = true;
  bool _isLoadingMore = false;
  bool _hasMore = true;

  String? get _currentItemType {
    if (_selectedFilterIndex == 1) return 'MARKETPLACE';
    if (_selectedFilterIndex == 2) return 'EVENT';
    return null;
  }

  void _onFilterChanged(int index) {
    if (_selectedFilterIndex == index) return;
    setState(() {
      _selectedFilterIndex = index;
    });
    getMyRewardOrdersRxObj.clean();
    _fetchOrders();
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
    });

    try {
      final res = await getMyRewardOrdersRxObj.fetchMyRewardOrders(
        page: 1,
        limit: _limit,
        itemType: _currentItemType,
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
      // Error is handled via stream
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _loadMore() async {
    final currentModel =
        getMyRewardOrdersRxObj.getMyRewardOrdersData.valueOrNull;
    final totalPage = currentModel?.meta?.totalPage ?? 1;

    if (_currentPage >= totalPage) {
      if (mounted) {
        setState(() {
          _hasMore = false;
        });
      }
      return;
    }

    setState(() {
      _isLoadingMore = true;
    });

    try {
      final nextPage = _currentPage + 1;
      final res = await getMyRewardOrdersRxObj.fetchMyRewardOrders(
        page: nextPage,
        limit: _limit,
        itemType: _currentItemType,
      );
      final newTotalPage = res.meta?.totalPage ?? totalPage;
      if (mounted) {
        setState(() {
          _currentPage = nextPage;
          _hasMore = _currentPage < newTotalPage;
        });
      }
    } catch (_) {
    } finally {
      if (mounted) {
        setState(() {
          _isLoadingMore = false;
        });
      }
    }
  }

  Future<void> _onRefresh() async {
    await _fetchOrders();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldColor,
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: RefreshIndicator(
          color: Colors.orange,
          onRefresh: _onRefresh,
          child: SingleChildScrollView(
            controller: _scrollController,
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                UIHelper.verticalSpace(24.h),

                // Points Banner
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              const RewardsPointDetailsScreen(),
                        ),
                      );
                    },
                    child: Container(
                      padding: EdgeInsets.all(20.w),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16.r),
                        image: DecorationImage(
                          image: AssetImage(Assets.images.pointBackground.path),
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Assets.icons.pointIcon.image(
                                color: AppColors.cFFFFFF,
                                height: 24.sp,
                                width: 24.sp,
                              ),
                              UIHelper.horizontalSpace(8.w),
                              Text(
                                "My streak Points",
                                style: TextFontStyle.textStyle24cFFFFFFSFPro590
                                    .copyWith(
                                      fontSize: 18.sp,
                                      fontWeight: FontWeight.w600,
                                      fontFamily: "SF Pro Rounded",
                                      color: AppColors.cE8E8E8,
                                    ),
                              ),
                              const Spacer(),
                              Text(
                                "95",
                                style: TextFontStyle.textStyle24cFFFFFFSFPro590
                                    .copyWith(
                                      fontSize: 32.sp,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: "SF Pro Rounded",
                                      color: AppColors.cFFFFFF,
                                    ),
                              ),
                              Text(
                                " pts",
                                style: TextFontStyle
                                    .textStyle14cFFFFFFSFProRounded400
                                    .copyWith(fontSize: 14.sp),
                              ),
                            ],
                          ),
                          UIHelper.verticalSpace(16.h),
                          Text(
                            "Use points on custom and exclusive rewards",
                            style: TextFontStyle
                                .textStyle14cFFFFFFSFProRounded400
                                .copyWith(
                                  fontSize: 13.sp,
                                  fontFamily: "SF Pro Rounded",
                                  color: AppColors.cE8E8E8,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                UIHelper.verticalSpace(24.h),

                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: RewardFilterChips(
                    selectedIndex: _selectedFilterIndex,
                    onChanged: _onFilterChanged,
                  ),
                ),
                UIHelper.verticalSpace(24.h),

                // List screen
                StreamBuilder<MyRewardOrdersResponseModel>(
                  stream: getMyRewardOrdersRxObj.getMyRewardOrdersData,
                  builder: (context, snapshot) {
                    if (_isLoading) {
                      return Padding(
                        padding: EdgeInsets.symmetric(vertical: 40.h),
                        child: const Center(
                          child: CircularProgressIndicator(
                            color: Colors.orange,
                          ),
                        ),
                      );
                    }

                    if (snapshot.hasError) {
                      return Padding(
                        padding: EdgeInsets.symmetric(vertical: 40.h),
                        child: Center(
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
                                "Failed to load rewards",
                                style: TextFontStyle
                                    .textStyle14cFFFFFFSFProRounded400
                                    .copyWith(
                                      color: Colors.white.withValues(
                                        alpha: 0.6,
                                      ),
                                    ),
                              ),
                              UIHelper.verticalSpace(12.h),
                              TextButton(
                                onPressed: _fetchOrders,
                                child: const Text(
                                  "Try Again",
                                  style: TextStyle(color: Colors.orange),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }

                    final allOrders = snapshot.data?.data ?? [];
                    final filteredRewards = allOrders.where((item) {
                      if (_selectedFilterIndex == 0) return true;
                      if (_selectedFilterIndex == 1) {
                        return (item.itemType ?? '').toUpperCase() ==
                            'MARKETPLACE';
                      }
                      if (_selectedFilterIndex == 2) {
                        return (item.itemType ?? '').toUpperCase() == 'EVENT';
                      }
                      return true;
                    }).toList();

                    if (filteredRewards.isEmpty) {
                      return Padding(
                        padding: EdgeInsets.symmetric(vertical: 40.h),
                        child: Center(
                          child: Text(
                            "No rewards found.",
                            style: TextFontStyle
                                .textStyle14cFFFFFFSFProRounded400
                                .copyWith(
                                  color: Colors.white.withValues(alpha: 0.6),
                                ),
                          ),
                        ),
                      );
                    }

                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      itemCount: filteredRewards.length,
                      itemBuilder: (context, index) {
                        final reward = filteredRewards[index];
                        final isMarketplace =
                            (reward.itemType ?? '').toUpperCase() ==
                            'MARKETPLACE';

                        String claimedDate = "N/A";
                        String claimedTime = "N/A";
                        if (reward.createdAt != null) {
                          try {
                            claimedDate = DateFormat(
                              "dd MMM, yy",
                            ).format(reward.createdAt!.toLocal());
                            claimedTime = DateFormat(
                              "h:mm a",
                            ).format(reward.createdAt!.toLocal());
                          } catch (_) {}
                        }

                        final imageUrl =
                            (reward.photos != null && reward.photos!.isNotEmpty)
                            ? reward.photos!.first
                            : '';

                        return Padding(
                          padding: EdgeInsets.only(bottom: 16.h),
                          child: MyRewardCard(
                            title: reward.title ?? '',
                            description: reward.description ?? '',
                            location:
                                (reward.location != null &&
                                    reward.location!.isNotEmpty)
                                ? reward.location!
                                : 'Kamisama Art Club',
                            claimedDate: claimedDate,
                            claimedTime: claimedTime,
                            imageUrl: imageUrl,
                            type: isMarketplace ? "Marketplace" : "Event",
                            onViewDetailsPressed: () {
                              String formattedDateTime = "N/A";
                              if (reward.createdAt != null) {
                                try {
                                  formattedDateTime = DateFormat(
                                    "MMM dd,yy • hh.mm a",
                                  ).format(reward.createdAt!.toLocal());
                                } catch (_) {}
                              }

                              if (isMarketplace) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        MarketplaceRewardDetailsScreen(
                                          orderId: reward.id,
                                        ),
                                  ),
                                );
                              } else {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => RewardDetailsScreen(
                                      eventName: reward.title ?? '',
                                      eventLocation: reward.location ?? '',
                                      eventDateTime: formattedDateTime,
                                      eventOrganizer: "Music of Tour",
                                      ticketId: reward.id ?? '',
                                      rewardName: reward.title ?? '',
                                      rewardDateTime: formattedDateTime,
                                    ),
                                  ),
                                );
                              }
                            },
                          ),
                        );
                      },
                    );
                  },
                ),

                if (_isLoadingMore) ...[
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 16.h),
                    child: const Center(
                      child: CircularProgressIndicator(color: Colors.orange),
                    ),
                  ),
                ],

                UIHelper.verticalSpace(24.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
