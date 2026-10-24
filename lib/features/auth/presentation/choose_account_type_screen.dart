import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../common_widgets/custom_back_button.dart';
import '../../../common_widgets/custom_gradient_button.dart';
import '../../../constants/text_font_style.dart';
import '../../../gen/colors.gen.dart';
import '../../../helpers/ui_helpers.dart';
import '../../../helpers/navigation_service.dart';
import '../../../helpers/all_routes.dart';
import '../../../helpers/di.dart';
import '../../../constants/app_constants.dart';

enum AccountType { user, host, businessPartner }

class ChooseAccountTypeScreen extends StatefulWidget {
  final bool isSignUp;
  const ChooseAccountTypeScreen({super.key, this.isSignUp = false});

  @override
  State<ChooseAccountTypeScreen> createState() =>
      _ChooseAccountTypeScreenState();
}

class AccountTypeData {
  final AccountType type;
  final String title;
  final String shortDescription;
  final String? popupTitle1;
  final String? popupDesc1;
  final String? popupTitle2;
  final String? popupDesc2;

  const AccountTypeData({
    required this.type,
    required this.title,
    required this.shortDescription,
    this.popupTitle1,
    this.popupDesc1,
    this.popupTitle2,
    this.popupDesc2,
  });
}

class _ChooseAccountTypeScreenState extends State<ChooseAccountTypeScreen> {
  AccountType _selectedType = AccountType.user;

  String _getAccountTypeString(AccountType type) {
    switch (type) {
      case AccountType.user:
        return "USER";
      case AccountType.host:
        return "HOST";
      case AccountType.businessPartner:
        return "BUSINESS";
    }
  }

  final List<AccountTypeData> _cards = const [
    AccountTypeData(
      type: AccountType.user,
      title: "Attendee",
      shortDescription: "Attend events, earn points, and unlock rewards.",
      popupTitle1: "Who is an Attendee?",
      popupDesc1:
          "Buy tickets, earn Streak Points, attend events! Streak Points are tokens that you receive every time a ticket is purchased. You will also be able to send invite links to friends. For every ticket purchased through an invite link, you will receive 1 Streak Point. Streak Points can be used on custom rewards from different businesses and venues.",
    ),
    AccountTypeData(
      type: AccountType.host,
      title: "Host",
      shortDescription: "Create events, sell tickets, and grow your audience.",
      popupTitle1: "Who is a Host?",
      popupDesc1:
          "Business owners or business representatives who host live ticketed events. With this account, you will be able to post custom events as well as custom rewards catered to each event. These rewards may be unlocked with Streak Points by attendees.",
    ),
    AccountTypeData(
      type: AccountType.businessPartner,
      title: "Business Partner",
      shortDescription: "Offer rewards and connect with local communities.",
      popupTitle1: "Who is a Business Partner?",
      popupDesc1:
          "Business owners or business representatives who distribute products. With this account, you will be able to post exclusive custom rewards that can be unlocked with Streak Points.",
    ),
  ];

  void _showDetailsBottomSheet(BuildContext context, AccountTypeData data) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.scaffoldColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 40.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Drag Handle
              Center(
                child: Container(
                  width: 40.w,
                  height: 4.h,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.8),
                    borderRadius: BorderRadius.circular(2.r),
                  ),
                ),
              ),
              UIHelper.verticalSpace(24),
              // Inner Rounded Card Container
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color(0xFF1E222B),
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(
                    horizontal: 24.w,
                    vertical: 24.h,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.r),
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        AppColors.primaryColorFirst.withValues(alpha: 0.1),
                        AppColors.primaryColorSecond.withValues(alpha: 0.1),
                      ],
                      stops: const [-0.375, 1.2411],
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Section 1 Title
                      Center(
                        child: Text(
                          data.popupTitle1 ?? '',
                          textAlign: TextAlign.center,
                          style: TextFontStyle.textStyle18cFFFFFFSFPro590
                              .copyWith(
                                fontFamily: "SF Pro",
                                color: AppColors.cFFFFFF.withValues(alpha: 0.9),
                              ),
                        ),
                      ),
                      UIHelper.verticalSpace(12),
                      // Content
                      Text(
                        data.popupDesc1 ?? '',
                        textAlign: TextAlign.center,
                        style: TextFontStyle.textStyle14cFFFFFFSFProRounded400
                            .copyWith(
                              fontSize: 13.sp,
                              fontFamily: "SF Pro",
                              color: AppColors.cFFFFFF.withValues(alpha: 0.7),
                              height: 1.4,
                            ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCard(AccountTypeData data) {
    final bool isActive = _selectedType == data.type;
    final bool hasInfo = data.popupTitle1 != null;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedType = data.type;
        });
      },
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: const Color(0xFF1E222B),
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: isActive
                ? AppColors.c7DFF57.withValues(alpha: 0.4)
                : Colors.transparent,
            width: 1.w,
          ),
        ),
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.r),
            gradient: isActive
                ? LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      AppColors.primaryColorFirst.withValues(alpha: 0.1),
                      AppColors.primaryColorSecond.withValues(alpha: 0.1),
                    ],
                    stops: const [-0.375, 1.2411],
                  )
                : null,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Text(
                          data.title,
                          style: TextFontStyle.textStyle18cFFFFFFSFPro590
                              .copyWith(
                                fontFamily: "SF Pro Rounded",
                                color: isActive
                                    ? AppColors.c7DFF57
                                    : Colors.white,
                              ),
                        ),
                        if (hasInfo) ...[
                          UIHelper.horizontalSpace(8),
                          GestureDetector(
                            onTap: () {
                              _showDetailsBottomSheet(context, data);
                            },
                            behavior: HitTestBehavior.opaque,
                            child: Padding(
                              padding: EdgeInsets.all(4.r),
                              child: Icon(
                                Icons.info_outline,
                                size: 20.w,
                                color: Colors.white.withValues(alpha: 0.6),
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    UIHelper.verticalSpace(8),
                    Text(
                      data.shortDescription,
                      style: TextFontStyle.textStyle14cFFFFFFSFProRounded400
                          .copyWith(
                            fontSize: 14.sp,
                            color: AppColors.c9B9C9A,
                            height: 1.4,
                          ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 16.w),
              // Custom Radio Circle Selector
              Container(
                margin: EdgeInsets.only(top: 2.h), // Align with title
                width: 24.w,
                height: 24.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isActive
                        ? AppColors.c7DFF57
                        : Colors.white.withValues(alpha: 0.4),
                    width: 2.w,
                  ),
                ),
                child: isActive
                    ? Center(
                        child: Container(
                          width: 12.w,
                          height: 12.w,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.c7DFF57,
                          ),
                        ),
                      )
                    : null,
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          AppColors.scaffoldColor, // Dark grey background matching mockup
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(24.w, 16.h, 24.w, 24.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CustomBackButton(),
              UIHelper.verticalSpace(20),
              Text(
                "Choose Your Account Type",
                style: TextFontStyle.textStyle24cFFFFFFSFPro590.copyWith(
                  fontWeight: FontWeight.w600,
                  fontFamily: "SF Pro Rounded",
                ),
              ),
              UIHelper.verticalSpace(8),
              Text(
                "Please select an account type and let’s divine into the experience!",
                style: TextFontStyle.textStyle14cFFFFFFSFProRounded400.copyWith(
                  color: Colors.white.withValues(alpha: 0.6),
                ),
              ),
              UIHelper.verticalSpace(32),

              // Option Cards
              _buildCard(_cards[0]),
              UIHelper.verticalSpace(16),
              _buildCard(_cards[1]),
              UIHelper.verticalSpace(16),
              _buildCard(_cards[2]),

              const Spacer(),

              CustomGradientButton(
                onPressed: () {
                  String typeStr = _getAccountTypeString(_selectedType);
                  appData.write(kAccountType, typeStr);
                  appData.write(kKeyfirstTime, false);

                  if (widget.isSignUp) {
                    if (_selectedType == AccountType.host ||
                        _selectedType == AccountType.businessPartner) {
                      NavigationService.navigateToWithArgs(
                        Routes.personalAccountInformationScreen,
                        {'accountType': _selectedType},
                      );
                    } else {
                      NavigationService.navigateToWithArgs(
                        Routes.signUpScreen,
                        {'accountType': _selectedType},
                      );
                    }
                  } else {
                    NavigationService.navigateToWithArgs(Routes.signInScreen, {
                      'accountType': _selectedType,
                    });
                  }
                },
                title: "Continue",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
