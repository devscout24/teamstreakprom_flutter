import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import '../../../gen/colors.gen.dart';
import '../../../constants/text_font_style.dart';
import '../../../helpers/ui_helpers.dart';
import '../../../networks/api_acess.dart';
import '../../home/widgets/filter_bottom_sheet.dart';
import '../model/get_marketplaces_model.dart';
import '../../../common_widgets/app_network_image.dart';
import '../../business_partner/business_partner_rewards/presentation/business_partner_rewards_details_screen.dart';

class RewardsMarketplaceScreen extends StatefulWidget {
  const RewardsMarketplaceScreen({super.key});

  @override
  State<RewardsMarketplaceScreen> createState() =>
      _RewardsMarketplaceScreenState();
}

class _RewardsMarketplaceScreenState extends State<RewardsMarketplaceScreen> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  String _searchQuery = "";
  int _currentPage = 1;
  bool _isLoadingMore = false;
  bool _hasMore = true;

  @override
  void initState() {
    super.initState();
    _currentPage = 1;
    _hasMore = true;
    _isLoadingMore = false;
    getMarketplacesRxObj.fetchMarketplaces(page: 1, limit: 10);
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 200 &&
        !_isLoadingMore &&
        _hasMore &&
        _searchQuery.isEmpty) {
      _loadMore();
    }
  }

  Future<void> _loadMore() async {
    final currentModel = getMarketplacesRxObj.getMarketplacesData.valueOrNull;
    final totalPage = currentModel?.meta?.totalPage ?? 1;

    if (_currentPage >= totalPage) {
      setState(() {
        _hasMore = false;
      });
      return;
    }

    setState(() {
      _isLoadingMore = true;
    });

    try {
      final nextPage = _currentPage + 1;
      final res = await getMarketplacesRxObj.fetchMarketplaces(
        page: nextPage,
        limit: 10,
      );
      final newTotalPage = res.meta?.totalPage ?? totalPage;
      _currentPage = nextPage;
      _hasMore = _currentPage < newTotalPage;
    } catch (_) {
      // In case of failure, keep state to allow retry on next scroll
    } finally {
      if (mounted) {
        setState(() {
          _isLoadingMore = false;
        });
      }
    }
  }

  Future<void> _onRefresh() async {
    _currentPage = 1;
    _hasMore = true;
    _isLoadingMore = false;
    await getMarketplacesRxObj.fetchMarketplaces(page: 1, limit: 10);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _showFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const FilterBottomSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.c121212,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            UIHelper.verticalSpace(12.h),
            // Search Bar
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Container(
                height: 52.h,
                decoration: BoxDecoration(
                  color: const Color(0xFF1E222B),
                  borderRadius: BorderRadius.circular(100.r),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.05),
                    width: 1.w,
                  ),
                ),
                padding: EdgeInsets.only(left: 16.w, right: 6.w),
                child: Row(
                  children: [
                    Icon(
                      Icons.search,
                      color: Colors.white.withValues(alpha: 0.5),
                      size: 24.sp,
                    ),
                    UIHelper.horizontalSpace(12.w),
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        onChanged: (value) {
                          setState(() {
                            _searchQuery = value.trim().toLowerCase();
                          });
                        },
                        style: TextFontStyle.textStyle14cFFFFFFSFProRounded400
                            .copyWith(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: "Search...",
                          hintStyle: TextFontStyle
                              .textStyle14cFFFFFFSFProRounded400
                              .copyWith(
                                color: Colors.white.withValues(alpha: 0.4),
                              ),
                          border: InputBorder.none,
                          isDense: true,
                          contentPadding: EdgeInsets.zero,
                        ),
                      ),
                    ),
                    if (_searchQuery.isNotEmpty)
                      GestureDetector(
                        onTap: () {
                          _searchController.clear();
                          setState(() {
                            _searchQuery = "";
                          });
                        },
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 6.w),
                          child: Icon(
                            Icons.clear,
                            color: Colors.white.withValues(alpha: 0.5),
                            size: 18.sp,
                          ),
                        ),
                      ),
                    GestureDetector(
                      onTap: _showFilterBottomSheet,
                      child: Container(
                        width: 40.h,
                        height: 40.h,
                        decoration: const BoxDecoration(
                          color: Color(0xFF232D26),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.tune_rounded,
                          color: Colors.white,
                          size: 18.sp,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            UIHelper.verticalSpace(24.h),

            // Grid screen with pagination
            Expanded(
              child: StreamBuilder<GetMarketplacesModel>(
                stream: getMarketplacesRxObj.getMarketplacesData,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting &&
                      !snapshot.hasData) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: Color(0xFFF28F31),
                      ),
                    );
                  }

                  if (snapshot.hasError) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Failed to load rewards",
                            style: TextFontStyle
                                .textStyle14cFFFFFFSFProRounded400
                                .copyWith(
                                  color: Colors.white.withValues(alpha: 0.6),
                                ),
                          ),
                          UIHelper.verticalSpace(12.h),
                          TextButton(
                            onPressed: () {
                              _onRefresh();
                            },
                            child: const Text(
                              "Retry",
                              style: TextStyle(color: Color(0xFFF28F31)),
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  List<MarketplaceItem> rewards = snapshot.data?.data ?? [];

                  if (_searchQuery.isNotEmpty) {
                    rewards = rewards.where((item) {
                      final title = item.title?.toLowerCase() ?? "";
                      final desc = item.description?.toLowerCase() ?? "";
                      final category = item.category?.name?.toLowerCase() ?? "";
                      return title.contains(_searchQuery) ||
                          desc.contains(_searchQuery) ||
                          category.contains(_searchQuery);
                    }).toList();
                  }

                  if (rewards.isEmpty) {
                    return Center(
                      child: Text(
                        "No rewards found.",
                        style: TextFontStyle.textStyle14cFFFFFFSFProRounded400
                            .copyWith(
                              color: Colors.white.withValues(alpha: 0.6),
                            ),
                      ),
                    );
                  }

                  return RefreshIndicator(
                    onRefresh: _onRefresh,
                    color: const Color(0xFFF28F31),
                    child: CustomScrollView(
                      controller: _scrollController,
                      physics: const AlwaysScrollableScrollPhysics(),
                      slivers: [
                        SliverPadding(
                          padding: EdgeInsets.only(
                            left: 24.w,
                            right: 24.w,
                            bottom: _isLoadingMore ? 8.h : 20.h,
                          ),
                          sliver: SliverGrid(
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 12.w,
                              mainAxisSpacing: 16.h,
                              childAspectRatio: 0.64,
                            ),
                            delegate: SliverChildBuilderDelegate(
                              (context, index) {
                                final reward = rewards[index];
                                final String imageUrl =
                                    (reward.photos != null &&
                                            reward.photos!.isNotEmpty)
                                        ? reward.photos!.first
                                        : "";

                                String formattedDate = "N/A";
                                if (reward.endDateTime != null) {
                                  formattedDate = DateFormat(
                                    'dd MMM, yyyy',
                                  ).format(reward.endDateTime!);
                                }

                                return GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            BusinessPartnerRewardsDetailsScreen(
                                          id: reward.id,
                                        ),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF1E222B),
                                      borderRadius: BorderRadius.circular(24.r),
                                      border: Border.all(
                                        color: Colors.white.withValues(
                                          alpha: 0.05,
                                        ),
                                        width: 1.w,
                                      ),
                                    ),
                                    child: Padding(
                                      padding: EdgeInsets.all(8.w),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          // Product Image Container
                                          Container(
                                            height: 130.h,
                                            width: double.infinity,
                                            decoration: BoxDecoration(
                                              color: const Color.fromRGBO(
                                                134,
                                                134,
                                                134,
                                                0.10,
                                              ),
                                              borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(16.r),
                                                topRight: Radius.circular(16.r),
                                              ),
                                            ),
                                            child: ClipRRect(
                                              borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(16.r),
                                                topRight: Radius.circular(16.r),
                                              ),
                                              child: AppNetworkImage(
                                                imageUrl: imageUrl,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                          UIHelper.verticalSpace(8.h),
                                          // Product Title
                                          Text(
                                            reward.title ?? "",
                                            style: TextFontStyle
                                                .textStyle24cFFFFFFSFPro590
                                                .copyWith(
                                                  fontSize: 12.sp,
                                                  color: AppColors.cFFF9F3,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          UIHelper.verticalSpace(4.h),
                                          // Description
                                          Text(
                                            reward.description ?? "",
                                            style: TextFontStyle
                                                .textStyle14cFFFFFFSFProRounded400
                                                .copyWith(
                                                  color: AppColors.cC6C6C6,
                                                  fontSize: 10.sp,
                                                  height: 1.3,
                                                ),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          UIHelper.verticalSpace(8.h),
                                          // Expiry date info line
                                          RichText(
                                            text: TextSpan(
                                              text: "Exp: ",
                                              style: TextFontStyle
                                                  .textStyle14cFFFFFFSFProRounded400
                                                  .copyWith(
                                                    color: const Color(
                                                      0xFFF28F31,
                                                    ),
                                                    fontSize: 10.sp,
                                                    fontWeight: FontWeight.w600,
                                                    fontFamily: 'SF Pro',
                                                  ),
                                              children: [
                                                TextSpan(
                                                  text: formattedDate,
                                                  style: TextStyle(
                                                    color: AppColors.cE9EAE9,
                                                    fontWeight: FontWeight.w400,
                                                    fontSize: 11.sp,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          UIHelper.verticalSpace(4.h),
                                          // Points info line
                                          RichText(
                                            text: TextSpan(
                                              text: "Pts: ",
                                              style: TextFontStyle
                                                  .textStyle14cFFFFFFSFProRounded400
                                                  .copyWith(
                                                    color: const Color(
                                                      0xFF00D394,
                                                    ),
                                                    fontSize: 10.sp,
                                                    fontWeight: FontWeight.w600,
                                                    fontFamily: 'SF Pro',
                                                  ),
                                              children: [
                                                TextSpan(
                                                  text:
                                                      "${reward.points ?? 0} pts",
                                                  style: TextStyle(
                                                    color: AppColors.cE9EAE9,
                                                    fontWeight: FontWeight.w400,
                                                    fontSize: 11.sp,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          UIHelper.verticalSpace(4.h),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                              childCount: rewards.length,
                            ),
                          ),
                        ),
                        if (_isLoadingMore)
                          SliverToBoxAdapter(
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 16.h),
                              child: const Center(
                                child: SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2.5,
                                    color: Color(0xFFF28F31),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        SliverToBoxAdapter(
                          child: SizedBox(height: 20.h),
                        ),
                      ],
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
