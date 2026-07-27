import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../common_widgets/custom_gradient_button.dart';
import '../../../common_widgets/custom_back_button.dart';
import '../../../constants/text_font_style.dart';
import '../../../gen/colors.gen.dart';
import '../../../helpers/ui_helpers.dart';
import '../../../helpers/navigation_service.dart';
import '../../../helpers/all_routes.dart';

class OtpVerificationScreen extends StatefulWidget {
  const OtpVerificationScreen({
    super.key,
    this.email = "jessicawilson@examle.com",
    this.type,
  });

  final String email;
  final String? type;

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  final int _otpLength = 5;
  late List<TextEditingController> _controllers;
  late List<FocusNode> _focusNodes;

  int _resendSeconds = 37;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(_otpLength, (_) => TextEditingController());
    _focusNodes = List.generate(_otpLength, (_) => FocusNode());
    _startTimer();
  }

  void _startTimer() {
    _timer?.cancel();
    setState(() => _resendSeconds = 37);
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_resendSeconds == 0) {
        timer.cancel();
      } else {
        setState(() => _resendSeconds--);
      }
    });
  }

  String get _formattedTime {
    final minutes = _resendSeconds ~/ 60;
    final seconds = _resendSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  void _onChanged(int index, String value) {
    if (value.isNotEmpty && index < _otpLength - 1) {
      _focusNodes[index + 1].requestFocus();
    } else if (value.isEmpty && index > 0) {
      _focusNodes[index - 1].requestFocus();
    }
  }

  String get _otp => _controllers.map((c) => c.text).join();

  @override
  void dispose() {
    _timer?.cancel();
    for (final c in _controllers) {
      c.dispose();
    }
    for (final f in _focusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
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
                      "OTP Verification",
                      style: TextFontStyle.textStyle24cFFFFFFSFPro590.copyWith(
                        fontSize: 24.sp,
                        fontWeight: FontWeight.w600,
                        fontFamily: "SF Pro",
                      ),
                    ),
                    UIHelper.verticalSpace(8),
                    Text(
                      "We have sent a verification code to email address",
                      textAlign: TextAlign.center,
                      style: TextFontStyle.textStyle14cFFFFFFSFProRounded400
                          .copyWith(
                            color: AppColors.c9B9C9A,
                            fontFamily: "SF Pro",
                          ),
                    ),
                    UIHelper.verticalSpace(4),
                    Text(
                      widget.email,
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
              UIHelper.verticalSpace(40),
              // OTP Boxes
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(_otpLength, (index) {
                  return _OtpBox(
                    controller: _controllers[index],
                    focusNode: _focusNodes[index],
                    onChanged: (val) => _onChanged(index, val),
                  );
                }),
              ),
              UIHelper.verticalSpace(40),
              // Verify Button
              CustomGradientButton(
                onPressed: () {
                  if (_otp.length == _otpLength) {
                    if (widget.type != null) {
                      NavigationService.navigateToUntilReplacement(
                        Routes.signInScreen,
                      );
                    } else {
                      NavigationService.navigateTo(
                        Routes.createNewPasswordScreen,
                      );
                    }
                  }
                },
                title: "Verify OTP",
              ),
              UIHelper.verticalSpace(24),
              // Resend Timer
              Center(
                child: _resendSeconds > 0
                    ? RichText(
                        text: TextSpan(
                          text: "Resend code in ",
                          style: TextFontStyle.textStyle14cFFFFFFSFProRounded400
                              .copyWith(
                                color: AppColors.c9B9C9A,
                                fontFamily: "SF Pro",
                              ),
                          children: [
                            TextSpan(
                              text: _formattedTime,
                              style: TextStyle(
                                fontFamily: "SF Pro",
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w600,
                                color: AppColors.cF28F31,
                              ),
                            ),
                          ],
                        ),
                      )
                    : GestureDetector(
                        onTap: _startTimer,
                        child: Text(
                          "Resend Code",
                          style: TextFontStyle.textStyle14cFFFFFFSFProRounded400
                              .copyWith(
                                color: AppColors.cF28F31,
                                fontFamily: "SF Pro",
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                      ),
              ),
              UIHelper.verticalSpace(24),
            ],
          ),
        ),
      ),
    );
  }
}

class _OtpBox extends StatefulWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final ValueChanged<String> onChanged;

  const _OtpBox({
    required this.controller,
    required this.focusNode,
    required this.onChanged,
  });

  @override
  State<_OtpBox> createState() => _OtpBoxState();
}

class _OtpBoxState extends State<_OtpBox> {
  @override
  void initState() {
    super.initState();
    widget.focusNode.addListener(() => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    final bool isFocused = widget.focusNode.hasFocus;
    final bool hasFilled = widget.controller.text.isNotEmpty;

    return Container(
      width: 52.w,
      height: 56.h,
      decoration: BoxDecoration(
        color: hasFilled
            ? AppColors.primaryColorSecond.withValues(alpha: 0.25)
            : const Color(0xFF1E222B),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: isFocused
              ? AppColors.primaryColorSecond
              : hasFilled
              ? AppColors.primaryColorSecond.withValues(alpha: 0.5)
              : Colors.white.withValues(alpha: 0.08),
          width: 1.5.w,
        ),
      ),
      child: Center(
        child: TextFormField(
          controller: widget.controller,
          focusNode: widget.focusNode,
          textAlign: TextAlign.center,
          keyboardType: TextInputType.number,
          maxLength: 1,
          style: TextFontStyle.textStyle24cFFFFFFSFPro590.copyWith(
            fontSize: 22.sp,
            fontFamily: "SF Pro",
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
          decoration: const InputDecoration(
            counterText: "",
            border: InputBorder.none,
            focusedBorder: InputBorder.none,
            enabledBorder: InputBorder.none,
            isDense: true,
            contentPadding: EdgeInsets.zero,
          ),
          onChanged: (val) {
            setState(() {});
            widget.onChanged(val);
          },
        ),
      ),
    );
  }
}
