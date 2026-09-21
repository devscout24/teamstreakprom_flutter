import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:teamstreakpromo/constants/text_font_style.dart';
import 'package:teamstreakpromo/gen/assets.gen.dart';
import 'package:teamstreakpromo/gen/colors.gen.dart';
import 'package:teamstreakpromo/helpers/ui_helpers.dart';
import 'package:teamstreakpromo/common_widgets/custom_gradient_button.dart';
import 'package:teamstreakpromo/features/event/widgets/event_details_widgets.dart';

class EventBottomActions extends StatelessWidget {
  final bool isHost;
  final int selectedTabIndex;
  final int ticketCount;
  final VoidCallback onTicketCountIncrement;
  final VoidCallback onTicketCountDecrement;
  final VoidCallback onBuyTicket;
  final VoidCallback onRedeemReward;
  final VoidCallback onEditEvent;
  final VoidCallback onDeleteEvent;
  final bool isDeleting;
  final double ticketPrice;
  final String? selectedTicketTitle;
  final VoidCallback? onChangeTicketType;

  const EventBottomActions({
    super.key,
    required this.isHost,
    required this.selectedTabIndex,
    required this.ticketCount,
    required this.onTicketCountIncrement,
    required this.onTicketCountDecrement,
    required this.onBuyTicket,
    required this.onRedeemReward,
    required this.onEditEvent,
    required this.onDeleteEvent,
    this.isDeleting = false,
    this.ticketPrice = 0.0,
    this.selectedTicketTitle,
    this.onChangeTicketType,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
      child: isHost
          ? Row(
              children: [
                Expanded(
                  flex: 2,
                  child: CustomGradientButton(
                    onPressed: onEditEvent,
                    title: "Edit Info",
                    borderRadius: BorderRadius.circular(100.r),
                    textStyle: TextFontStyle.textStyle14cFFFFFFSFProRounded400
                        .copyWith(
                          color: const Color(0xFF262824),
                          fontWeight: FontWeight.w700,
                          fontSize: 16.sp,
                        ),
                  ),
                ),
                UIHelper.horizontalSpace(16.w),
                Expanded(
                  flex: 1,
                  child: CustomGradientButton(
                    onPressed: isDeleting
                        ? null
                        : () {
                            showDeleteEventBottomSheet(context, onDeleteEvent);
                          },
                    title: isDeleting ? null : "Delete",
                    height: 50.h,
                    borderRadius: BorderRadius.circular(100.r),
                    textStyle: TextFontStyle.textStyle14cFFFFFFSFProRounded400
                        .copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 16.sp,
                        ),
                    gradient: const LinearGradient(
                      colors: [Color(0xFFC72C2C), Color(0xFF9E1F1F)],
                    ),
                    child: isDeleting
                        ? SizedBox(
                            width: 24.w,
                            height: 24.w,
                            child: const CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2.0,
                            ),
                          )
                        : null,
                  ),
                ),
              ],
            )
          : selectedTabIndex == 0
          ? Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Selected Ticket Type indicator (if provided)
                if (selectedTicketTitle != null &&
                    selectedTicketTitle!.isNotEmpty) ...[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            Text(
                              "Selected: ",
                              style: TextFontStyle
                                  .textStyle14cFFFFFFSFProRounded400
                                  .copyWith(
                                    color: Colors.white.withValues(alpha: 0.6),
                                    fontSize: 12.sp,
                                  ),
                            ),
                            Flexible(
                              child: Text(
                                selectedTicketTitle!,
                                style: TextFontStyle
                                    .textStyle14cFFFFFFSFProRounded400
                                    .copyWith(
                                      color: AppColors.primaryColorSecond,
                                      fontSize: 12.5.sp,
                                      fontWeight: FontWeight.w600,
                                    ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (onChangeTicketType != null)
                        GestureDetector(
                          onTap: onChangeTicketType,
                          child: Padding(
                            padding: EdgeInsets.only(left: 8.w),
                            child: Text(
                              "Change",
                              style: TextFontStyle
                                  .textStyle14cFFFFFFSFProRounded400
                                  .copyWith(
                                    color: AppColors.primaryColorSecond,
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.bold,
                                    decoration: TextDecoration.underline,
                                  ),
                            ),
                          ),
                        ),
                    ],
                  ),
                  UIHelper.verticalSpace(10.h),
                ],

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
                            onTap: onTicketCountDecrement,
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
                            "$ticketCount",
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
                            onTap: onTicketCountIncrement,
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
                            ticketPrice > 0
                                ? "\$${NumberFormat('#,##0').format((ticketPrice * ticketCount).round())}"
                                : "Free",
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
                  onPressed: onBuyTicket,
                  title: "Buy a Ticket",
                  borderRadius: BorderRadius.circular(100.r),
                  textStyle:
                      TextFontStyle.textStyle14cFFFFFFSFProRounded400.copyWith(
                    color: const Color(0xFF262824),
                    fontWeight: FontWeight.w700,
                    fontSize: 16.sp,
                  ),
                ),
              ],
            )
          : CustomGradientButton(
              onPressed: onRedeemReward,
              title: "Redeem Reward",
              borderRadius: BorderRadius.circular(100.r),
              textStyle:
                  TextFontStyle.textStyle14cFFFFFFSFProRounded400.copyWith(
                color: const Color(0xFF262824),
                fontWeight: FontWeight.w700,
                fontSize: 16.sp,
              ),
            ),
    );
  }
}
