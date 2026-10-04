import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import '../../../constants/text_font_style.dart';
import '../../../gen/colors.gen.dart';
import '../../../helpers/ui_helpers.dart';
import '../../../common_widgets/gradient_container.dart';
import '../../../common_widgets/custom_back_button.dart';
import '../../../common_widgets/swipe_to_action_button.dart';
import '../../../networks/api_acess.dart';
import '../widgets/confirm_redeem_bottom_sheet.dart';
import '../model/get_marketplaces_model.dart';
import '../model/my_reward_order_details_model.dart';

class MarketplaceRewardDetailsScreen extends StatefulWidget {
  final String? rewardName;
  final String? rewardLocation;
  final String? dateTime;
  final String? rewardOrganizer;
  final String? rewardId;
  final String? orderId;
  final MarketplaceItem? item;

  const MarketplaceRewardDetailsScreen({
    super.key,
    this.rewardName,
    this.rewardLocation,
    this.dateTime,
    this.rewardOrganizer,
    this.rewardId,
    this.orderId,
    this.item,
  });

  @override
  State<MarketplaceRewardDetailsScreen> createState() =>
      _MarketplaceRewardDetailsScreenState();
}

class _MarketplaceRewardDetailsScreenState
    extends State<MarketplaceRewardDetailsScreen> {
  bool _isLoading = false;

  String? get _effectiveOrderId => widget.orderId ?? widget.rewardId;

  @override
  void initState() {
    super.initState();
    final id = _effectiveOrderId;
    if (id != null && id.isNotEmpty) {
      _isLoading = true;
      getRewardOrderDetailsRxObj.clean();
      getRewardOrderDetailsRxObj.fetchRewardOrderDetails(id).whenComplete(() {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      });
    }
  }

  Future<void> _showConfirmRedeemSheet() async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const ConfirmRedeemBottomSheet(),
    );
  }

  String _formatDateTime(DateTime? dt) {
    if (dt == null) return "N/A";
    try {
      return DateFormat("MMM dd, yyyy • hh:mm a").format(dt.toLocal());
    } catch (_) {
      return dt.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldColor,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: Padding(
          padding: EdgeInsets.all(8.r),
          child: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: const CustomBackButton(),
            title: Text(
              "Reward Info",
              style: TextFontStyle.textStyle24cFFFFFFSFPro590.copyWith(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            centerTitle: true,
          ),
        ),
      ),
      body: StreamBuilder<MyRewardOrderDetailsModel>(
        stream: getRewardOrderDetailsRxObj.getRewardOrderDetailsData,
        builder: (context, snapshot) {
          if (_isLoading &&
              (!snapshot.hasData || snapshot.data?.data == null)) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.orange),
            );
          }

          final orderData = snapshot.data?.data;
          final itemData = orderData?.item ?? orderData?.itemId;

          final rewardName = itemData?.title ??
              widget.item?.title ??
              widget.rewardName ??
              "N/A";

          final rewardLocation = itemData?.location ??
              widget.item?.location ??
              widget.rewardLocation ??
              "N/A";

          String formattedDateTime = "N/A";
          if (itemData?.endDateTime != null) {
            formattedDateTime = _formatDateTime(itemData!.endDateTime);
          } else if (itemData?.startDateTime != null) {
            formattedDateTime = _formatDateTime(itemData!.startDateTime);
          } else if (orderData?.createdAt != null) {
            formattedDateTime = _formatDateTime(orderData!.createdAt);
          } else if (widget.item?.endDateTime != null) {
            formattedDateTime = _formatDateTime(widget.item!.endDateTime);
          } else if (widget.item?.startDateTime != null) {
            formattedDateTime = _formatDateTime(widget.item!.startDateTime);
          } else if (widget.dateTime != null && widget.dateTime!.isNotEmpty) {
            formattedDateTime = widget.dateTime!;
          }

          final rewardOrganizer = orderData?.businessOwnerId?.name ??
              (widget.item?.category?.name != null &&
                      widget.item!.category!.name!.isNotEmpty
                  ? widget.item!.category!.name!
                  : (widget.item?.subCategory?.name != null &&
                          widget.item!.subCategory!.name!.isNotEmpty
                      ? widget.item!.subCategory!.name!
                      : (widget.rewardOrganizer != null &&
                              widget.rewardOrganizer!.isNotEmpty
                          ? widget.rewardOrganizer!
                          : "N/A")));

          final rewardId =
              orderData?.id ?? widget.item?.id ?? widget.rewardId ?? "N/A";

          return SingleChildScrollView(
            padding: EdgeInsets.all(16.w),
            child: Column(
              children: [
                // The main ticket container
                GradientContainer(
                  width: double.infinity,
                  padding: EdgeInsets.all(16.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildDetailRow("Reward", rewardName),
                      UIHelper.verticalSpace(12.h),
                      _buildDetailRow("Reward Location", rewardLocation),
                      UIHelper.verticalSpace(12.h),
                      _buildDetailRow("Date & Time", formattedDateTime),
                      UIHelper.verticalSpace(12.h),
                      _buildDetailRow("Reward Organizer", rewardOrganizer),
                      UIHelper.verticalSpace(12.h),
                      _buildDetailRow("Reward ID", rewardId),
                    ],
                  ),
                ),
                UIHelper.verticalSpace(16.h),

                // Info Box
                GradientContainer(
                  padding: EdgeInsets.all(16.w),
                  child: Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        color: Colors.white.withValues(alpha: 0.8),
                        size: 20.sp,
                      ),
                      UIHelper.horizontalSpace(12.w),
                      Expanded(
                        child: Text(
                          "This reward can only be redeem from this physical store.",
                          style: TextFontStyle.textStyle14cFFFFFFSFProRounded400
                              .copyWith(
                                color: Colors.white.withValues(alpha: 0.8),
                                fontSize: 12.sp,
                              ),
                        ),
                      ),
                    ],
                  ),
                ),
                UIHelper.verticalSpace(24.h),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(left: 16.w, right: 16.w, bottom: 24.h),
          child: SwipeToActionButton(
            text: "Swipe right to Redeem Reward",
            onAction: _showConfirmRedeemSheet,
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(
    String title,
    String value, {
    bool alignRight = false,
  }) {
    return Column(
      crossAxisAlignment: alignRight
          ? CrossAxisAlignment.end
          : CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextFontStyle.textStyle14cFFFFFFSFProRounded400.copyWith(
            color: Colors.white.withValues(alpha: 0.5),
            fontSize: 12.sp,
            fontFamily: "SF Pro",
          ),
        ),
        UIHelper.verticalSpace(10.h),
        Text(
          value,
          style: TextFontStyle.textStyle14cFFFFFFSFProRounded400.copyWith(
            color: AppColors.cFFFFFF.withValues(alpha: 0.8),
            fontSize: 16.sp,
            fontWeight: FontWeight.w500,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          textAlign: alignRight ? TextAlign.right : TextAlign.left,
        ),
        UIHelper.verticalSpace(12.h),
        CustomPaint(
          size: Size(double.infinity, 1.w),
          painter: _DashedLinePainter(
            color: Colors.white.withValues(alpha: 0.2),
          ),
        ),
      ],
    );
  }
}

// ── Custom Painters ────────────────────────────────────────────────────
class _DashedLinePainter extends CustomPainter {
  final Color color;

  const _DashedLinePainter({
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    const double strokeWidth = 1.0;
    const double dashWidth = 4.0;
    const double dashSpace = 4.0;

    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    double startX = 0;
    while (startX < size.width) {
      canvas.drawLine(Offset(startX, 0), Offset(startX + dashWidth, 0), paint);
      startX += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant _DashedLinePainter oldDelegate) {
    return oldDelegate.color != color;
  }
}
