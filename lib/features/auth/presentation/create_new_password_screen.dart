import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:teamstreakpromo/helpers/all_routes.dart';
import 'package:teamstreakpromo/helpers/navigation_service.dart';
import '../../../common_widgets/custom_textform_field.dart';
import '../../../common_widgets/custom_gradient_button.dart';
import '../../../common_widgets/custom_back_button.dart';
import '../../../constants/text_font_style.dart';
import '../../../gen/colors.gen.dart';
import '../../../helpers/ui_helpers.dart';
import '../../../networks/api_acess.dart';
import '../../../common_widgets/custom_toast.dart';
import '../../../constants/validator.dart';

class CreateNewPasswordScreen extends StatefulWidget {
  final String? email;
  final String? resetToken;

  const CreateNewPasswordScreen({super.key, this.email, this.resetToken});

  @override
  State<CreateNewPasswordScreen> createState() =>
      _CreateNewPasswordScreenState();
}

class _CreateNewPasswordScreenState extends State<CreateNewPasswordScreen> {
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  Future<void> _resetPassword() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        bool success = await resetPasswordRxObj.resetPassword({
          "resetToken": widget.resetToken,
          "newPassword": _newPasswordController.text,
          "confirmPassword": _confirmPasswordController.text,
        });

        if (success) {
          final message =
              resetPasswordRxObj.dataFetcher.value?.message ??
              "Password reset successfully!";
          customToastMessage("Success", message);

          NavigationService.navigateToReplacement(Routes.signInScreen);
        }
      } catch (e) {
        // Error handled globally
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                UIHelper.verticalSpace(16),
                const CustomBackButton(),
                UIHelper.verticalSpace(40),
                // Title
                Center(
                  child: Column(
                    children: [
                      Text(
                        "Create New Password",
                        style: TextFontStyle.textStyle24cFFFFFFSFPro590
                            .copyWith(
                              fontSize: 24.sp,
                              fontWeight: FontWeight.w600,
                              fontFamily: "SF Pro",
                            ),
                      ),
                      UIHelper.verticalSpace(8),
                      Text(
                        "Please enter a new password. Your new password must be different from previous password.",
                        textAlign: TextAlign.center,
                        style: TextFontStyle.textStyle14cFFFFFFSFProRounded400
                            .copyWith(
                              color: AppColors.c9B9C9A,
                              fontFamily: "SF Pro",
                            ),
                      ),
                    ],
                  ),
                ),
                UIHelper.verticalSpace(36),
                // New Password Field
                CustomTextFormField(
                  controller: _newPasswordController,
                  hintText: "New Password",
                  isPassword: true,
                  textInputAction: TextInputAction.next,
                  validator: passwordValidator,
                ),
                UIHelper.verticalSpace(16),
                // Confirm New Password Field
                CustomTextFormField(
                  controller: _confirmPasswordController,
                  hintText: "Confirm New Password",
                  isPassword: true,
                  textInputAction: TextInputAction.done,
                  validator: (value) => confirmPasswordValidator(
                    value,
                    _newPasswordController.text,
                  ),
                ),
                UIHelper.verticalSpace(36),
                // Reset Password Button
                CustomGradientButton(
                  onPressed: _isLoading ? null : _resetPassword,
                  child: _isLoading
                      ? const SizedBox(
                          height: 24,
                          width: 24,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : Text(
                          "Reset Password",
                          style: TextFontStyle.textStyle16c000000SFPro590
                              .copyWith(
                                fontWeight: FontWeight.w700,
                                color: AppColors.c262824,
                              ),
                        ),
                ),
                UIHelper.verticalSpace(24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
