import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:teamstreakpromo/helpers/ui_helpers.dart';
import 'package:teamstreakpromo/gen/assets.gen.dart';

class AvailableBalanceCard extends StatelessWidget {
  final String balance;

  const AvailableBalanceCard({super.key, required this.balance});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 30.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.r),
        image: DecorationImage(
          image: AssetImage(Assets.images.pointBackground.path),
          fit: BoxFit.cover,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Available Balance",
            style: TextStyle(
              fontFamily: "SF Pro",
              fontSize: 15.sp,
              fontWeight: FontWeight.w500,
              color: Colors.white.withValues(alpha: 0.9),
            ),
          ),
          UIHelper.verticalSpace(10),
          Text(
            balance,
            style: TextStyle(
              fontFamily: "SF Pro Rounded",
              fontSize: 36.sp,
              fontWeight: FontWeight.w800,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
