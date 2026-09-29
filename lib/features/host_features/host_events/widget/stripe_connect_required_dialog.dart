import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:teamstreakpromo/common_widgets/custom_gradient_button.dart';
import 'package:teamstreakpromo/helpers/ui_helpers.dart';

class StripeConnectRequiredDialog extends StatelessWidget {
  final VoidCallback onConnect;
  final VoidCallback? onCancel;

  const StripeConnectRequiredDialog({
    super.key,
    required this.onConnect,
    this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: const Color(0xFF1E222B),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24.r),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Align(
              alignment: Alignment.topRight,
              child: GestureDetector(
                onTap: onCancel ?? () => Navigator.pop(context),
                child: Container(
                  padding: EdgeInsets.all(6.w),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.05),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.close_rounded,
                    color: Colors.white.withValues(alpha: 0.6),
                    size: 18.w,
                  ),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: const Color(0xFF635BFF).withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: const FaIcon(
                FontAwesomeIcons.stripe,
                color: Color(0xFF635BFF),
                size: 38,
              ),
            ),
            UIHelper.verticalSpace(18),
            Text(
              "Stripe Connection Required",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: "SF Pro Rounded",
                fontSize: 20.sp,
                fontWeight: FontWeight.w800,
                color: Colors.white,
              ),
            ),
            UIHelper.verticalSpace(10),
            Text(
              "You need to connect with Stripe to receive ticket payouts and host events on Teamstreak.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: "SF Pro",
                fontSize: 14.sp,
                color: Colors.white.withValues(alpha: 0.65),
                height: 1.4,
              ),
            ),
            UIHelper.verticalSpace(24),
            CustomGradientButton(
              title: "Connect with Stripe",
              borderRadius: BorderRadius.circular(16.r),
              onPressed: onConnect,
            ),
            UIHelper.verticalSpace(12),
            TextButton(
              onPressed: onCancel ?? () => Navigator.pop(context),
              child: Text(
                "Go Back",
                style: TextStyle(
                  fontFamily: "SF Pro",
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.white.withValues(alpha: 0.5),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
