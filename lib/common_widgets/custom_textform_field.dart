import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:teamstreakpromo/gen/colors.gen.dart';

class CustomTextFormField extends StatefulWidget {
  const CustomTextFormField({
    super.key,
    required this.controller,
    required this.hintText,
    this.validator,
    this.isPassword = false,
    this.prefixIcon,
    this.textInputAction,
    this.keyboardType,
    this.labelText,
    this.maxLines = 1,
    this.minLines,
    this.borderRadius,
    this.readOnly = false,
    this.enabled = true,
    this.onTap,
    this.suffixIcon,
  });

  final TextEditingController controller;
  final String hintText;
  final String? labelText;
  final String? Function(String?)? validator;
  final bool isPassword;
  final IconData? prefixIcon;
  final TextInputAction? textInputAction;
  final TextInputType? keyboardType;
  final bool readOnly;
  final bool enabled;
  final VoidCallback? onTap;
  final Widget? suffixIcon;

  final int? maxLines;
  final int? minLines;

  /// Custom border radius
  final BorderRadius? borderRadius;

  @override
  State<CustomTextFormField> createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  late bool _obscureText;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.isPassword;
  }

  @override
  Widget build(BuildContext context) {
    final borderRadius = widget.borderRadius ?? BorderRadius.circular(100.r);

    Widget textField = TextFormField(
      controller: widget.controller,
      validator: widget.validator,
      obscureText: _obscureText,
      textInputAction: widget.textInputAction,
      keyboardType: widget.keyboardType,
      readOnly: widget.readOnly,
      enabled: widget.enabled,
      onTap: widget.onTap,
      maxLines: widget.isPassword ? 1 : widget.maxLines,
      minLines: widget.isPassword ? 1 : widget.minLines,
      style: TextStyle(
        fontFamily: "SF Pro",
        fontSize: 12.sp,
        fontWeight: FontWeight.w600,
        color: widget.enabled
            ? AppColors.cFFFFFF
            : Colors.white.withValues(alpha: 0.35),
      ),
      cursorColor: Colors.white,
      decoration: InputDecoration(
        hintText: widget.hintText,
        hintStyle: TextStyle(
          fontFamily: "SF Pro",
          fontSize: 12.sp,
          fontWeight: FontWeight.w600,
          color: widget.enabled
              ? AppColors.cFFFFFF
              : Colors.white.withValues(alpha: 0.25),
        ),
        filled: true,
        fillColor: widget.enabled
            ? AppColors.c242A34
            : AppColors.c242A34.withValues(alpha: 0.45),
        contentPadding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 18.h),
        prefixIcon: widget.prefixIcon != null
            ? Icon(
                widget.prefixIcon,
                color: widget.enabled
                    ? Colors.white.withValues(alpha: 0.4)
                    : Colors.white.withValues(alpha: 0.2),
              )
            : null,
        suffixIcon: widget.isPassword
            ? IconButton(
                onPressed: () {
                  setState(() {
                    _obscureText = !_obscureText;
                  });
                },
                icon: Icon(
                  _obscureText ? Icons.visibility_off : Icons.visibility,
                  color: Colors.white,
                  size: 20.w,
                ),
              )
            : (!widget.enabled
                ? (widget.suffixIcon ??
                    Icon(
                      Icons.lock_outline_rounded,
                      color: Colors.white.withValues(alpha: 0.3),
                      size: 18.sp,
                    ))
                : widget.suffixIcon),
        border: OutlineInputBorder(
          borderRadius: borderRadius,
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: borderRadius,
          borderSide: BorderSide.none,
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: borderRadius,
          borderSide: BorderSide(
            color: Colors.white.withValues(alpha: 0.08),
            width: 1.w,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: borderRadius,
          borderSide: BorderSide(
            color: Colors.white.withValues(alpha: .2),
            width: 1.w,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: borderRadius,
          borderSide: BorderSide(color: Colors.redAccent, width: 1.w),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: borderRadius,
          borderSide: BorderSide(color: Colors.redAccent, width: 1.w),
        ),
      ),
    );

    if (widget.labelText != null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            widget.labelText!,
            style: TextStyle(
              fontFamily: "SF Pro Rounded",
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
              color: widget.enabled
                  ? AppColors.cFFFFFF
                  : Colors.white.withValues(alpha: 0.5),
            ),
          ),
          SizedBox(height: 8.h),
          textField,
        ],
      );
    }

    return textField;
  }
}
