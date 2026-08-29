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

  void _showTermsAndConditionsDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => _TermsAndConditionsDialog(
        onAgreed: () {
          setState(() {
            _agreedToTerms = true;
            _agreedToTermsError = false;
          });
          Navigator.pop(context);
        },
      ),
    );
  }

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
          final message =
              signUpRxObj.dataFetcher.value?.message ??
              "Account created successfully!";
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
                    if (_agreedToTerms) {
                      setState(() {
                        _agreedToTerms = false;
                      });
                    } else {
                      _showTermsAndConditionsDialog();
                    }
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

class _TermsAndConditionsDialog extends StatefulWidget {
  final VoidCallback onAgreed;
  const _TermsAndConditionsDialog({required this.onAgreed});

  @override
  State<_TermsAndConditionsDialog> createState() =>
      _TermsAndConditionsDialogState();
}

class _TermsAndConditionsDialogState extends State<_TermsAndConditionsDialog> {
  final ScrollController _scrollController = ScrollController();
  bool _isScrolledToBottom = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 20) {
        if (!_isScrolledToBottom) {
          setState(() {
            _isScrolledToBottom = true;
          });
        }
      }
    });
    // Check if content is smaller than screen initially
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients &&
          _scrollController.position.maxScrollExtent <= 0) {
        setState(() {
          _isScrolledToBottom = true;
        });
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 40.h),
      backgroundColor: AppColors.scaffoldColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
      child: Padding(
        padding: EdgeInsets.all(20.w),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Terms and Conditions",
                  style: TextFontStyle.textStyle24cFFFFFFSFPro590.copyWith(
                    fontSize: 20.sp,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            UIHelper.verticalSpace(16),
            Expanded(
              child: Scrollbar(
                controller: _scrollController,
                thumbVisibility: true,
                child: SingleChildScrollView(
                  controller: _scrollController,
                  child: Text(
                    "Welcome to Team Streak Promo!\n\n"
                    "These terms and conditions outline the rules and regulations for the use of our app.\n\n"
                    "By accessing this app we assume you accept these terms and conditions. Do not continue to use the app if you do not agree to take all of the terms and conditions stated on this page.\n\n"
                    "1. Introduction\n"
                    "By using our app you accept these terms and conditions in full; accordingly, if you disagree with these terms and conditions or any part of these terms and conditions, you must not use our app.\n\n"
                    "2. License to use app\n"
                    "Unless otherwise stated, we or our licensors own the intellectual property rights in the app and material on the app. Subject to the license below, all these intellectual property rights are reserved.\n\n"
                    "3. Acceptable use\n"
                    "You must not use our app in any way that causes, or may cause, damage to the app or impairment of the availability or accessibility of the app; or in any way which is unlawful, illegal, fraudulent or harmful, or in connection with any unlawful, illegal, fraudulent or harmful purpose or activity.\n\n"
                    "4. Restricted access\n"
                    "Access to certain areas of our app is restricted. We reserve the right to restrict access to other areas of our app, or indeed our whole app, at our discretion.\n\n"
                    "5. User content\n"
                    "In these terms and conditions, “your user content” means material (including without limitation text, images, audio material, video material and audio-visual material) that you submit to our app, for whatever purpose.\n\n"
                    "6. Limited warranties\n"
                    "We do not warrant the completeness or accuracy of the information published on this app; nor do we commit to ensuring that the app remains available or that the material on the app is kept up-to-date.\n\n"
                    "7. Breaches of these terms and conditions\n"
                    "Without prejudice to our other rights under these terms and conditions, if you breach these terms and conditions in any way, we may take such action as we deem appropriate to deal with the breach, including suspending your access to the app, prohibiting you from accessing the app.\n\n"
                    "8. Variation\n"
                    "We may revise these terms and conditions from time to time. Revised terms and conditions will apply to the use of our app from the date of the publication of the revised terms and conditions on our app.\n\n"
                    "9. Assignment\n"
                    "We may transfer, sub-contract or otherwise deal with our rights and/or obligations under these terms and conditions without notifying you or obtaining your consent.\n\n"
                    "10. Severability\n"
                    "If a provision of these terms and conditions is determined by any court or other competent authority to be unlawful and/or unenforceable, the other provisions will continue in effect.\n\n"
                    "Please scroll to the bottom to agree to the terms.",
                    style: TextFontStyle.textStyle14cFFFFFFSFProRounded400
                        .copyWith(color: Colors.white.withValues(alpha: 0.8)),
                  ),
                ),
              ),
            ),
            UIHelper.verticalSpace(16),
            Opacity(
              opacity: _isScrolledToBottom ? 1.0 : 0.5,
              child: CustomGradientButton(
                onPressed: _isScrolledToBottom ? widget.onAgreed : null,
                child: Text(
                  "I have read and agree",
                  textAlign: TextAlign.center,
                  style: TextFontStyle.textStyle16c000000SFPro590.copyWith(
                    fontWeight: FontWeight.w700,
                    fontSize: 14.sp,
                    color: AppColors.c262824,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
