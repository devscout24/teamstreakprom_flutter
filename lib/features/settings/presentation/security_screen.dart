import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../common_widgets/custom_back_button.dart';
import '../../../common_widgets/custom_gradient_button.dart';
import '../../../common_widgets/custom_textform_field.dart';
import '../../../constants/text_font_style.dart';
import '../../../gen/colors.gen.dart';
import '../../../helpers/ui_helpers.dart';

class SecurityScreen extends StatefulWidget {
  const SecurityScreen({super.key});

  @override
  State<SecurityScreen> createState() => _SecurityScreenState();
}

class _SecurityScreenState extends State<SecurityScreen> {
  final TextEditingController _oldPasswordController = TextEditingController(text: "12345678");
  final TextEditingController _newPasswordController = TextEditingController(text: "12345678");
  final TextEditingController _confirmPasswordController = TextEditingController(text: "12345678");

  @override
  void dispose() {
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

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
              "Security",
              style: TextFontStyle.textStyle24cFFFFFFSFPro590.copyWith(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            centerTitle: true,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 24.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Change Password",
              style: TextFontStyle.textStyle24cFFFFFFSFPro590.copyWith(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            UIHelper.verticalSpace(8.h),
            Text(
              "Keep your account secure by updating your password.",
              style: TextFontStyle.textStyle14cFFFFFFSFProRounded400.copyWith(
                color: Colors.white.withValues(alpha: 0.6),
                fontSize: 13.sp,
              ),
            ),
            UIHelper.verticalSpace(32.h),

            // Old Password
            Text(
              "Old Password",
              style: TextFontStyle.textStyle14cFFFFFFSFProRounded400.copyWith(
                fontWeight: FontWeight.w500,
                fontSize: 14.sp,
              ),
            ),
            UIHelper.verticalSpace(8.h),
            CustomTextFormField(
              controller: _oldPasswordController,
              hintText: "Enter old password",
              isPassword: true,
            ),
            UIHelper.verticalSpace(24.h),

            // New Password
            Text(
              "New Password",
              style: TextFontStyle.textStyle14cFFFFFFSFProRounded400.copyWith(
                fontWeight: FontWeight.w500,
                fontSize: 14.sp,
              ),
            ),
            UIHelper.verticalSpace(8.h),
            CustomTextFormField(
              controller: _newPasswordController,
              hintText: "Enter new password",
              isPassword: true,
            ),
            UIHelper.verticalSpace(24.h),

            // Confirm Password
            Text(
              "Confirm New Password",
              style: TextFontStyle.textStyle14cFFFFFFSFProRounded400.copyWith(
                fontWeight: FontWeight.w500,
                fontSize: 14.sp,
              ),
            ),
            UIHelper.verticalSpace(8.h),
            CustomTextFormField(
              controller: _confirmPasswordController,
              hintText: "Confirm new password",
              isPassword: true,
            ),
            UIHelper.verticalSpace(48.h),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.all(16.w),
        child: CustomGradientButton(
          onPressed: () {
            // Change password action
          },
          title: "Change Password",
          height: 52.h,
          borderRadius: BorderRadius.circular(100.r),
          textStyle: TextFontStyle.textStyle14cFFFFFFSFProRounded400.copyWith(
            color: const Color(0xFF1E211A),
            fontWeight: FontWeight.w700,
            fontSize: 16.sp,
          ),
        ),
      ),
    );
  }
}
