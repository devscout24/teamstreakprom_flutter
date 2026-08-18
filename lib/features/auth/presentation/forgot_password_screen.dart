import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../common_widgets/custom_textform_field.dart';
import '../../../common_widgets/custom_gradient_button.dart';
import '../../../common_widgets/custom_back_button.dart';
import '../../../constants/text_font_style.dart';
import '../../../gen/colors.gen.dart';
import '../../../helpers/ui_helpers.dart';
import '../../../helpers/navigation_service.dart';
import '../../../helpers/all_routes.dart';
import '../../../networks/api_acess.dart';
import '../../../common_widgets/custom_toast.dart';
import '../../../constants/validator.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController _emailController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  Future<void> _forgotPassword() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        final email = _emailController.text.trim();
        bool success = await forgotPasswordRxObj.forgotPassword({
          "email": email,
        });

        if (success) {
          final message =
              forgotPasswordRxObj.dataFetcher.value?.message ??
              "Password reset instructions sent!";
          customToastMessage("Success", message);

          NavigationService.navigateToWithArgs(Routes.otpScreen, {
            'type': "forgot_password",
            'email': email,
          });
        }
      } catch (e) {
        // error handled globally
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
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
                        "Forgot Password",
                        style: TextFontStyle.textStyle24cFFFFFFSFPro590
                            .copyWith(
                              fontSize: 24.sp,
                              fontWeight: FontWeight.w600,
                              fontFamily: "SF Pro",
                            ),
                      ),
                      UIHelper.verticalSpace(8),
                      Text(
                        "Enter your email address and we'll send you password reset instructions.",
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
                // Email Field
                CustomTextFormField(
                  controller: _emailController,
                  hintText: "Email",
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.done,
                  validator: emailValidator,
                ),
                UIHelper.verticalSpace(36),
                // Forgot Password Button
                CustomGradientButton(
                  onPressed: _isLoading ? null : _forgotPassword,
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
                          "Forgot Password",
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
