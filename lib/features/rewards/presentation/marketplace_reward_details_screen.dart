import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import '../../../constants/text_font_style.dart';
import '../../../gen/colors.gen.dart';
import '../../../helpers/ui_helpers.dart';
import '../../../common_widgets/gradient_container.dart';
import '../../../common_widgets/custom_back_button.dart';
import '../../../common_widgets/swipe_to_action_button.dart';
import '../widgets/confirm_redeem_bottom_sheet.dart';
import '../model/get_marketplaces_model.dart';
import 'package:shimmer/shimmer.dart';

class MarketplaceRewardDetailsScreen extends StatefulWidget {
  final String? rewardName;
  final String? rewardLocation;
  final String? dateTime;
  final String? rewardOrganizer;
  final String? rewardId;
  final MarketplaceItem? item;

  const MarketplaceRewardDetailsScreen({
    super.key,
    this.rewardName,
    this.rewardLocation,
    this.dateTime,
    this.rewardOrganizer,
    this.rewardId,
    this.item,
  });

  @override
  State<MarketplaceRewardDetailsScreen> createState() =>
      _MarketplaceRewardDetailsScreenState();
}

class _MarketplaceRewardDetailsScreenState
    extends State<MarketplaceRewardDetailsScreen> {
  Future<void> _showConfirmRedeemSheet() async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const ConfirmRedeemBottomSheet(),
    );
  }

  String get _rewardName =>
      widget.item?.title ?? widget.rewardName ?? "N/A";

  String get _rewardLocation =>
      widget.item?.location ?? widget.rewardLocation ?? "N/A";

  String get _dateTime {
    if (widget.item?.endDateTime != null) {
      return DateFormat("MMM dd, yyyy • hh:mm a")
          .format(widget.item!.endDateTime!);
    }
    if (widget.item?.startDateTime != null) {
      return DateFormat("MMM dd, yyyy • hh:mm a")
          .format(widget.item!.startDateTime!);
    }
    if (widget.dateTime != null && widget.dateTime!.isNotEmpty) {
      return widget.dateTime!;
    }
    return "N/A";
  }

  String get _rewardOrganizer {
    if (widget.item?.category?.name != null &&
        widget.item!.category!.name!.isNotEmpty) {
      return widget.item!.category!.name!;
    }
    if (widget.item?.subCategory?.name != null &&
        widget.item!.subCategory!.name!.isNotEmpty) {
      return widget.item!.subCategory!.name!;
    }
    if (widget.rewardOrganizer != null &&
        widget.rewardOrganizer!.isNotEmpty) {
      return widget.rewardOrganizer!;
    }
    return "N/A";
  }

  String get _rewardId =>
      widget.item?.id ?? widget.rewardId ?? "N/A";

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
      body: SingleChildScrollView(
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
                  _buildDetailRow("Reward", _rewardName),
                  UIHelper.verticalSpace(12.h),
                  _buildDetailRow("Reward Location", _rewardLocation),
                  UIHelper.verticalSpace(12.h),
                  _buildDetailRow("Date & Time", _dateTime),
                  UIHelper.verticalSpace(12.h),
                  _buildDetailRow("Reward Organizer", _rewardOrganizer),
                  UIHelper.verticalSpace(12.h),
                  _buildDetailRow("Reward ID", _rewardId),
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
