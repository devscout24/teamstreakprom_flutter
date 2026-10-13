import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../constants/text_font_style.dart';
import '../../../gen/colors.gen.dart';
import '../../../gen/assets.gen.dart';
import '../../../helpers/ui_helpers.dart';

void showInviteFriendBottomSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    backgroundColor: const Color(0xFF131722),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(28.r)),
    ),
    isScrollControlled: true,
    builder: (context) {
      bool isCopied = false;

      return StatefulBuilder(
        builder: (context, setSheetState) {
          return Padding(
            padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 32.h),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Top drag handle & Close row
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: 48.w,
                      height: 5.h,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(100.r),
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: IconButton(
                        icon: const Icon(Icons.close, color: Colors.white),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                  ],
                ),
                UIHelper.verticalSpace(8.h),

                // Title
                Text(
                  "Invite a Friend",
                  style: TextFontStyle.textStyle24cFFFFFFSFPro590.copyWith(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                UIHelper.verticalSpace(8.h),

                // Subtitle
                Text(
                  "Share the link to everyone you want",
                  style: TextFontStyle.textStyle14cFFFFFFSFProRounded400
                      .copyWith(
                        color: Colors.white.withValues(alpha: 0.6),
                        fontSize: 14.sp,
                      ),
                ),
                UIHelper.verticalSpace(24.h),

                // Link copy container
                Container(
                  padding: EdgeInsets.all(8.w),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E222B),
                    borderRadius: BorderRadius.circular(100.r),
                  ),
                  child: Row(
                    children: [
                      UIHelper.horizontalSpace(16.w),
                      Expanded(
                        child: Text(
                          "streak.com/join?ref=fdsah",
                          style: TextFontStyle.textStyle14cFFFFFFSFProRounded400
                              .copyWith(color: Colors.white, fontSize: 15.sp),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Clipboard.setData(
                            const ClipboardData(
                              text: "streak.com/join?ref=fdsah",
                            ),
                          );
                          setSheetState(() {
                            isCopied = true;
                          });
                          Future.delayed(const Duration(seconds: 2), () {
                            setSheetState(() {
                              isCopied = false;
                            });
                          });
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          width: 44.w,
                          height: 44.w,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: isCopied
                                ? null
                                : const LinearGradient(
                                    colors: [
                                      AppColors.primaryColorFirst,
                                      AppColors.primaryColorSecond,
                                    ],
                                  ),
                            color: isCopied ? const Color(0xFF4CAF50) : null,
                          ),
                          child: Icon(
                            isCopied ? Icons.check : Icons.copy_rounded,
                            color: Colors.white,
                            size: 20.sp,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                UIHelper.verticalSpace(24.h),

                // Referral Alert Warning container box
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 12.h,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.04),
                    borderRadius: BorderRadius.circular(16.r),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.05),
                      width: 1.w,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        color: AppColors.cDC822D,
                        size: 20.sp,
                      ),
                      UIHelper.horizontalSpace(12.w),
                      Expanded(
                        child: Text(
                          "You'll earn 1 point for each successful referral!",
                          style: TextFontStyle.textStyle14cFFFFFFSFProRounded400
                              .copyWith(
                                color: AppColors.cDC822D,
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w500,
                              ),
                        ),
                      ),
                    ],
                  ),
                ),
                UIHelper.verticalSpace(28.h),

                // Social Grid/Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildSocialIconItem(
                      child: Assets.icons.telegramIcon.image(
                        width: 32.w,
                        height: 32.w,
                      ),
                    ),
                    _buildSocialIconItem(
                      child: Assets.icons.gmailIcon.image(
                        width: 32.w,
                        height: 32.w,
                      ),
                    ),
                    _buildSocialIconItem(
                      child: Assets.icons.instragramIcon.image(
                        width: 32.w,
                        height: 32.w,
                      ),
                    ),
                    _buildSocialIconItem(
                      child: Assets.icons.threatIcon.image(
                        width: 32.w,
                        height: 32.w,
                      ),
                    ),
                    _buildSocialIconItem(
                      child: Assets.icons.messengerIcon.image(
                        width: 32.w,
                        height: 32.w,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      );
    },
  );
}

Widget _buildSocialIconItem({required Widget child}) {
  return Container(
    width: 60.w,
    height: 60.w,
    decoration: BoxDecoration(
      color: const Color(0xFF1E222B),
      borderRadius: BorderRadius.circular(16.r),
      border: Border.all(
        color: Colors.white.withValues(alpha: 0.05),
        width: 1.w,
      ),
    ),
    alignment: Alignment.center,
    child: child,
  );
}
