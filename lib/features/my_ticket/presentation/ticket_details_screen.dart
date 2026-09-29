import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';
import '../../../common_widgets/custom_back_button.dart';
import '../../../common_widgets/custom_gradient_button.dart';
import '../../../common_widgets/gradient_container.dart';
import '../../../constants/text_font_style.dart';
import '../../../gen/assets.gen.dart';
import '../../../gen/colors.gen.dart';
import '../../../helpers/ui_helpers.dart';
import '../../../networks/api_acess.dart';
import '../../../common_widgets/custom_toast.dart';
import '../model/my_orders_response_model.dart';
import '../model/order_details_response_model.dart';
import '../services/ticket_pdf_service.dart';
import '../widgets/cancel_ticket_bottom_sheet.dart';

class TicketDetailsScreen extends StatefulWidget {
  const TicketDetailsScreen({
    super.key,
    this.orderId,
  });

  final String? orderId;

  @override
  State<TicketDetailsScreen> createState() => _TicketDetailsScreenState();
}

class _TicketDetailsScreenState extends State<TicketDetailsScreen> {
  bool _isRefunding = false;
  bool _isDownloading = false;

  @override
  void initState() {
    super.initState();
    if (widget.orderId != null && widget.orderId!.isNotEmpty) {
      getOrderDetailsRxObj.clean();
      getOrderDetailsRxObj.fetchOrderDetails(widget.orderId!);
    }
  }

  Future<void> _refundTicket(String orderId) async {
    setState(() {
      _isRefunding = true;
    });

    try {
      final response =
          await cancelEventOrderRxObj.cancelEventOrder(orderId);
      if (response.success ?? true) {
        final msg = response.message ??
            "Event ticket order cancelled and full refund issued successfully";
        customToastMessage("Success", msg);
        if (widget.orderId != null && widget.orderId!.isNotEmpty) {
          getOrderDetailsRxObj.fetchOrderDetails(widget.orderId!);
        }
        getMyOrdersRxObj.fetchMyOrders();
      }
    } catch (e) {
      // Error handling is in rx layer
    } finally {
      if (mounted) {
        setState(() {
          _isRefunding = false;
        });
      }
    }
  }

  Future<void> _downloadTicket(MyOrderData order) async {
    setState(() {
      _isDownloading = true;
    });

    try {
      final pdfBytes = await TicketPdfService.generateTicketPdf(order);
      final rawTicketId = order.ticketId ?? order.id ?? "ticket";
      final safeTicketId =
          rawTicketId.replaceAll(RegExp(r'[^a-zA-Z0-9_\-]'), '_');
      final fileName = 'ticket_$safeTicketId.pdf';

      final savedFile = await TicketPdfService.saveToDownloads(
        bytes: pdfBytes,
        fileName: fileName,
      );

      customToastMessage(
        "Download Complete",
        "Saved to ${savedFile.path}",
      );
    } catch (e) {
      customToastMessage(
        "Download Failed",
        "Could not download ticket PDF: $e",
        isError: true,
      );
    } finally {
      if (mounted) {
        setState(() {
          _isDownloading = false;
        });
      }
    }
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
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: Padding(
          padding: EdgeInsets.all(8.r),
          child: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: const CustomBackButton(),
            title: Text(
              "Ticket Details",
              style: TextFontStyle.textStyle24cFFFFFFSFPro590.copyWith(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            centerTitle: true,
          ),
        ),
      ),
      body: widget.orderId != null && widget.orderId!.isNotEmpty
          ? StreamBuilder<OrderDetailsResponseModel>(
              stream: getOrderDetailsRxObj.getOrderDetailsData,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting &&
                    !snapshot.hasData) {
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
                          'Failed to load ticket details',
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
                          onPressed: () {
                            getOrderDetailsRxObj
                                .fetchOrderDetails(widget.orderId!);
                          },
                          child: const Text(
                            'Try Again',
                            style: TextStyle(color: Colors.orange),
                          ),
                        ),
                      ],
                    ),
                  );
                }

                final order = snapshot.data?.data;
                if (order == null) {
                  return const Center(
                    child: CircularProgressIndicator(color: Colors.orange),
                  );
                }

                return _buildContent(order);
              },
            )
          : Center(
              child: Text(
                'Invalid order ID',
                style: TextFontStyle.textStyle14cFFFFFFSFProRounded400.copyWith(
                  fontFamily: 'SF Pro',
                  fontSize: 16.sp,
                  color: Colors.white.withValues(alpha: 0.4),
                ),
              ),
            ),
    );
  }

  Widget _buildContent(MyOrderData order) {
    final eventName = order.eventId?.title ?? 'Event';
    final location = order.eventId?.placeName ?? '';
    final dateTime = _formatDateTime(order.eventId?.startDate);
    final organizer = order.hostId?.businessProfile?.businessName ??
        order.hostId?.name ??
        "N/A";
    final ticketId = order.ticketId ?? order.id ?? "N/A";
    final qrCodeUrl = order.qrCode;

    return SingleChildScrollView(
      padding: EdgeInsets.all(20.w),
      child: Column(
        children: [
          GradientContainer(
            width: double.infinity,
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // QR Code Container
                Center(
                  child: Container(
                    width: 250.w,
                    height: 250.w,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                    padding: EdgeInsets.all(16.w),
                    child: (qrCodeUrl != null && qrCodeUrl.isNotEmpty)
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(12.r),
                            child: CachedNetworkImage(
                              imageUrl: qrCodeUrl,
                              fit: BoxFit.contain,
                              placeholder: (context, url) => Shimmer.fromColors(
                                baseColor: Colors.grey.shade300,
                                highlightColor: Colors.grey.shade100,
                                child: Container(
                                  color: Colors.white,
                                ),
                              ),
                              errorWidget: (context, url, error) => Image.asset(
                                Assets.images.placeholderImage.path,
                                fit: BoxFit.cover,
                              ),
                            ),
                          )
                        : ClipRRect(
                            borderRadius: BorderRadius.circular(12.r),
                            child: Image.asset(
                              Assets.images.placeholderImage.path,
                              fit: BoxFit.cover,
                            ),
                          ),
                  ),
                ),
                UIHelper.verticalSpace(24.h),

                CustomPaint(
                  size: Size(double.infinity, 1.w),
                  painter: _DashedLinePainter(
                    color: Colors.white.withValues(alpha: 0.2),
                  ),
                ),
                UIHelper.verticalSpace(12.h),

                // Details Rows
                _buildDetailRow("Event", eventName),
                UIHelper.verticalSpace(12.h),
                _buildDetailRow("Event Location", location),
                UIHelper.verticalSpace(12.h),
                _buildDetailRow("Date & Time", dateTime),
                UIHelper.verticalSpace(12.h),

                // Organizer & Ticket ID
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: _buildDetailRow(
                        "Event Organizer",
                        organizer,
                      ),
                    ),
                    Expanded(
                      child: _buildDetailRow(
                        "Ticket ID",
                        ticketId,
                        alignRight: true,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          UIHelper.verticalSpace(24.h),

          // Download Ticket Button
          CustomGradientButton(
            onPressed: _isDownloading ? null : () => _downloadTicket(order),
            height: 50.h,
            borderRadius: BorderRadius.circular(100.r),
            child: _isDownloading
                ? const SizedBox(
                    height: 24,
                    width: 24,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                : Text(
                    "Download Ticket",
                    style: TextFontStyle.textStyle14cFFFFFFSFProRounded400
                        .copyWith(
                      color: AppColors.c262824,
                      fontWeight: FontWeight.w700,
                      fontSize: 16.sp,
                    ),
                  ),
          ),

          if (order.status != 'CANCELLED') ...[
            UIHelper.verticalSpace(14.h),

            // Refund My Ticket Button
            CustomGradientButton(
              onPressed: _isRefunding
                  ? null
                  : () async {
                      final targetOrderId = order.id ?? widget.orderId;
                      if (targetOrderId == null || targetOrderId.isEmpty) {
                        customToastMessage(
                          "Error",
                          "Invalid order ID",
                          isError: true,
                        );
                        return;
                      }
                      final confirm =
                          await showCancelTicketBottomSheet(context);
                      if (confirm == true) {
                        _refundTicket(targetOrderId);
                      }
                    },
              height: 50.h,
              borderRadius: BorderRadius.circular(100.r),
              gradient: const LinearGradient(
                colors: [Color(0xFFF28F31), Color(0xFFF28F31)],
              ),
              child: _isRefunding
                  ? const SizedBox(
                      height: 24,
                      width: 24,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : Text(
                      "Refund My Ticket",
                      style: TextFontStyle
                          .textStyle14cFFFFFFSFProRounded400
                          .copyWith(
                        color: AppColors.c1B1F26,
                        fontWeight: FontWeight.w700,
                        fontSize: 16.sp,
                      ),
                    ),
            ),
          ],
          UIHelper.verticalSpace(24.h),
        ],
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

  _DashedLinePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;

    const dashWidth = 4.0;
    const dashSpace = 4.0;
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
