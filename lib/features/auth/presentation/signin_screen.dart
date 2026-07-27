import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:teamstreakpromo/features/business_partner_employee/business_partner_employee_nav.dart';
import '../../../common_widgets/custom_textform_field.dart';
import '../../../common_widgets/custom_gradient_button.dart';
import '../../../common_widgets/google_login_button.dart';
import '../../../constants/text_font_style.dart';
import '../../../gen/colors.gen.dart';
import '../../../helpers/ui_helpers.dart';
import '../../../helpers/navigation_service.dart';
import '../../../helpers/all_routes.dart';
import 'package:teamstreakpromo/features/auth/presentation/choose_account_type_screen.dart';
import 'package:teamstreakpromo/features/host_employee_feature/bottom_nav_bar/presentation/host_employee_navigation_screen.dart';
import 'package:teamstreakpromo/helpers/di.dart';
import 'package:teamstreakpromo/constants/app_constants.dart';

class SigninScreen extends StatefulWidget {
  final AccountType? accountType;

  const SigninScreen({super.key, this.accountType});

  @override
  State<SigninScreen> createState() => _SigninScreenState();
}

class _SigninScreenState extends State<SigninScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  AccountType? _currentAccountType;

  @override
  void initState() {
    super.initState();
    _checkAccountType();
  }

  void _checkAccountType() {
    if (widget.accountType != null) {
      _currentAccountType = widget.accountType;
    } else {
      String? storedType = appData.read(kAccountType);
      if (storedType == AccountType.host.name || storedType == AccountType.host.toString()) {
        _currentAccountType = AccountType.host;
      } else if (storedType == AccountType.businessPartner.name || storedType == AccountType.businessPartner.toString()) {
        _currentAccountType = AccountType.businessPartner;
      } else if (storedType == AccountType.user.name || storedType == AccountType.user.toString()) {
        _currentAccountType = AccountType.user;
      }
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
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
                UIHelper.verticalSpace(60),
                // Welcome Title
                Center(
                  child: Column(
                    children: [
                      Text(
                        "Welcome Back",
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
                        "Enter your email to login",
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
                  textInputAction: TextInputAction.next,
                ),
                UIHelper.verticalSpace(16),
                // Password Field
                CustomTextFormField(
                  controller: _passwordController,
                  hintText: "Password",
                  isPassword: true,
                  textInputAction: TextInputAction.done,
                ),
                UIHelper.verticalSpace(16),
                // Forgot Password (right aligned)
                Align(
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                    onTap: () {
                      NavigationService.navigateTo(Routes.forgotPWScreen);
                    },
                    child: Text(
                      "Forgot Password?",
                      style: TextFontStyle.textStyle14cFFFFFFSFProRounded400
                          .copyWith(
                            decoration: TextDecoration.underline,
                            decorationColor: Colors.white.withValues(
                              alpha: 0.6,
                            ),
                            color: Colors.white.withValues(alpha: 0.8),
                          ),
                    ),
                  ),
                ),
                UIHelper.verticalSpace(36),
                // Login Button
                CustomGradientButton(
                  onPressed: () {
                    final email = _emailController.text.trim();
                    final password = _passwordController.text.trim();

                    if (email == "employee@gmail.com" &&
                        password == "12345678") {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              const HostEmployeeNavigationScreen(),
                        ),
                      );
                    } else if (email == "businesspartner@gmail.com" &&
                        password == "12345678") {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              const BusinessPartnerEmployeeNav(),
                        ),
                      );
                    } else {
                      if (_currentAccountType != null) {
                        appData.write(
                          kAccountType,
                          _currentAccountType.toString(),
                        );
                      }

                      if (_currentAccountType == AccountType.host) {
                        NavigationService.navigateToWithArgs(
                          Routes.subscriptionScreen,
                          {'accountType': _currentAccountType},
                        );
                      } else if (_currentAccountType ==
                          AccountType.businessPartner) {
                        NavigationService.navigateToWithArgs(
                          Routes.subscriptionScreen,
                          {'accountType': _currentAccountType},
                        );
                      } else {
                        NavigationService.navigateTo(Routes.pickInterestScreen);
                      }
                    }
                  },
                  title: "Log In",
                ),
                UIHelper.verticalSpace(24),
                // "or log in with" divider
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
                        "or log in with",
                        style: TextFontStyle.textStyle14cFFFFFFSFProRounded400
                            .copyWith(
                              fontSize: 12.sp,
                              color: Colors.white.withValues(alpha: 0.6),
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
                // Sign Up link
                Center(
                  child: RichText(
                    text: TextSpan(
                      text: "Don't have an account? ",
                      style: TextFontStyle.textStyle14cFFFFFFSFProRounded400
                          .copyWith(color: AppColors.cC6C6C6),
                      children: [
                        TextSpan(
                          text: "Sign Up",
                          style: TextStyle(
                            fontFamily: "SF Pro",
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColors.cF28F31, // Orange highlight
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              if (_currentAccountType == AccountType.host || 
                                  _currentAccountType == AccountType.businessPartner) {
                                NavigationService.navigateTo(
                                  Routes.personalAccountInformationScreen,
                                );
                              } else {
                                NavigationService.navigateTo(
                                  Routes.signUpScreen,
                                );
                              }
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
