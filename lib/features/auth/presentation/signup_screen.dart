import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:teamstreakpromo/networks/api_acess.dart';
import '../../../common_widgets/custom_textform_field.dart';
import '../../../common_widgets/custom_gradient_button.dart';
import '../../../common_widgets/google_login_button.dart';
import '../../../common_widgets/custom_back_button.dart';
import '../../../constants/text_font_style.dart';
import '../../../gen/colors.gen.dart';
import '../../../helpers/ui_helpers.dart';
import '../../../helpers/navigation_service.dart';
import '../../../helpers/all_routes.dart';
import '../../../constants/validator.dart';
import 'package:dio/dio.dart';
import '../../../helpers/di.dart';
import '../../../constants/app_constants.dart';
import '../../../common_widgets/custom_toast.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool _is18Plus = false;
  bool _agreedToTerms = false;
  bool _isLoading = false;
  bool _is18PlusError = false;
  bool _agreedToTermsError = false;

  Future<void> _signUp() async {
    setState(() {
      _is18PlusError = !_is18Plus;
      _agreedToTermsError = !_agreedToTerms;
    });

    if (_formKey.currentState!.validate()) {
      if (!_is18Plus || !_agreedToTerms) {
        return;
      }

      setState(() {
        _isLoading = true;
      });

      try {
        FormData formData = FormData.fromMap({
          "agreesToTerms": "true",
          "businessName": "",
          "name": _nameController.text.trim(),
          "isAgeOver18": "true",
          "einNumber": "",
          "govtIdBackImage": "",
          "govtIdFrontImage": "",
          "businessLicenseBackImage": "",
          "businessLicenseFrontImage": "",
          "location": "",
          "role": appData.read(kAccountType) ?? "USER",
          "confirmPassword": _confirmPasswordController.text,
          "password": _passwordController.text,
          "businessDescription": "",
          "email": _emailController.text.trim(),
        });

        bool success = await signUpRxObj.signUp(formData);

        if (success) {
          final message = signUpRxObj.dataFetcher.value?.message ?? "Account created successfully!";
          customToastMessage("Success", message);
          NavigationService.navigateToWithArgs(Routes.otpScreen, {
            'type': "signup",
            'email': _emailController.text.trim(),
          });
        }
      } catch (e) {
        // error handling is in rx layer
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
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
                // Back Button
                const CustomBackButton(),
                UIHelper.verticalSpace(40),
                // Header Title
                Center(
                  child: Column(
                    children: [
                      Text(
                        "Create New Account",
                        style: TextFontStyle.textStyle24cFFFFFFSFPro590
                            .copyWith(
                              fontSize: 24.sp,
                              fontWeight: FontWeight.w600,
                              fontFamily: "SF Pro",
                            ),
                      ),
                      UIHelper.verticalSpace(8),
                      // Subtitle
                      Text(
                        "Enter your email to create new account",
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
                // Name Field
                CustomTextFormField(
                  controller: _nameController,
                  hintText: "Name",
                  keyboardType: TextInputType.name,
                  textInputAction: TextInputAction.next,
                  validator: nameValidator,
                ),
                UIHelper.verticalSpace(16),
                // Email Field
                CustomTextFormField(
                  controller: _emailController,
                  hintText: "Email",
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  validator: emailValidator,
                ),
                UIHelper.verticalSpace(16),
                // Password Field
                CustomTextFormField(
                  controller: _passwordController,
                  hintText: "Password",
                  isPassword: true,
                  textInputAction: TextInputAction.next,
                  validator: passwordValidator,
                ),
                UIHelper.verticalSpace(16),
                // Confirm Password Field
                CustomTextFormField(
                  controller: _confirmPasswordController,
                  hintText: "Confirm Password",
                  isPassword: true,
                  textInputAction: TextInputAction.done,
                  validator: (value) =>
                      confirmPasswordValidator(value, _passwordController.text),
                ),
                UIHelper.verticalSpace(16),

                // Checkbox 1: 18+ Years Old
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _is18Plus = !_is18Plus;
                      if (_is18Plus) _is18PlusError = false;
                    });
                  },
                  child: Row(
                    children: [
                      Container(
                        width: 20.w,
                        height: 20.w,
                        decoration: BoxDecoration(
                          color: _is18Plus
                              ? AppColors.cF28F31
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(4.r),
                          border: Border.all(
                            color: _is18Plus
                                ? AppColors.cF28F31
                                : _is18PlusError
                                ? Colors.redAccent
                                : Colors.white.withValues(alpha: 0.4),
                            width: 2.w,
                          ),
                        ),
                        child: _is18Plus
                            ? const Icon(
                                Icons.check,
                                color: Colors.white,
                                size: 14,
                              )
                            : null,
                      ),
                      UIHelper.horizontalSpace(12),
                      Text(
                        "I am 18+ years old",
                        style: TextFontStyle.textStyle14cFFFFFFSFProRounded400
                            .copyWith(
                              fontSize: 12.sp,
                              fontFamily: "SF Pro",
                              color: _is18PlusError
                                  ? Colors.redAccent
                                  : Colors.white.withValues(alpha: 0.8),
                            ),
                      ),
                    ],
                  ),
                ),
                UIHelper.verticalSpace(12),

                // Checkbox 2: Agree to Terms & Conditions
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _agreedToTerms = !_agreedToTerms;
                      if (_agreedToTerms) _agreedToTermsError = false;
                    });
                  },
                  child: Row(
                    children: [
                      Container(
                        width: 20.w,
                        height: 20.w,
                        decoration: BoxDecoration(
                          color: _agreedToTerms
                              ? AppColors.cF28F31
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(4.r),
                          border: Border.all(
                            color: _agreedToTerms
                                ? AppColors.cF28F31
                                : _agreedToTermsError
                                ? Colors.redAccent
                                : Colors.white.withValues(alpha: 0.4),
                            width: 2.w,
                          ),
                        ),
                        child: _agreedToTerms
                            ? const Icon(
                                Icons.check,
                                color: Colors.white,
                                size: 14,
                              )
                            : null,
                      ),
                      UIHelper.horizontalSpace(12),
                      RichText(
                        text: TextSpan(
                          text: "I agree to all ",
                          style: TextFontStyle.textStyle14cFFFFFFSFProRounded400
                              .copyWith(
                                fontSize: 12.sp,
                                fontFamily: "SF Pro",
                                color: _agreedToTermsError
                                    ? Colors.redAccent
                                    : Colors.white.withValues(alpha: 0.8),
                              ),
                          children: [
                            TextSpan(
                              text: "Terms & Conditions",
                              style: TextStyle(
                                fontFamily: "SF Pro",
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w600,
                                color: AppColors
                                    .primaryColorSecond, // Green Highlight
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                UIHelper.verticalSpace(36),

                // Sign Up Button
                CustomGradientButton(
                  onPressed: _isLoading ? null : _signUp,
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
                          "Sign Up",
                          style: TextFontStyle.textStyle16c000000SFPro590
                              .copyWith(
                                fontWeight: FontWeight.w700,
                                color: AppColors.c262824,
                              ),
                        ),
                ),
                UIHelper.verticalSpace(24),
                // Divider
                Row(
                  children: [
                    Expanded(
                      child: Divider(
                        color: Colors.white.withValues(alpha: 0.1),
                        thickness: 1.w,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: Text(
                        "or register with",
                        style: TextFontStyle.textStyle14cFFFFFFSFProRounded400
                            .copyWith(
                              fontSize: 12.sp,
                              color: Colors.white.withValues(alpha: 0.8),
                            ),
                      ),
                    ),
                    Expanded(
                      child: Divider(
                        color: Colors.white.withValues(alpha: 0.1),
                        thickness: 1.w,
                      ),
                    ),
                  ],
                ),
                UIHelper.verticalSpace(24),
                // Google Button
                GoogleLoginButton(
                  onTap: () {
                    // Perform google login action
                  },
                ),
                UIHelper.verticalSpace(36),
                // Login link
                Center(
                  child: RichText(
                    text: TextSpan(
                      text: "Already have an account? ",
                      style: TextFontStyle.textStyle14cFFFFFFSFProRounded400
                          .copyWith(color: AppColors.cC6C6C6),
                      children: [
                        TextSpan(
                          text: "Log In",
                          style: TextStyle(
                            fontFamily: "SF Pro",
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColors.cF28F31, // Orange Highlight
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              NavigationService.navigateToReplacement(
                                Routes.signInScreen,
                              );
                            },
                        ),
                      ],
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
