import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../common_widgets/custom_back_button.dart';
import '../../../common_widgets/custom_gradient_button.dart';
import '../../../common_widgets/custom_textform_field.dart';
import '../../../common_widgets/custom_toast.dart';
import '../../../constants/text_font_style.dart';
import '../../../constants/validator.dart';
import '../../../gen/colors.gen.dart';
import '../../../helpers/ui_helpers.dart';
import '../../../networks/api_acess.dart';

class SecurityScreen extends StatefulWidget {
  const SecurityScreen({super.key});

  @override
  State<SecurityScreen> createState() => _SecurityScreenState();
}

class _SecurityScreenState extends State<SecurityScreen> {
  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  @override
  void dispose() {
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _changePassword() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final response = await changePasswordRxObj.changePassword(
        oldPassword: _oldPasswordController.text,
        newPassword: _newPasswordController.text,
        confirmPassword: _confirmPasswordController.text,
      );

      customToastMessage(
        "Success",
        response.message ?? "Password changed successfully",
      );

      _oldPasswordController.clear();
      _newPasswordController.clear();
      _confirmPasswordController.clear();

      if (mounted) {
        Navigator.pop(context);
      }
    } catch (_) {
      // Error message is handled and shown by RxResponseInt handleErrorWithReturn
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
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
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
        child: Form(
          key: _formKey,
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
                textInputAction: TextInputAction.next,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Please enter your old password";
                  }
                  return null;
                },
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
                textInputAction: TextInputAction.next,
                validator: passwordValidator,
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
                textInputAction: TextInputAction.done,
                validator: (value) => confirmPasswordValidator(
                  value,
                  _newPasswordController.text,
                ),
              ),
              UIHelper.verticalSpace(48.h),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.all(16.w),
        child: CustomGradientButton(
          onPressed: _isLoading ? null : _changePassword,
          title: _isLoading ? null : "Change Password",
          height: 52.h,
          borderRadius: BorderRadius.circular(100.r),
          textStyle: TextFontStyle.textStyle14cFFFFFFSFProRounded400.copyWith(
            color: const Color(0xFF1E211A),
            fontWeight: FontWeight.w700,
            fontSize: 16.sp,
          ),
          child: _isLoading
              ? SizedBox(
                  width: 24.w,
                  height: 24.w,
                  child: const CircularProgressIndicator(
                    color: Color(0xFF1E211A),
                    strokeWidth: 2.5,
                  ),
                )
              : null,
        ),
      ),
    );
  }
}
