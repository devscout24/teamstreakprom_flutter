import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../common_widgets/custom_app_bar.dart';
import '../../../common_widgets/gradient_container.dart';
import '../../../constants/text_font_style.dart';
import '../../../gen/colors.gen.dart';
import '../../../helpers/ui_helpers.dart';
import '../../../helpers/all_routes.dart';
import '../../../helpers/navigation_service.dart';
import '../../../networks/api_acess.dart';
import '../model/my_support_tickets_model.dart';

class HelpSupportScreen extends StatefulWidget {
  const HelpSupportScreen({super.key});

  @override
  State<HelpSupportScreen> createState() => _HelpSupportScreenState();
}

class _HelpSupportScreenState extends State<HelpSupportScreen> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchTickets();
  }

  Future<void> _fetchTickets() async {
    setState(() {
      _isLoading = true;
    });
    try {
      await getMyTicketsRxObj.fetchMyTickets();
    } catch (_) {
      // Error handled by rx
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _onRefresh() async {
    try {
      await getMyTicketsRxObj.fetchMyTickets();
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldColor,
      appBar: const CustomAppBar(title: "My Support"),
      body: StreamBuilder<MySupportTicketsModel>(
        stream: getMyTicketsRxObj.getMyTicketsData,
        builder: (context, snapshot) {
          if (_isLoading && (!snapshot.hasData || snapshot.data?.data == null)) {
            return const Center(
              child: CircularProgressIndicator(
                color: AppColors.primaryColorFirst,
              ),
            );
          }

          if (snapshot.hasError &&
              (!snapshot.hasData || snapshot.data?.data == null)) {
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
                    style: TextFontStyle.textStyle14cFFFFFFSFProRounded400
                        .copyWith(
                          fontFamily: 'SF Pro',
                          fontSize: 16.sp,
                          color: Colors.white.withValues(alpha: 0.4),
                        ),
                  ),
                  UIHelper.verticalSpace(12.h),
                  TextButton(
                    onPressed: _fetchTickets,
                    child: const Text(
                      'Try Again',
                      style: TextStyle(color: AppColors.primaryColorFirst),
                    ),
                  ),
                ],
              ),
            );
          }

          final tickets = snapshot.data?.data ?? [];

          if (tickets.isEmpty) {
            return RefreshIndicator(
              color: AppColors.primaryColorFirst,
              backgroundColor: AppColors.scaffoldColor,
              onRefresh: _onRefresh,
              child: CustomScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                slivers: [
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: Center(
                      child: Text(
                        'No support tickets found',
                        style: TextFontStyle.textStyle14cFFFFFFSFProRounded400
                            .copyWith(
                              fontFamily: 'SF Pro',
                              fontSize: 15.sp,
                              color: Colors.white.withValues(alpha: 0.5),
                            ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            color: AppColors.primaryColorFirst,
            backgroundColor: AppColors.scaffoldColor,
            onRefresh: _onRefresh,
            child: ListView.separated(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
              itemCount: tickets.length,
              separatorBuilder: (context, index) =>
                  UIHelper.verticalSpace(16.h),
              itemBuilder: (context, index) {
                final ticket = tickets[index];
                return _buildTicketItem(
                  title: ticket.title ?? '',
                  description: ticket.description ?? '',
                  ticketId: ticket.ticketId ?? '',
                  status: ticket.statusLabel ??
                      ticket.statusBadge?.text ??
                      ticket.status ??
                      'Under review',
                  statusColor: ticket.resolvedStatusColor,
                  onTap: () async {
                    await NavigationService.navigateToWithArgs(
                      Routes.supportChatScreen,
                      {
                        'ticketId': ticket.id ?? ticket.ticketId ?? '',
                        'topic': ticket.title ?? '',
                        'problem': ticket.description ?? '',
                      },
                    );
                    _fetchTickets();
                  },
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: GestureDetector(
        onTap: () async {
          await NavigationService.navigateTo(Routes.supportOptionsScreen);
          _fetchTickets();
        },
        child: Container(
          width: 60,
          height: 60,
          padding: const EdgeInsets.all(15),
          decoration: ShapeDecoration(
            gradient: LinearGradient(
              begin: const Alignment(0.50, -0.37),
              end: const Alignment(0.50, 1.24),
              colors: [
                const Color(0xFFF28F31).withValues(alpha: 0.10),
                const Color(0xFF72E84F).withValues(alpha: 0.10),
              ],
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 30,
                height: 30,
                clipBehavior: Clip.antiAlias,
                decoration: const BoxDecoration(),
                child: const Icon(
                  Icons.headset_mic_outlined,
                  color: Colors.white,
                  size: 28,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTicketItem({
    required String title,
    required String description,
    required String ticketId,
    required String status,
    required Color statusColor,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: GradientContainer(
        padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextFontStyle.textStyle16c000000SFPro590.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 14.sp,
            ),
          ),
          UIHelper.verticalSpace(12.h),
          Text(
            description,
            style: TextFontStyle.textStyle14cFFFFFFSFProRounded400.copyWith(
              color: AppColors.cBCBCBB,
              fontFamily: "SF Pro",
              fontSize: 12.sp,
              height: 1.5,
            ),
          ),
          UIHelper.verticalSpace(16.h),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text(
                      "Ticket ID : ",
                      style: TextFontStyle.textStyle14cFFFFFFSFProRounded400
                          .copyWith(color: AppColors.c9B9C9A, fontSize: 12.sp),
                    ),
                    Text(
                      ticketId,
                      style: TextFontStyle.textStyle14cFFFFFFSFProRounded400
                          .copyWith(
                            color: AppColors.cFFF9F3,
                            fontWeight: FontWeight.w400,
                            fontSize: 10.sp,
                          ),
                    ),
                  ],
                ),
                Container(
                  width: 1.w,
                  height: 14.h,
                  color: AppColors.c9B9C9A.withValues(alpha: 0.3),
                ),
                Row(
                  children: [
                    Text(
                      "Status ",
                      style: TextFontStyle.textStyle14cFFFFFFSFProRounded400
                          .copyWith(color: AppColors.c9B9C9A, fontSize: 12.sp),
                    ),
                    UIHelper.horizontalSpace(4.w),
                    Container(
                      width: 6.w,
                      height: 6.w,
                      decoration: BoxDecoration(
                        color: statusColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                    UIHelper.horizontalSpace(6.w),
                    Text(
                      status,
                      style: TextFontStyle.textStyle14cFFFFFFSFProRounded400
                          .copyWith(
                            color: statusColor,
                            fontSize: 10.sp,
                            fontWeight: FontWeight.w500,
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


