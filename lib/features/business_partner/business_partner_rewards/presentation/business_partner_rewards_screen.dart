import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../common_widgets/custom_gradient_button.dart';
import '../../../../common_widgets/ticket_toggle_button.dart';
import '../../../../constants/text_font_style.dart';
import '../../../../gen/colors.gen.dart';
import '../../../../helpers/ui_helpers.dart';
import 'business_partner_rewards_details_screen.dart';
import 'business_partner_create_reward_screen.dart';
import '../widgets/reward_card.dart';

class BusinessPartnerRewardsScreen extends StatefulWidget {
  const BusinessPartnerRewardsScreen({super.key});

  @override
  State<BusinessPartnerRewardsScreen> createState() =>
      _BusinessPartnerRewardsScreenState();
}

class _BusinessPartnerRewardsScreenState
    extends State<BusinessPartnerRewardsScreen> {
  bool _isActiveTab = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldColor,
      body: SafeArea(
        bottom: false,
        child: Padding(
          padding: EdgeInsets.only(left: 20.w, right: 20.w, top: 24.h),
          child: Column(
            children: [
              // Header
              Row(
                children: [
                  const Spacer(),
                  CustomGradientButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              const BusinessPartnerCreateRewardScreen(),
                        ),
                      );
                    },
                    width: 200.w,
                    height: 44.h,
                    gradient: const LinearGradient(
                      colors: [Color(0xFFFFAA00), Color(0xFFFFAA00)],
                    ),
                    borderRadius: BorderRadius.circular(100.r),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.add,
                          color: const Color(0xFF1B1C1A),
                          size: 20.sp,
                        ),
                        UIHelper.horizontalSpace(8.w),
                        Text(
                          "Create New Rewards",
                          style: TextFontStyle.textStyle14cFFFFFFSFProRounded400
                              .copyWith(
                                color: const Color(0xFF1B1C1A),
                                fontWeight: FontWeight.w600,
                                fontSize: 14.sp,
                              ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              UIHelper.verticalSpace(24.h),

              // Tab Toggle
              TicketToggleButton(
                leftLabel: "Active",
                rightLabel: "Expired",
                selectedIndex: _isActiveTab ? 0 : 1,
                onChanged: (index) {
                  setState(() {
                    _isActiveTab = index == 0;
                  });
                },
              ),
              UIHelper.verticalSpace(24.h),

              // List of Rewards
              Expanded(
                child: ListView.builder(
                  itemCount: 2, // Sample count
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                const BusinessPartnerRewardsDetailsScreen(type: 'businessPartner'),
                          ),
                        );
                      },
                      child: const RewardCard(),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
