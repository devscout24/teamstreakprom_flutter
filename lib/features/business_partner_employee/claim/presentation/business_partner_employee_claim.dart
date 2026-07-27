import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:teamstreakpromo/gen/colors.gen.dart';
import 'package:teamstreakpromo/helpers/ui_helpers.dart';
import 'package:teamstreakpromo/constants/text_font_style.dart';
import 'package:teamstreakpromo/features/business_partner/business_partner_claim/presentation/widgets/claim_filter_tabs.dart';
import 'package:teamstreakpromo/features/business_partner/business_partner_claim/presentation/widgets/claim_card.dart';
import 'package:teamstreakpromo/features/business_partner/business_partner_claim/presentation/widgets/verify_redeem_bottom_sheet.dart';

class BusinessPartnerEmployeeClaim extends StatefulWidget {
  const BusinessPartnerEmployeeClaim({super.key});

  @override
  State<BusinessPartnerEmployeeClaim> createState() =>
      _BusinessPartnerEmployeeClaimState();
}

class _BusinessPartnerEmployeeClaimState
    extends State<BusinessPartnerEmployeeClaim> {
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
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          children: [
            UIHelper.verticalSpace(16.h),
            // Search Bar
            Container(
              height: 52.h,
              decoration: BoxDecoration(
                color: const Color(0xFF1E222B),
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
                  UIHelper.horizontalSpace(12.w),
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
                            bottom: MediaQuery.of(context).viewInsets.bottom,
                          ),
                          child: const VerifyRedeemBottomSheet(),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            UIHelper.verticalSpace(20.h),
          ],
        ),
      ),
    );
  }
}
