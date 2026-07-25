import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../gen/colors.gen.dart';
import '../../../../../constants/text_font_style.dart';
import '../../../../../helpers/ui_helpers.dart';
import '../../../../../common_widgets/custom_gradient_button.dart';

class VerifyRedeemBottomSheet extends StatefulWidget {
  const VerifyRedeemBottomSheet({super.key});

  @override
  State<VerifyRedeemBottomSheet> createState() =>
      _VerifyRedeemBottomSheetState();
}

class _VerifyRedeemBottomSheetState extends State<VerifyRedeemBottomSheet> {
  final int _otpLength = 4;
  late List<TextEditingController> _controllers;
  late List<FocusNode> _focusNodes;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(_otpLength, (_) => TextEditingController());
    _focusNodes = List.generate(_otpLength, (_) => FocusNode());
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
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
      decoration: BoxDecoration(
        color: const Color(0xFF171A20),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(32.r),
          topRight: Radius.circular(32.r),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 60.w,
            height: 4.h,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(100.r),
            ),
          ),
          UIHelper.verticalSpace(32.h),
          Text(
            "Verify Redeem Request",
            style: TextFontStyle.textStyle24cFFFFFFSFPro590.copyWith(
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
          UIHelper.verticalSpace(12.h),
          Text(
            "Ask the customer for the 4-digit code to verify and complete the redemption.",
            textAlign: TextAlign.center,
            style: TextFontStyle.textStyle14cFFFFFFSFProRounded400.copyWith(
              color: AppColors.cADADAD,
              fontFamily: "SF Pro",
              fontWeight: FontWeight.w400,
              fontSize: 13.sp,
            ),
          ),
          UIHelper.verticalSpace(24.h),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 24.h),
            decoration: BoxDecoration(
              color: const Color(0xFF1E222B),
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.05),
                width: 1.w,
              ),
            ),
            child: Column(
              children: [
                Text(
                  "Enter 4-Digit Code",
                  style: TextFontStyle.textStyle14cFFFFFFSFProRounded400
                      .copyWith(
                        fontWeight: FontWeight.w500,
                        color: AppColors.cC6C6C6,
                      ),
                ),
                UIHelper.verticalSpace(16.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(_otpLength, (index) {
                    return _VerifyBox(
                      controller: _controllers[index],
                      focusNode: _focusNodes[index],
                      onChanged: (val) => _onChanged(index, val),
                    );
                  }),
                ),
              ],
            ),
          ),
          UIHelper.verticalSpace(32.h),
          CustomGradientButton(
            onPressed: () {
              if (_otp.length == _otpLength) {
                Navigator.pop(context); // Handle approval here
              }
            },
            title: "Verify & Approve",
            height: 48.h,
            textStyle: TextFontStyle.textStyle16c000000SFPro590.copyWith(
              fontWeight: FontWeight.w700,
              color: const Color(0xFF1B1C1A),
            ),
          ),
          UIHelper.verticalSpace(16.h),
        ],
      ),
    );
  }
}

class _VerifyBox extends StatefulWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final ValueChanged<String> onChanged;

  const _VerifyBox({
    required this.controller,
    required this.focusNode,
    required this.onChanged,
  });

  @override
  State<_VerifyBox> createState() => _VerifyBoxState();
}

class _VerifyBoxState extends State<_VerifyBox> {
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
      width: 60.w,
      height: 60.w,
      decoration: BoxDecoration(
        color: hasFilled || isFocused
            ? AppColors.primaryColorSecond.withValues(alpha: 0.25)
            : const Color(0xFF242A34),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: isFocused
              ? AppColors.primaryColorSecond
              : hasFilled
              ? AppColors.primaryColorSecond.withValues(alpha: 0.5)
              : Colors.transparent,
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
