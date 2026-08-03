import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../gen/colors.gen.dart';
import '../../../../helpers/ui_helpers.dart';
import '../../../../constants/text_font_style.dart';
import 'widgets/claim_filter_tabs.dart';
import 'widgets/claim_card.dart';
import 'widgets/verify_redeem_bottom_sheet.dart';

class BusinessPartnerClaimScreen extends StatefulWidget {
  const BusinessPartnerClaimScreen({super.key});

  @override
  State<BusinessPartnerClaimScreen> createState() =>
      _BusinessPartnerClaimScreenState();
}

class _BusinessPartnerClaimScreenState
    extends State<BusinessPartnerClaimScreen> {
  String _selectedTab = "All";
  final TextEditingController _searchController = TextEditingController();

  final List<Map<String, dynamic>> _dummyClaims = [
    {
      "name": "Albert Flores",
      "email": "albertflores@gmail.com",
      "rewardName": "Free Coffee & Pastry",
      "date": "Sep 30, 2025 - 5:00 PM",
      "status": "Pending",
    },
    {
      "name": "Jacob Jones",
      "email": "albertflores@gmail.com",
      "rewardName": "Free Coffee & Pastry",
      "date": "Jul 26, 2025 - 4:00 PM",
      "status": "Redeemed",
    },
    {
      "name": "Albert Flores",
      "email": "albertflores@gmail.com",
      "rewardName": "Free Coffee & Pastry",
      "date": "Sep 30, 2025 - 5:00 PM",
      "status": "Pending",
    },
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldColor,
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: SafeArea(
          bottom: false,
          child: Padding(
            padding: EdgeInsets.only(left: 20.w, right: 20.w, top: 24.h),
            child: Column(
              children: [
                // Search Bar
                Container(
                  height: 52.h,
                  decoration: BoxDecoration(
                    color: AppColors.c1E222B,
                    borderRadius: BorderRadius.circular(100.r),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.05),
                      width: 1.w,
                    ),
                  ),
                  padding: EdgeInsets.only(left: 16.w, right: 6.w),
                  child: Row(
                    children: [
                      Icon(
                        Icons.search,
                        color: Colors.white.withValues(alpha: 0.5),
                        size: 24.sp,
                      ),
                      UIHelper.horizontalSpace(12),
                      Expanded(
                        child: TextField(
                          controller: _searchController,
                          style: TextFontStyle.textStyle14cFFFFFFSFProRounded400
                              .copyWith(color: Colors.white),
                          decoration: InputDecoration(
                            hintText: "Search...",
                            hintStyle: TextFontStyle
                                .textStyle14cFFFFFFSFProRounded400
                                .copyWith(
                                  color: Colors.white.withValues(alpha: 0.4),
                                ),
                            border: InputBorder.none,
                            isDense: true,
                            contentPadding: EdgeInsets.zero,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                UIHelper.verticalSpace(20.h),
                ClaimFilterTabs(
                  selectedTab: _selectedTab,
                  onTabSelected: (tab) {
                    setState(() {
                      _selectedTab = tab;
                    });
                  },
                ),
                UIHelper.verticalSpace(20.h),
                Expanded(
                  child: ListView.separated(
                    padding: EdgeInsets.only(bottom: 24.h),
                    itemCount: _dummyClaims.length,
                    separatorBuilder: (context, index) =>
                        UIHelper.verticalSpace(16.h),
                    itemBuilder: (context, index) {
                      final claim = _dummyClaims[index];
                      // If not "All", filter by selected tab
                      if (_selectedTab != "All" &&
                          claim["status"] != _selectedTab) {
                        return const SizedBox.shrink();
                      }

                      return ClaimCard(
                        name: claim["name"],
                        email: claim["email"],
                        rewardName: claim["rewardName"],
                        date: claim["date"],
                        status: claim["status"],
                        onMarkAsRedeemed: () {
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            backgroundColor: Colors.transparent,
                            builder: (context) => Padding(
                              padding: EdgeInsets.only(
                                bottom: MediaQuery.of(
                                  context,
                                ).viewInsets.bottom,
                              ),
                              child: const VerifyRedeemBottomSheet(),
                            ),
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
      ),
    );
  }
}
