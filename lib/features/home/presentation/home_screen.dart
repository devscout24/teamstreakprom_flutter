import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../gen/colors.gen.dart';
import '../../../constants/text_font_style.dart';
import '../../../helpers/ui_helpers.dart';
import '../../event/widgets/popular_events_list.dart';
import '../../event/widgets/nearby_events_map.dart';
import '../widgets/category_events_row.dart';
import '../widgets/filter_bottom_sheet.dart';
import '../../../helpers/all_routes.dart';
import '../../../helpers/navigation_service.dart';
import '../../../gen/assets.gen.dart';
import '../../../common_widgets/app_network_image.dart';
import '../../../networks/api_acess.dart';
import '../../../networks/endpoints.dart';
import '../../onboarding/model/intrest_category_model.dart';
import '../../settings/model/user_profile_model.dart';
import 'package:shimmer/shimmer.dart';

class HomeScreen extends StatefulWidget {
  final VoidCallback? onNavigateToRewards;
  const HomeScreen({super.key, this.onNavigateToRewards});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedCategoryIndex = 0;
  int _refreshTimestamp = DateTime.now().millisecondsSinceEpoch;

  @override
  void initState() {
    super.initState();
    userProfileRxObj.fetchUserProfile();
    getCategoriesRxObj.fetchCategories();
    _initEvents();
  }

  Future<void> _initEvents() async {
    try {
      await authMeRxObj.fetchAuthMe();
      final authMeData = authMeRxObj.authMeData.valueOrNull?.data;
      getEventsByCategoryRxObj.fetchEvents(seed: authMeData?.id);
    } catch (e) {
      getEventsByCategoryRxObj.fetchEvents();
    }
  }

  Future<void> _onRefresh() async {
    setState(() {
      _refreshTimestamp = DateTime.now().millisecondsSinceEpoch;
    });
    userProfileRxObj.fetchUserProfile();
    getCategoriesRxObj.fetchCategories();
    await _initEvents();
  }

  void _showFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const FilterBottomSheet(),
    );
  }

  Widget _buildHeader() {
    return StreamBuilder<UserProfileModel>(
      stream: userProfileRxObj.userProfileData,
      builder: (context, snapshot) {
        final hasData =
            snapshot.hasData ||
            userProfileRxObj.userProfileData.valueOrNull?.data != null;
        if (!hasData && snapshot.connectionState == ConnectionState.waiting) {
          return Container(
            padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 12.h),
            color: AppColors.c121212,
            child: Shimmer.fromColors(
              baseColor: const Color(0xFF1E222B),
              highlightColor: Colors.white.withValues(alpha: 0.05),
              child: Row(
                children: [
                  Container(
                    width: 44.w,
                    height: 44.w,
                    decoration: const BoxDecoration(
                      color: Color(0xFF1E222B),
                      shape: BoxShape.circle,
                    ),
                  ),
                  UIHelper.horizontalSpace(12.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 120.w,
                          height: 16.h,
                          decoration: BoxDecoration(
                            color: const Color(0xFF1E222B),
                            borderRadius: BorderRadius.circular(4.r),
                          ),
                        ),
                        UIHelper.verticalSpace(6.h),
                        Container(
                          width: 80.w,
                          height: 12.h,
                          decoration: BoxDecoration(
                            color: const Color(0xFF1E222B),
                            borderRadius: BorderRadius.circular(4.r),
                          ),
                        ),
                      ],
                    ),
                  ),
                  UIHelper.horizontalSpace(12.w),
                  Container(
                    width: 65.w,
                    height: 32.h,
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E222B),
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                  ),
                  UIHelper.horizontalSpace(12.w),
                  Container(
                    width: 24.w,
                    height: 24.w,
                    decoration: const BoxDecoration(
                      color: Color(0xFF1E222B),
                      shape: BoxShape.circle,
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        final profile =
            snapshot.data?.data ??
            userProfileRxObj.userProfileData.valueOrNull?.data;
        final name = (profile?.name != null && profile!.name!.isNotEmpty)
            ? profile.name!
            : "User";
        final points = profile?.totalPoints ?? 0;
        final location =
            (profile?.businessProfile?.location != null &&
                profile!.businessProfile!.location!.isNotEmpty)
            ? profile.businessProfile!.location!
            : "Divine Art Festival";
        String? profileImageUrl = profile?.profileImage;
        if (profileImageUrl != null &&
            profileImageUrl.isNotEmpty &&
            !profileImageUrl.startsWith('http')) {
          profileImageUrl = url + profileImageUrl;
        }

        return Container(
          padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 12.h),
          color: AppColors.c121212,
          child: Row(
            children: [
              GestureDetector(
                onTap: () async {
                  await NavigationService.navigateTo(Routes.editProfileScreen);
                  userProfileRxObj.fetchUserProfile();
                },
                child: Container(
                  width: 44.w,
                  height: 44.w,
                  decoration: const BoxDecoration(shape: BoxShape.circle),
                  child: ClipOval(
                    child:
                        (profileImageUrl != null && profileImageUrl.isNotEmpty)
                        ? AppNetworkImage(
                            imageUrl: profileImageUrl,
                            height: 44.w,
                            width: 44.w,
                            fit: BoxFit.cover,
                          )
                        : Image.asset(
                            Assets.images.placeholderImage.path,
                            height: 44.w,
                            width: 44.w,
                            fit: BoxFit.cover,
                          ),
                  ),
                ),
              ),
              UIHelper.horizontalSpace(12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    GestureDetector(
                      onTap: () async {
                        await NavigationService.navigateTo(
                          Routes.editProfileScreen,
                        );
                        userProfileRxObj.fetchUserProfile();
                      },
                      child: Text(
                        name,
                        style: TextFontStyle.textStyle16cFFFFFFSFPro590,
                      ),
                    ),
                    UIHelper.verticalSpace(4.h),
                    Row(
                      children: [
                        Icon(
                          Icons.location_on_rounded,
                          size: 16.sp,
                          color: AppColors.primaryColorSecond,
                        ),
                        UIHelper.horizontalSpace(4.w),
                        Flexible(
                          child: Text(
                            location,
                            overflow: TextOverflow.ellipsis,
                            style: TextFontStyle.textStyle14cFFFFFFSFPro590
                                .copyWith(
                                  fontSize: 13.sp,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.white.withValues(alpha: 0.6),
                                ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              UIHelper.horizontalSpace(12.w),
              GestureDetector(
                onTap: () {
                  if (widget.onNavigateToRewards != null) {
                    widget.onNavigateToRewards!();
                  } else {
                    NavigationService.navigateTo(
                      Routes.rewardsPointDetailsScreen,
                    );
                  }
                },
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 12.w,
                    vertical: 8.h,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E222B),
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ShaderMask(
                        shaderCallback: (bounds) => const LinearGradient(
                          colors: [
                            AppColors.primaryColorFirst,
                            AppColors.primaryColorSecond,
                          ],
                        ).createShader(bounds),
                        blendMode: BlendMode.srcIn,
                        child: Image.asset(
                          Assets.icons.pointIcon.path,
                          width: 18.w,
                          height: 18.w,
                          color: Colors.white,
                        ),
                      ),
                      UIHelper.horizontalSpace(6.w),
                      RichText(
                        text: TextSpan(
                          text: "$points ",
                          style: TextFontStyle.textStyle14cFFFFFFSFPro590
                              .copyWith(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w600,
                                color: AppColors.primaryColorSecond,
                              ),
                          children: [
                            TextSpan(
                              text: "pts",
                              style: TextFontStyle.textStyle14cFFFFFFSFPro590
                                  .copyWith(
                                    fontSize: 11.sp,
                                    fontWeight: FontWeight.w400,
                                    color: AppColors.primaryColorSecond
                                        .withValues(alpha: 0.8),
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              UIHelper.horizontalSpace(12.w),
              GestureDetector(
                onTap: () {
                  NavigationService.navigateTo(Routes.notificationScreen);
                },
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Image.asset(
                      Assets.icons.notificationIcon.path,
                      width: 24.w,
                      height: 24.w,
                      color: Colors.white,
                    ),
                    Positioned(
                      top: -2.h,
                      right: -2.w,
                      child: Container(
                        padding: EdgeInsets.all(4.w),
                        decoration: const BoxDecoration(
                          color: Color(0xFFF28F31),
                          shape: BoxShape.circle,
                        ),
                        constraints: BoxConstraints(
                          minWidth: 14.w,
                          minHeight: 14.w,
                        ),
                        child: Center(
                          child: Text(
                            "3",
                            style: TextFontStyle.textStyle14cFFFFFFSFPro590
                                .copyWith(
                                  fontSize: 8.sp,
                                  fontWeight: FontWeight.w700,
                                ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.c121212,
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: _onRefresh,
                  color: const Color(0xFFF28F31),
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        UIHelper.verticalSpace(16.h),
                        // ── Search & Filter Row ──────────────────
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
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
                              style: TextFontStyle
                                  .textStyle14cFFFFFFSFProRounded400
                                  .copyWith(color: Colors.white),
                              decoration: InputDecoration(
                                hintText: "Search...",
                                hintStyle: TextFontStyle
                                    .textStyle14cFFFFFFSFProRounded400
                                    .copyWith(
                                      color: Colors.white.withValues(
                                        alpha: 0.4,
                                      ),
                                    ),
                                border: InputBorder.none,
                                isDense: true,
                                contentPadding: EdgeInsets.zero,
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

                  // ── Categories Horizontal List ──────────
                  SizedBox(
                    height: 38.h,
                    child: StreamBuilder<IntrestCategoryModel>(
                      stream: getCategoriesRxObj.getCategoriesData,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                                ConnectionState.waiting &&
                            !snapshot.hasData) {
                          return ListView.builder(
                            scrollDirection: Axis.horizontal,
                            padding: EdgeInsets.symmetric(horizontal: 12.w),
                            itemCount: 5,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: EdgeInsets.only(right: 8.w),
                                child: Shimmer.fromColors(
                                  baseColor: const Color(0xFF1E222B),
                                  highlightColor: Colors.white.withValues(
                                    alpha: 0.05,
                                  ),
                                  child: Container(
                                    width: 80.w,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF1E222B),
                                      borderRadius: BorderRadius.circular(
                                        100.r,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        }

                        final dataList = snapshot.data?.data ?? [];

                        return ListView.builder(
                          scrollDirection: Axis.horizontal,
                          padding: EdgeInsets.symmetric(horizontal: 12.w),
                          itemCount: dataList.length + 1, // +1 for 'All'
                          itemBuilder: (context, index) {
                            final isSelected = _selectedCategoryIndex == index;
                            final categoryName = index == 0
                                ? 'All'
                                : (dataList[index - 1].name ?? 'Unknown');
                            return Padding(
                              padding: EdgeInsets.only(right: 8.w),
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _selectedCategoryIndex = index;
                                  });
                                  final categoryId = index == 0
                                      ? null
                                      : dataList[index - 1].id;
                                  final authMeData =
                                      authMeRxObj.authMeData.valueOrNull?.data;
                                  getEventsByCategoryRxObj.fetchEvents(
                                    categoryId: categoryId,
                                    seed: authMeData?.id,
                                  );
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 20.w,
                                  ),
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? AppColors.cA8FF8E
                                        : const Color(0xFF1E222B),
                                    borderRadius: BorderRadius.circular(100.r),
                                    border: Border.all(
                                      color: isSelected
                                          ? Colors.transparent
                                          : Colors.white.withValues(
                                              alpha: 0.05,
                                            ),
                                      width: 1.w,
                                    ),
                                  ),
                                  child: Center(
                                    child: Text(
                                      categoryName,
                                      style: TextFontStyle
                                          .textStyle14cFFFFFFSFProRounded400
                                          .copyWith(
                                            color: isSelected
                                                ? Colors.black
                                                : Colors.white.withValues(
                                                    alpha: 0.7,
                                                  ),
                                            fontWeight: isSelected
                                                ? FontWeight.w600
                                                : FontWeight.w400,
                                          ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                  UIHelper.verticalSpace(24.h),

                  // ── Popular Events List ─────────────────
                  const PopularEventsList(),
                  UIHelper.verticalSpace(24.h),

                  // ── Dynamic Category Lists ──────────────
                  StreamBuilder<IntrestCategoryModel>(
                    stream: getCategoriesRxObj.getCategoriesData,
                    builder: (context, snapshot) {
                      final dataList = snapshot.data?.data ?? [];
                      final authMeData =
                          authMeRxObj.authMeData.valueOrNull?.data;

                      return ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        padding: EdgeInsets.zero,
                        itemCount: dataList.length,
                        itemBuilder: (context, index) {
                          final category = dataList[index];
                          if (category.id == null) {
                            return const SizedBox.shrink();
                          }

                          return CategoryEventsRow(
                            key: ValueKey('${category.id}_$_refreshTimestamp'),
                            categoryId: category.id!,
                            categoryName: category.name ?? 'Events',
                            seed: authMeData?.id,
                          );
                        },
                      );
                    },
                  ),
                  const NearbyEventsMap(),
                ],
              ),
            ),
          ),
        ),
      ],
    ),
  ),
),
    );
  }
}
