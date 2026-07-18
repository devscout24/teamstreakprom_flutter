import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../constants/text_font_style.dart';
import '../../../gen/colors.gen.dart';
import '../../../helpers/ui_helpers.dart';
import '../../../common_widgets/custom_button.dart';
import '../../../common_widgets/custom_gradient_button.dart';

Future<void> showCancelTicketBottomSheet(BuildContext context) async {
  return showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (context) => const CancelTicketBottomSheet(),
  );
}

class CancelTicketBottomSheet extends StatelessWidget {
  const CancelTicketBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
      decoration: BoxDecoration(
        color: AppColors
            .scaffoldColor, // Using scaffoldColor as requested (#171A20)
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(32.r),
          topRight: Radius.circular(32.r),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "Cancel Ticket",
            style: TextFontStyle.textStyle24cFFFFFFSFPro590.copyWith(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          UIHelper.verticalSpace(16.h),
          Text(
            "Are you sure you want to cancel this ticket? This action cannot be undone. Please review the refund policy before continuing.",
            textAlign: TextAlign.center,
            style: TextFontStyle.textStyle14cFFFFFFSFProRounded400.copyWith(
              color: Colors.white.withValues(alpha: 0.7),
              fontSize: 13.sp,
              height: 1.5,
            ),
          ),
          UIHelper.verticalSpace(24.h),
          Divider(
            color: Colors.white.withValues(alpha: 0.1),
            thickness: 1.h,
            height: 1.h,
          ),
          UIHelper.verticalSpace(24.h),
          Row(
            children: [
              Expanded(
                child: CustomButton(
                  onPressed: () => Navigator.pop(context),
                  title: "Keep Ticket",
                  height: 48.h,
                  borderRadius: BorderRadius.circular(100.r),
                  backgroundColor: Colors.white,
                  foregroundColor: AppColors.c262824,
                  textStyle: TextFontStyle.textStyle14cFFFFFFSFProRounded400
                      .copyWith(
                        color: AppColors.c262824,
                        fontWeight: FontWeight.w700,
                        fontSize: 14.sp,
                      ),
                ),
              ),
              UIHelper.horizontalSpace(16.w),
              Expanded(
                child: CustomGradientButton(
                  onPressed: () {
                    // Handle confirm cancellation logic here
                    Navigator.pop(context);
                  },
                  title: "Confirm",
                  height: 48.h,
                  borderRadius: BorderRadius.circular(100.r),

                  textStyle: TextFontStyle.textStyle14cFFFFFFSFProRounded400
                      .copyWith(
                        color: AppColors.c262824,
                        fontWeight: FontWeight.w700,
                        fontSize: 14.sp,
                      ),
                ),
              ),
            ],
          ),
          UIHelper.verticalSpace(8.h),
        ],
      ),
    );
  }
}
