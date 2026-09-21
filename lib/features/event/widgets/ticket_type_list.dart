import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:teamstreakpromo/constants/text_font_style.dart';
import 'package:teamstreakpromo/gen/colors.gen.dart';
import 'package:teamstreakpromo/helpers/ui_helpers.dart';
import '../model/event_ticket_type.dart';

class TicketTypesSection extends StatelessWidget {
  final List<EventTicketType> ticketTypes;
  final int selectedIndex;
  final ValueChanged<int> onSelect;
  final bool showHeader;

  const TicketTypesSection({
    super.key,
    required this.ticketTypes,
    required this.selectedIndex,
    required this.onSelect,
    this.showHeader = true,
  });

  @override
  Widget build(BuildContext context) {
    if (ticketTypes.isEmpty) {
      return const SizedBox.shrink();
    }
    final currencyFormat = NumberFormat("#,##0");

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (showHeader) ...[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Ticket Types",
                style: TextFontStyle.textStyle24cFFFFFFSFPro590.copyWith(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "Tap to select",
                style: TextFontStyle.textStyle14cFFFFFFSFProRounded400.copyWith(
                  color: Colors.white.withValues(alpha: 0.5),
                  fontSize: 12.sp,
                ),
              ),
            ],
          ),
          UIHelper.verticalSpace(12.h),
        ],

        // Container with dividers matching the user design
        Container(
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Column(
            children: [
              Divider(
                color: Colors.white.withValues(alpha: 0.08),
                height: 1,
                thickness: 1,
              ),
              ...List.generate(ticketTypes.length, (index) {
                final ticket = ticketTypes[index];
                final isSelected = selectedIndex == index;
                final formattedPrice = currencyFormat.format(ticket.price.round());

                return Column(
                  children: [
                    InkWell(
                      onTap: () => onSelect(index),
                      borderRadius: BorderRadius.circular(8.r),
                      splashColor: AppColors.primaryColorSecond.withValues(alpha: 0.1),
                      highlightColor: AppColors.primaryColorSecond.withValues(alpha: 0.05),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: EdgeInsets.symmetric(
                          vertical: 16.h,
                          horizontal: isSelected ? 10.w : 4.w,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppColors.primaryColorSecond.withValues(alpha: 0.07)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(8.r),
                          border: isSelected
                              ? Border.all(
                                  color: AppColors.primaryColorSecond.withValues(alpha: 0.3),
                                  width: 1.w,
                                )
                              : null,
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // Ticket Title and Stock Subtitle
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    ticket.title,
                                    style: TextFontStyle
                                        .textStyle14cFFFFFFSFProRounded400
                                        .copyWith(
                                          color: isSelected
                                              ? Colors.white
                                              : Colors.white.withValues(
                                                  alpha: 0.95,
                                                ),
                                          fontSize: 15.sp,
                                          fontWeight: isSelected
                                              ? FontWeight.w600
                                              : FontWeight.w500,
                                          letterSpacing: 0.2,
                                          height: 1.35,
                                        ),
                                  ),
                                  if (ticket.subtitle != null &&
                                      ticket.subtitle!.isNotEmpty) ...[
                                    UIHelper.verticalSpace(3.h),
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.event_seat,
                                          size: 13.sp,
                                          color: isSelected
                                              ? AppColors.primaryColorSecond
                                              : AppColors.cDC822D,
                                        ),
                                        UIHelper.horizontalSpace(4.w),
                                        Text(
                                          ticket.subtitle!,
                                          style: TextFontStyle
                                              .textStyle14cFFFFFFSFProRounded400
                                              .copyWith(
                                                color: isSelected
                                                    ? AppColors
                                                        .primaryColorSecond
                                                    : Colors.white.withValues(
                                                        alpha: 0.6,
                                                      ),
                                                fontSize: 12.sp,
                                              ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ],
                              ),
                            ),
                            UIHelper.horizontalSpace(16.w),

                            // Ticket Price
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  "\$$formattedPrice",
                                  style: TextFontStyle.textStyle24cFFFFFFSFPro590.copyWith(
                                    color: AppColors.primaryColorSecond,
                                    fontSize: 17.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                if (isSelected) ...[
                                  UIHelper.horizontalSpace(8.w),
                                  Icon(
                                    Icons.check_circle_rounded,
                                    color: AppColors.primaryColorSecond,
                                    size: 16.sp,
                                  ),
                                ],
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    Divider(
                      color: Colors.white.withValues(alpha: 0.08),
                      height: 1,
                      thickness: 1,
                    ),
                  ],
                );
              }),
            ],
          ),
        ),
      ],
    );
  }
}

Future<void> showTicketTypePickerBottomSheet({
  required BuildContext context,
  required List<EventTicketType> ticketTypes,
  required int selectedIndex,
  required ValueChanged<int> onSelect,
}) {
  return showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (context) {
      int tempSelected = selectedIndex;
      return StatefulBuilder(
        builder: (context, setModalState) {
          return Container(
            padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 32.h),
            decoration: BoxDecoration(
              color: const Color(0xFF13151B),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(24.r),
                topRight: Radius.circular(24.r),
              ),
              border: Border(
                top: BorderSide(
                  color: Colors.white.withValues(alpha: 0.1),
                  width: 1.w,
                ),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40.w,
                    height: 4.h,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(2.r),
                    ),
                  ),
                ),
                UIHelper.verticalSpace(16.h),
                Text(
                  "Select Ticket Type",
                  style: TextFontStyle.textStyle24cFFFFFFSFPro590.copyWith(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                UIHelper.verticalSpace(16.h),
                TicketTypesSection(
                  ticketTypes: ticketTypes,
                  selectedIndex: tempSelected,
                  showHeader: false,
                  onSelect: (index) {
                    setModalState(() {
                      tempSelected = index;
                    });
                    onSelect(index);
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          );
        },
      );
    },
  );
}
