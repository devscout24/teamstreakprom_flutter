import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:teamstreakpromo/common_widgets/custom_textform_field.dart';
import 'package:teamstreakpromo/common_widgets/custom_back_button.dart';
import 'package:teamstreakpromo/common_widgets/custom_gradient_button.dart';
import 'package:teamstreakpromo/constants/text_font_style.dart';
import 'package:teamstreakpromo/gen/colors.gen.dart';
import 'package:teamstreakpromo/helpers/ui_helpers.dart';
import 'package:teamstreakpromo/features/host_features/auth/widget/auth_progress_indicator.dart';
import 'package:teamstreakpromo/constants/validator.dart';
import 'package:teamstreakpromo/helpers/navigation_service.dart';
import 'package:teamstreakpromo/helpers/all_routes.dart';

class PersonalAccountInformationScreen extends StatefulWidget {
  const PersonalAccountInformationScreen({super.key});

  @override
  State<PersonalAccountInformationScreen> createState() =>
      _PersonalAccountInformationScreenState();
}

class _PersonalAccountInformationScreenState
    extends State<PersonalAccountInformationScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // Form is valid, print details and navigate to Step 2
      debugPrint("Full Name: ${_fullNameController.text}");
      debugPrint("Email: ${_emailController.text}");
      debugPrint("Phone: ${_phoneController.text}");
      debugPrint("Password: ${_passwordController.text}");

      NavigationService.navigateTo(Routes.businessDetailsScreen);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldColor,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      UIHelper.verticalSpace(16),
                      // Back Button
                      const CustomBackButton(),
                      UIHelper.verticalSpace(32),

                      // Title
                      Text(
                        "Personal Account Information",
                        style: TextFontStyle.textStyle24cFFFFFFSFPro590.copyWith(
                          fontSize: 24.sp,
                          fontWeight: FontWeight.w600,
                          fontFamily: "SF Pro Rounded",
                        ),
                      ),
                      UIHelper.verticalSpace(8),

                      // Subtitle
                      Text(
                        "Setup your administrative account security. This owner account controls the business entity.",
                        style: TextFontStyle.textStyle14cFFFFFFSFProRounded400.copyWith(
                          color: AppColors.cFFFFFF.withValues(alpha: 0.6),
                          fontFamily: "SF Pro",
                        ),
                      ),
                      UIHelper.verticalSpace(24),

                      // Progress Indicator (Step 1 of 4)
                      const AuthProgressIndicator(
                        currentStep: 1,
                        totalSteps: 4,
                      ),
                      UIHelper.verticalSpace(36),

                      // Fields
                      CustomTextFormField(
                        controller: _fullNameController,
                        hintText: "Full Name",
                        keyboardType: TextInputType.name,
                        textInputAction: TextInputAction.next,
                        validator: nameValidator,
                      ),
                      UIHelper.verticalSpace(16),

                      CustomTextFormField(
                        controller: _emailController,
                        hintText: "Email",
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        validator: emailValidator,
                      ),
                      UIHelper.verticalSpace(16),

                      CustomTextFormField(
                        controller: _phoneController,
                        hintText: "Phone Number",
                        keyboardType: TextInputType.phone,
                        textInputAction: TextInputAction.next,
                        validator: validatePhoneNumber,
                      ),
                      UIHelper.verticalSpace(16),

                      CustomTextFormField(
                        controller: _passwordController,
                        hintText: "Password",
                        isPassword: true,
                        textInputAction: TextInputAction.next,
                        validator: passwordValidator,
                      ),
                      UIHelper.verticalSpace(16),

                      CustomTextFormField(
                        controller: _confirmPasswordController,
                        hintText: "Confirm Password",
                        isPassword: true,
                        textInputAction: TextInputAction.done,
                        validator: (value) => confirmPasswordValidator(
                          value,
                          _passwordController.text,
                        ),
                      ),
                      UIHelper.verticalSpace(40),
                    ],
                  ),
                ),
              ),
            ),
            // Floating bottom Continue button (not scrolled with form)
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
              child: CustomGradientButton(
                onPressed: _submitForm,
                title: "Continue",
              ),
            ),
          ],
        ),
      ),
    );
  }
}
