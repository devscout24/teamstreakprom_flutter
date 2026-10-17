import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../common_widgets/custom_back_button.dart';
import '../../../common_widgets/gradient_container.dart';
import '../../../constants/text_font_style.dart';
import '../../../gen/colors.gen.dart';
import '../../../helpers/ui_helpers.dart';
import '../../../helpers/all_routes.dart';
import '../../../helpers/navigation_service.dart';

class SupportOptionsScreen extends StatelessWidget {
  const SupportOptionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldColor,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: Padding(
          padding: EdgeInsets.all(8.r),
          child: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: const CustomBackButton(),
            title: Text(
              "Streak Customer Support",
              style: TextFontStyle.textStyle24cFFFFFFSFPro590.copyWith(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            centerTitle: true,
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 32.h),
        child: Column(
          children: [
            const Spacer(),
            GradientContainer(
              padding: EdgeInsets.fromLTRB(20.w, 24.h, 20.w, 24.h),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "How can we help you?",
                    style: TextFontStyle.textStyle24cFFFFFFSFPro590.copyWith(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.cFFF9F3,
                      fontFamily: "SF Pro",
                    ),
                  ),
                  UIHelper.verticalSpace(20.h),
                  _buildOptionButton(
                    context,
                    "I have a concern about the event.",
                  ),
                  UIHelper.verticalSpace(12.h),
                  _buildOptionButton(context, "Trouble viewing Neon Nights."),
                  UIHelper.verticalSpace(12.h),
                  _buildOptionButton(context, "Feedback on Neon Nights event."),
                  UIHelper.verticalSpace(12.h),
                  _buildOptionButton(context, "Others"),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionButton(BuildContext context, String text) {
    return InkWell(
      onTap: () async {
        final result = await NavigationService.navigateToWithArgs(
          Routes.submitProblemScreen,
          {'topic': text},
        );
        if (result == true && context.mounted) {
          NavigationService.goBack;
        }
      },
      borderRadius: BorderRadius.circular(100.r),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 16.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100.r),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.4),
            width: 1,
          ),
        ),
        child: Center(
          child: Text(
            text,
            style: TextFontStyle.textStyle14cFFFFFFSFProRounded400.copyWith(
              color: AppColors.cE9EAE9,
              fontWeight: FontWeight.w500,
              fontSize: 13.sp,
              fontFamily: "SF Pro",
            ),
          ),
        ),
      ),
    );
  }
}
