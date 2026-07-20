import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:teamstreakpromo/gen/colors.gen.dart';
import 'package:teamstreakpromo/helpers/ui_helpers.dart';
import '../widget/available_balance_card.dart';
import '../widget/earnings_line_chart.dart';

class EarningOverviewScreen extends StatefulWidget {
  const EarningOverviewScreen({super.key});

  @override
  State<EarningOverviewScreen> createState() => _EarningOverviewScreenState();
}

class _EarningOverviewScreenState extends State<EarningOverviewScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldColor,
      body: SafeArea(
        child: Column(
          children: [
            UIHelper.verticalSpace(20),
            // Header Row
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: EdgeInsets.all(10.w),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1E222B),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.08),
                        ),
                      ),
                      child: Icon(
                        Icons.arrow_back_rounded,
                        color: Colors.white,
                        size: 20.w,
                      ),
                    ),
                  ),
                  const Spacer(),
                  Text(
                    "Earning overview",
                    style: TextStyle(
                      fontFamily: "SF Pro Rounded",
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  const Spacer(),
                  SizedBox(width: 40.w), // Spacer balance
                ],
              ),
            ),
            UIHelper.verticalSpace(24),

            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Column(
                  children: [
                    // 1. Available Balance Card
                    const AvailableBalanceCard(balance: "\$572.95"),
                    UIHelper.verticalSpace(20),

                    // 2. Earning Statistics Chart Card
                    const EarningsLineChart(),
                    UIHelper.verticalSpace(20),

                    // 3. Total Revenue Info Box
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1E222B),
                        borderRadius: BorderRadius.circular(20.r),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.08),
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(8.w),
                            decoration: BoxDecoration(
                              color: Colors.greenAccent.withValues(alpha: 0.15),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.access_time_rounded,
                              color: Colors.greenAccent,
                              size: 20.w,
                            ),
                          ),
                          UIHelper.horizontalSpace(12),
                          Text(
                            "Total Revenue",
                            style: TextStyle(
                              fontFamily: "SF Pro Rounded",
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                              color: Colors.white.withValues(alpha: 0.6),
                            ),
                          ),
                          const Spacer(),
                          Text(
                            "\$12,450",
                            style: TextStyle(
                              fontFamily: "SF Pro Rounded",
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                    UIHelper.verticalSpace(36),

                    // 4. Request Withdrawal CTA Button
                    GestureDetector(
                      onTap: () {
                        _showSuccessWithdrawalDialog();
                      },
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(vertical: 16.h),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16.r),
                          gradient: const LinearGradient(
                            colors: [
                              Color(0xFFF28F31),
                              Color(0xFF72E84F),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          "Request Withdrawal",
                          style: TextStyle(
                            fontFamily: "SF Pro Rounded",
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w800,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                    UIHelper.verticalSpace(40),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showSuccessWithdrawalDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1E222B),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.r),
          ),
          title: Text(
            "Success",
            style: TextStyle(
              fontFamily: "SF Pro Rounded",
              fontSize: 18.sp,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          content: Text(
            "Your withdrawal request of \$572.95 has been submitted successfully.",
            style: TextStyle(
              fontFamily: "SF Pro",
              fontSize: 14.sp,
              color: Colors.white.withValues(alpha: 0.7),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                "OK",
                style: TextStyle(
                  color: AppColors.primaryColorFirst,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
