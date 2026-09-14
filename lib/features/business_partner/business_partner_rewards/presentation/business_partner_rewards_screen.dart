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
import '../../../../networks/api_acess.dart';
import '../model/my_marketplaces_response_model.dart';

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
  void initState() {
    super.initState();
    _fetchMarketplaces();
  }

  void _fetchMarketplaces() {
    getMyMarketplacesRxObj.fetchMyMarketplaces();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldColor,
      body: SafeArea(
        bottom: false,
        child: Padding(
          padding: EdgeInsets.only(left: 20.w, right: 20.w, top: 0.h),
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
                child: StreamBuilder<MyMarketplacesResponseModel>(
                  stream: getMyMarketplacesRxObj.getMyMarketplacesData,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting &&
                        !snapshot.hasData) {
                      return const Center(
                        child: CircularProgressIndicator(color: Colors.orange),
                      );
                    }
                    if (snapshot.hasError) {
                      return Center(
                        child: Text(
                          "Failed to load data.",
                          style:
                              TextFontStyle.textStyle14cFFFFFFSFProRounded400,
                        ),
                      );
                    }
                    if (!snapshot.hasData ||
                        snapshot.data?.data == null ||
                        snapshot.data!.data!.isEmpty) {
                      return Center(
                        child: Text(
                          "No rewards found.",
                          style:
                              TextFontStyle.textStyle14cFFFFFFSFProRounded400,
                        ),
                      );
                    }

                    // Filter by active/expired
                    final allItems = snapshot.data!.data!;
                    final filteredItems = allItems.where((item) {
                      final isActive = item.isActive ?? false;
                      if (_isActiveTab) {
                        return isActive;
                      } else {
                        return !isActive;
                      }
                    }).toList();

                    if (filteredItems.isEmpty) {
                      return Center(
                        child: Text(
                          "No ${_isActiveTab ? 'active' : 'expired'} rewards found.",
                          style:
                              TextFontStyle.textStyle14cFFFFFFSFProRounded400,
                        ),
                      );
                    }

                    return ListView.builder(
                      itemCount: filteredItems.length,
                      itemBuilder: (context, index) {
                        final item = filteredItems[index];
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    BusinessPartnerRewardsDetailsScreen(
                                      type: 'businessPartner',
                                      id: item.id,
                                    ),
                              ),
                            ).then((_) {
                              getMyMarketplacesRxObj.fetchMyMarketplaces();
                            });
                          },
                          child: RewardCard(data: item),
                        );
                      },
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
