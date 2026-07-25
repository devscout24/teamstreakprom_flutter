import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../gen/colors.gen.dart';
import '../../../gen/assets.gen.dart';
import '../../../constants/text_font_style.dart';
import '../../../helpers/ui_helpers.dart';
import '../../../common_widgets/custom_gradient_button.dart';
import '../../../common_widgets/ticket_toggle_button.dart';
import '../widgets/product_details_bottom_sheet.dart';
import '../widgets/invite_friend_bottom_sheet.dart';

class EventDetailsScreen extends StatefulWidget {
  final String title;
  final String location;
  final String date;
  final String price;
  final String imageUrl;
  final String description;
  final String? points;
  final bool isReward;

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
  });

  @override
  State<EventDetailsScreen> createState() => _EventDetailsScreenState();
}

class _EventDetailsScreenState extends State<EventDetailsScreen> {
  int _selectedTabIndex = 0; // 0: Event Info, 1: Reward Info
  int _ticketCount = 4;
  int _currentCarouselIndex = 0;
  final PageController _pageController = PageController();
  Timer? _carouselTimer;
  int? _selectedRewardProductIndex;

  // Mock list of carousel images
  late final List<String> _carouselImages;

  @override
  void initState() {
    super.initState();
    _selectedTabIndex = widget.isReward ? 1 : 0;
    _carouselImages = [
      widget.imageUrl,
      "https://images.unsplash.com/photo-1470225620780-dba8ba36b745?auto=format&fit=crop&w=600&q=80",
      "https://images.unsplash.com/photo-1511192336575-5a79af67a629?auto=format&fit=crop&w=600&q=80",
    ];

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

  @override
  void dispose() {
    _carouselTimer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  void _redeemRewardDirectly() {
    // Direct redemption logic (no toast/dialog notifications)
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
        content: Text(
          "Successfully booked $_ticketCount tickets for ${widget.title}!",
          style: TextFontStyle.textStyle14cFFFFFFSFProRounded400.copyWith(
            color: Colors.white.withValues(alpha: 0.8),
          ),
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

  Widget _buildSocialIcon(IconData icon) {
    return Container(
      width: 28.w,
      height: 28.w,
      margin: EdgeInsets.only(right: 12.w),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
      ),
      child: Center(
        child: Icon(icon, size: 14.sp, color: Colors.white),
      ),
    );
  }

  Widget _buildTextSocialIcon(String label) {
    return Container(
      width: 28.w,
      height: 28.w,
      margin: EdgeInsets.only(right: 12.w),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
      ),
      child: Center(
        child: Text(
          label,
          style: TextFontStyle.textStyle14cFFFFFFSFProRounded400.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 11.sp,
            fontFamily: 'SF Pro',
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldColor,
      body: SingleChildScrollView(
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
                  // Top back & share bar
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: SafeArea(
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                          vertical: 8.h,
                        ),
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
                          width: _currentCarouselIndex == index ? 20.w : 8.w,
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
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title and Category Badge row
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          widget.title,
                          style: TextFontStyle.textStyle24cFFFFFFSFPro590
                              .copyWith(
                                fontSize: 22.sp,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ),
                      UIHelper.horizontalSpace(12.w),
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
                          "Music",
                          style: TextFontStyle.textStyle14cFFFFFFSFProRounded400
                              .copyWith(
                                color: AppColors.primaryColorSecond,
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w600,
                              ),
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
                        widget.location,
                        style: TextFontStyle.textStyle14cFFFFFFSFProRounded400
                            .copyWith(
                              color: Colors.white.withValues(alpha: 0.6),
                              fontSize: 13.sp,
                            ),
                      ),
                    ],
                  ),
                  UIHelper.verticalSpace(24.h),

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
                    // ── Event Info Tab Content ──
                    Text(
                      "Description",
                      style: TextFontStyle.textStyle24cFFFFFFSFPro590.copyWith(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    UIHelper.verticalSpace(8.h),
                    Text(
                      widget.description,
                      style: TextFontStyle.textStyle14cFFFFFFSFProRounded400
                          .copyWith(
                            color: Colors.white.withValues(alpha: 0.7),
                            fontSize: 13.sp,
                            height: 1.5,
                          ),
                    ),
                    UIHelper.verticalSpace(24.h),

                    // Divider line
                    Divider(color: Colors.white.withValues(alpha: 0.08)),
                    UIHelper.verticalSpace(16.h),

                    Text(
                      "Artist Info",
                      style: TextFontStyle.textStyle24cFFFFFFSFPro590.copyWith(
                        fontSize: 14.sp,
                        color: AppColors.c848484,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    UIHelper.verticalSpace(12.h),

                    // Artist profile card
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 24.r,
                          backgroundImage: const NetworkImage(
                            "https://images.unsplash.com/photo-1500648767791-00dcc994a43e?auto=format&fit=crop&w=150&q=80",
                          ),
                        ),
                        UIHelper.horizontalSpace(12.w),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Adam Levine",
                              style: TextFontStyle
                                  .textStyle14cFFFFFFSFProRounded400
                                  .copyWith(
                                    color: Colors.white,
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
                            ),
                            UIHelper.verticalSpace(4.h),
                            Text(
                              "Singer",
                              style: TextFontStyle
                                  .textStyle14cFFFFFFSFProRounded400
                                  .copyWith(
                                    color: Colors.white.withValues(alpha: 0.8),
                                    fontSize: 12.sp,
                                  ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    UIHelper.verticalSpace(16.h),

                    // Social links row
                    Row(
                      children: [
                        Text(
                          "Media Link:",
                          style: TextFontStyle.textStyle14cFFFFFFSFProRounded400
                              .copyWith(
                                color: Colors.white.withValues(alpha: 0.8),
                                fontSize: 12.sp,
                                fontFamily: "SF Pro",
                              ),
                        ),
                        UIHelper.horizontalSpace(12.w),
                        _buildSocialIcon(Icons.facebook),
                        _buildSocialIcon(Icons.send_rounded), // Telegram
                        _buildSocialIcon(
                          Icons.play_circle_outline_rounded,
                        ), // YouTube
                        _buildTextSocialIcon("d"), // TikTok
                        _buildTextSocialIcon("𝕏"), // X
                        _buildSocialIcon(
                          Icons.camera_alt_outlined,
                        ), // Instagram
                      ],
                    ),
                    UIHelper.verticalSpace(24.h),

                    // Timeline Alert container box
                    Container(
                      padding: EdgeInsets.all(16.w),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            AppColors.primaryColorFirst.withValues(alpha: 0.1),
                            AppColors.primaryColorSecond.withValues(alpha: 0.1),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(16.r),
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              RichText(
                                text: TextSpan(
                                  text: "End Date : ",
                                  style: TextFontStyle
                                      .textStyle14cFFFFFFSFProRounded400
                                      .copyWith(
                                        color: Colors.white.withValues(
                                          alpha: 0.6,
                                        ),
                                        fontSize: 13.sp,
                                        fontFamily: 'SF Pro',
                                      ),
                                  children: [
                                    TextSpan(
                                      text: "Aug 28, 2026",
                                      style: TextFontStyle
                                          .textStyle14cFFFFFFSFProRounded400
                                          .copyWith(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w700,
                                            fontSize: 13.sp,
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                              Text(
                                "7h 32m left",
                                style: TextFontStyle
                                    .textStyle14cFFFFFFSFProRounded400
                                    .copyWith(
                                      color: AppColors.primaryColorFirst,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 13.sp,
                                    ),
                              ),
                            ],
                          ),
                          UIHelper.verticalSpace(12.h),
                          Row(
                            children: [
                              Icon(
                                Icons.info_outline,
                                color: AppColors.primaryColorFirst,
                                size: 16.sp,
                              ),
                              UIHelper.horizontalSpace(8.w),
                              Expanded(
                                child: Text(
                                  "This event is only for who are above 18 years old.",
                                  style: TextFontStyle
                                      .textStyle14cFFFFFFSFProRounded400
                                      .copyWith(
                                        color: AppColors.primaryColorFirst,
                                        fontSize: 11.sp,
                                      ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    UIHelper.verticalSpace(24.h),

                    // Host section
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 24.r,
                          backgroundImage: const NetworkImage(
                            "https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&w=150&q=80",
                          ),
                        ),
                        UIHelper.horizontalSpace(12.w),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Adam Levine",
                              style: TextFontStyle
                                  .textStyle14cFFFFFFSFProRounded400
                                  .copyWith(
                                    color: Colors.white,
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: "SF Pro",
                                  ),
                            ),
                            UIHelper.verticalSpace(4.h),
                            Text(
                              "Host",
                              style: TextFontStyle
                                  .textStyle14cFFFFFFSFProRounded400
                                  .copyWith(
                                    color: Colors.white.withValues(alpha: 0.8),
                                    fontSize: 12.sp,
                                  ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    UIHelper.verticalSpace(16.h),

                    // Seat info line
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.confirmation_num_outlined,
                              color: Colors.white.withValues(alpha: 0.6),
                              size: 16.sp,
                            ),
                            UIHelper.horizontalSpace(6.w),
                            Text(
                              "Buy this ticket & get 1 point",
                              style: TextFontStyle
                                  .textStyle14cFFFFFFSFProRounded400
                                  .copyWith(
                                    color: Colors.white.withValues(alpha: 0.8),
                                    fontSize: 12.sp,
                                  ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Icon(
                              Icons.event_seat,
                              color: AppColors.cDC822D,
                              size: 16.sp,
                            ),
                            UIHelper.horizontalSpace(6.w),
                            Text(
                              "4 seat remaining",
                              style: TextFontStyle
                                  .textStyle14cFFFFFFSFProRounded400
                                  .copyWith(
                                    color: AppColors.cDC822D,
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    UIHelper.verticalSpace(24.h),

                    // Location Section with map
                    Text(
                      "Location:",
                      style: TextFontStyle.textStyle24cFFFFFFSFPro590.copyWith(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    UIHelper.verticalSpace(12.h),

                    // Map container
                    Container(
                      height: 180.h,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16.r),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16.r),
                        child: Assets.images.mapEvent.image(fit: BoxFit.cover),
                      ),
                    ),
                    UIHelper.verticalSpace(24.h),

                    // Refer section
                    Container(
                      height: 52.h,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100.r),
                        gradient: const LinearGradient(
                          colors: [
                            AppColors.primaryColorFirst,
                            AppColors.primaryColorSecond,
                          ],
                        ),
                      ),
                      padding: EdgeInsets.all(1.w),
                      child: Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFF171A20),
                          borderRadius: BorderRadius.circular(100.r),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          "Refer your friend",
                          style: TextFontStyle.textStyle14cFFFFFFSFProRounded400
                              .copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 15.sp,
                                fontFamily: "SF Pro",
                              ),
                        ),
                      ),
                    ),
                    UIHelper.verticalSpace(12.h),
                    Row(
                      children: [
                        Icon(
                          Icons.info_outline,
                          color: AppColors.primaryColorFirst,
                          size: 16.sp,
                        ),
                        UIHelper.horizontalSpace(8.w),
                        Expanded(
                          child: Text(
                            "You'll receive 1 point only after your friend purchases a ticket.",
                            style: TextFontStyle
                                .textStyle14cFFFFFFSFProRounded400
                                .copyWith(
                                  color: AppColors.primaryColorFirst,
                                  fontSize: 11.sp,
                                ),
                          ),
                        ),
                      ],
                    ),
                  ] else ...[
                    // ── Reward Info Tab Content (Product List) ──
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: EdgeInsets.zero,
                      itemCount: _rewardProducts.length,
                      itemBuilder: (context, index) {
                        return _buildRewardProductCard(
                          _rewardProducts[index],
                          index,
                        );
                      },
                    ),
                  ],
                ],
              ),
            ),

            // ── Bottom Actions ──────────────────────────────────────────────
            Container(
              padding: EdgeInsets.fromLTRB(24.w, 16.h, 24.w, 36.h),
              decoration: BoxDecoration(
                color: const Color(0xFF13151B),
                border: Border(
                  top: BorderSide(
                    color: Colors.white.withValues(alpha: 0.05),
                    width: 1.h,
                  ),
                ),
              ),
              child: _selectedTabIndex == 0
                  ? Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Quantity & Price Info Row
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Quantity Counter
                            Container(
                              height: 48.h,
                              padding: EdgeInsets.symmetric(horizontal: 8.w),
                              decoration: BoxDecoration(
                                color: const Color(0xFF1E222B),
                                borderRadius: BorderRadius.circular(100.r),
                                border: Border.all(
                                  color: Colors.white.withValues(alpha: 0.05),
                                  width: 1.w,
                                ),
                              ),
                              child: Row(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      if (_ticketCount > 1) {
                                        setState(() {
                                          _ticketCount--;
                                        });
                                      }
                                    },
                                    child: Container(
                                      width: 32.h,
                                      height: 32.h,
                                      decoration: const BoxDecoration(
                                        color: Color(0xFF262A34),
                                        shape: BoxShape.circle,
                                      ),
                                      child: Icon(
                                        Icons.remove,
                                        color: Colors.white,
                                        size: 16.sp,
                                      ),
                                    ),
                                  ),
                                  UIHelper.horizontalSpace(16.w),
                                  Text(
                                    "$_ticketCount",
                                    style: TextFontStyle
                                        .textStyle14cFFFFFFSFProRounded400
                                        .copyWith(
                                          color: Colors.white,
                                          fontSize: 16.sp,
                                          fontWeight: FontWeight.bold,
                                        ),
                                  ),
                                  UIHelper.horizontalSpace(16.w),
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        _ticketCount++;
                                      });
                                    },
                                    child: Container(
                                      width: 32.h,
                                      height: 32.h,
                                      decoration: const BoxDecoration(
                                        color: Color(0xFF262A34),
                                        shape: BoxShape.circle,
                                      ),
                                      child: Icon(
                                        Icons.add,
                                        color: Colors.white,
                                        size: 16.sp,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // Price Container
                            Container(
                              height: 48.h,
                              padding: EdgeInsets.symmetric(horizontal: 20.w),
                              decoration: BoxDecoration(
                                color: const Color(0xFF1E222B),
                                borderRadius: BorderRadius.circular(100.r),
                                border: Border.all(
                                  color: Colors.white.withValues(alpha: 0.05),
                                  width: 1.w,
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Image.asset(
                                    Assets.icons.ticketIcon.path,
                                    width: 18.w,
                                    height: 18.w,
                                    color: Colors.white,
                                  ),
                                  UIHelper.horizontalSpace(8.w),
                                  Text(
                                    "\$${199 * _ticketCount}",
                                    style: TextFontStyle
                                        .textStyle14cFFFFFFSFProRounded400
                                        .copyWith(
                                          color: Colors.white,
                                          fontSize: 18.sp,
                                          fontWeight: FontWeight.bold,
                                        ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        UIHelper.verticalSpace(16.h),

                        // Get Ticket Button
                        CustomGradientButton(
                          onPressed: _showBookingSuccessDialog,
                          title: "Buy a Ticket",
                          borderRadius: BorderRadius.circular(100.r),
                          textStyle: TextFontStyle
                              .textStyle14cFFFFFFSFProRounded400
                              .copyWith(
                                color: const Color(0xFF262824),
                                fontWeight: FontWeight.w700,
                                fontSize: 16.sp,
                              ),
                        ),
                      ],
                    )
                  : CustomGradientButton(
                      onPressed: _redeemRewardDirectly,
                      title: "Redeem Reward",
                      borderRadius: BorderRadius.circular(100.r),
                      textStyle: TextFontStyle.textStyle14cFFFFFFSFProRounded400
                          .copyWith(
                            color: const Color(0xFF262824),
                            fontWeight: FontWeight.w700,
                            fontSize: 16.sp,
                          ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  final List<RewardProduct> _rewardProducts = const [
    RewardProduct(
      title: "Adidas Courtblock Shoes",
      description:
          "NIKE is a leading athletic shoe brand known for innovation and quality.",
      imageUrls: [
        "https://images.unsplash.com/photo-1542291026-7eec264c27ff?auto=format&fit=crop&w=400&q=80",
        "https://images.unsplash.com/photo-1525966222134-fcfa99b8ae77?auto=format&fit=crop&w=400&q=80",
        "https://images.unsplash.com/photo-1600185365926-3a2ce3cdb9eb?auto=format&fit=crop&w=400&q=80",
      ],
      isStockIn: true,
      points: "95",
    ),
    RewardProduct(
      title: "Adidas Courtblock Shoes",
      description:
          "NIKE is a leading athletic shoe brand known for innovation and quality.",
      imageUrls: [
        "https://images.unsplash.com/photo-1525966222134-fcfa99b8ae77?auto=format&fit=crop&w=400&q=80",
        "https://images.unsplash.com/photo-1542291026-7eec264c27ff?auto=format&fit=crop&w=400&q=80",
        "https://images.unsplash.com/photo-1600185365926-3a2ce3cdb9eb?auto=format&fit=crop&w=400&q=80",
      ],
      isStockIn: false,
      points: "95",
    ),
    RewardProduct(
      title: "Adidas Courtblock Shoes",
      description:
          "NIKE is a leading athletic shoe brand known for innovation and quality.",
      imageUrls: [
        "https://images.unsplash.com/photo-1600185365926-3a2ce3cdb9eb?auto=format&fit=crop&w=400&q=80",
        "https://images.unsplash.com/photo-1542291026-7eec264c27ff?auto=format&fit=crop&w=400&q=80",
        "https://images.unsplash.com/photo-1525966222134-fcfa99b8ae77?auto=format&fit=crop&w=400&q=80",
      ],
      isStockIn: true,
      points: "95",
    ),
  ];

  Widget _buildRewardProductCard(RewardProduct product, int index) {
    final bool isSelected = _selectedRewardProductIndex == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedRewardProductIndex = index;
        });
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 16.h),
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: const Color(0xFF1E222B),
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: isSelected
                ? const Color(0xFFFFA500)
                : Colors.white.withValues(alpha: 0.05),
            width: 1.w,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product image
            GestureDetector(
              onTap: () {
                setState(() {
                  _selectedRewardProductIndex = index;
                });
                showProductDetailsBottomSheet(
                  context: context,
                  product: product,
                  location: widget.location,
                  onContinueToPay: _redeemRewardDirectly,
                );
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12.r),
                child: Image.network(
                  product.imageUrls.first,
                  width: 80.w,
                  height: 80.w,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            UIHelper.horizontalSpace(16.w),
            // Product info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.title,
                    style: TextFontStyle.textStyle14cFFFFFFSFProRounded400
                        .copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 15.sp,
                        ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  UIHelper.verticalSpace(4.h),
                  Text(
                    product.description,
                    style: TextFontStyle.textStyle14cFFFFFFSFProRounded400
                        .copyWith(
                          color: Colors.white.withValues(alpha: 0.5),
                          fontSize: 12.sp,
                          height: 1.3,
                        ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  UIHelper.verticalSpace(8.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        product.isStockIn ? "Stock In" : "Stock Out",
                        style: TextFontStyle.textStyle14cFFFFFFSFProRounded400
                            .copyWith(
                              color: product.isStockIn
                                  ? AppColors.primaryColorSecond
                                  : const Color(0xFFDD1F1F),
                              fontWeight: FontWeight.bold,
                              fontSize: 13.sp,
                            ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 10.w,
                          vertical: 6.h,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(100.r),
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
                                width: 14.w,
                                height: 14.w,
                                color: Colors.white,
                              ),
                            ),
                            UIHelper.horizontalSpace(6.w),
                            Text(
                              "${product.points} pts",
                              style: TextFontStyle
                                  .textStyle14cFFFFFFSFProRounded400
                                  .copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12.sp,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class RewardProduct {
  final String title;
  final String description;
  final List<String> imageUrls;
  final bool isStockIn;
  final String points;

  const RewardProduct({
    required this.title,
    required this.description,
    required this.imageUrls,
    required this.isStockIn,
    required this.points,
  });
}
