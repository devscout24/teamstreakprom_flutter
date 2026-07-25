import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:teamstreakpromo/common_widgets/custom_back_button.dart';
import 'package:teamstreakpromo/common_widgets/custom_gradient_button.dart';
import 'package:teamstreakpromo/constants/text_font_style.dart';
import 'package:teamstreakpromo/gen/colors.gen.dart';
import 'package:teamstreakpromo/helpers/ui_helpers.dart';
import 'package:teamstreakpromo/helpers/navigation_service.dart';
import 'package:teamstreakpromo/helpers/all_routes.dart';
import 'package:teamstreakpromo/features/auth/presentation/choose_account_type_screen.dart';
import 'package:teamstreakpromo/common_widgets/gradient_container.dart';

class SubscriptionScreen extends StatelessWidget {
  final AccountType? accountType;

  const SubscriptionScreen({super.key, this.accountType});

  final List<String> _features = const [
    "Create Up to 20 Events Every Month",
    "Sell tickets directly through the app",
    "Create Exclusive Rewards",
    "Manage Venue Capacity",
    "Organize Events with Categories & Tags",
    "Real-time Ticket & Sales Tracking",
    "QR Code Check-in for Ticket Validation",
    "Monitor Sales & Event Performance",
    "Manage Everything from One Dashboard",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldColor,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            children: [
              UIHelper.verticalSpace(16),
              // Header Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const CustomBackButton(),
                  Text(
                    "Subscription plan",
                    style: TextFontStyle.textStyle18cFFFFFFSFPro590.copyWith(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w600,
                      fontFamily: "SF Pro Rounded",
                    ),
                  ),
                  SizedBox(
                    width: 40.w,
                  ), // Empty spacing to balance the back button
                ],
              ),
              UIHelper.verticalSpace(24),

              // Main Subscription Card with custom gradient border
              Expanded(
                child: SingleChildScrollView(
                  child: GradientContainer(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(
                      horizontal: 20.w,
                      vertical: 24.h,
                    ),
                    border: Border.all(
                      color: AppColors.cFFFFFF.withValues(alpha: .1),
                      width: 1.5.w,
                    ),
                    borderRadius: BorderRadius.circular(32.r),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Plan Title
                        Text(
                          "Host Plan",
                          style: TextStyle(
                            fontFamily: "SF Pro Rounded",
                            fontSize: 26.sp,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                        UIHelper.verticalSpace(6),
                        // Plan Subtitle
                        Text(
                          "Perfect for managing your events smoothly",
                          style: TextStyle(
                            fontFamily: "SF Pro",
                            fontSize: 13.sp,
                            color: Colors.white.withValues(alpha: 0.6),
                          ),
                        ),
                        UIHelper.verticalSpace(20),

                        // Price
                        RichText(
                          text: TextSpan(
                            text: "29.99\$",
                            style: TextStyle(
                              fontFamily: "SF Pro Rounded",
                              fontSize: 44.sp,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                            children: [
                              TextSpan(
                                text: " / month",
                                style: TextStyle(
                                  fontFamily: "SF Pro",
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.white.withValues(alpha: 0.6),
                                ),
                              ),
                            ],
                          ),
                        ),
                        UIHelper.verticalSpace(16),
                        Divider(
                          color: Colors.white.withValues(alpha: 0.1),
                          thickness: 1.h,
                        ),
                        UIHelper.verticalSpace(24),

                        // Features List
                        ListView.separated(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: _features.length,
                          separatorBuilder: (context, index) =>
                              UIHelper.verticalSpace(16),
                          itemBuilder: (context, index) {
                            return Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                // Circular Green Checkmark Icon matching mockup
                                Container(
                                  width: 20.w,
                                  height: 20.w,
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        AppColors.primaryColorFirst.withValues(
                                          alpha: 0.6,
                                        ),
                                        AppColors.primaryColorSecond.withValues(
                                          alpha: 0.6,
                                        ),
                                      ],
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                    ),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.check,
                                    color: Colors.black,
                                    size: 13.w,
                                  ),
                                ),
                                UIHelper.horizontalSpace(12),
                                Expanded(
                                  child: Text(
                                    _features[index],
                                    style: TextStyle(
                                      fontFamily: "SF Pro",
                                      fontSize: 14.sp,
                                      color: Colors.white.withValues(
                                        alpha: 0.9,
                                      ),
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                        UIHelper.verticalSpace(32),

                        // Action Button
                        CustomGradientButton(
                          height: 50.h,
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  "Subscription Activated successfully!",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontFamily: "SF Pro Rounded",
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                backgroundColor: AppColors.primaryColorSecond,
                                behavior: SnackBarBehavior.floating,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.r),
                                ),
                              ),
                            );

                            if (accountType == AccountType.host) {
                              NavigationService.navigateToReplacement(
                                Routes.hostNavigationScreen,
                              );
                            } else if (accountType ==
                                AccountType.businessPartner) {
                              NavigationService.navigateToReplacement(
                                Routes.businessPartnerNavbarScreen,
                              );
                            } else {
                              // Fallback
                              NavigationService.navigateToReplacement(
                                Routes.hostNavigationScreen,
                              );
                            }
                          },
                          title: "Activate Subscription",
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              UIHelper.verticalSpace(16),
            ],
          ),
        ),
      ),
    );
  }
}

class RoundedGradientBorderPainter extends CustomPainter {
  final Gradient gradient;
  final double strokeWidth;
  final double borderRadius;

  RoundedGradientBorderPainter({
    required this.gradient,
    this.strokeWidth = 1.0,
    this.borderRadius = 24.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTWH(
      strokeWidth / 2,
      strokeWidth / 2,
      size.width - strokeWidth,
      size.height - strokeWidth,
    );
    final paint = Paint()
      ..shader = gradient.createShader(rect)
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    canvas.drawRRect(
      RRect.fromRectAndRadius(rect, Radius.circular(borderRadius)),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant RoundedGradientBorderPainter oldDelegate) {
    return oldDelegate.gradient != gradient ||
        oldDelegate.strokeWidth != strokeWidth ||
        oldDelegate.borderRadius != borderRadius;
  }
}
