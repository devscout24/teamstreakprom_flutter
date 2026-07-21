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
  });

  final TextEditingController controller;
  final String hintText;
  final String? labelText;
  final String? Function(String?)? validator;
  final bool isPassword;
  final IconData? prefixIcon;
  final TextInputAction? textInputAction;
  final TextInputType? keyboardType;

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
    final borderRadius =
        widget.borderRadius ?? BorderRadius.circular(100.r);

    return TextFormField(
      controller: widget.controller,
      validator: widget.validator,
      obscureText: _obscureText,
      textInputAction: widget.textInputAction,
      keyboardType: widget.keyboardType,
      maxLines: widget.isPassword ? 1 : widget.maxLines,
      minLines: widget.isPassword ? 1 : widget.minLines,
      style: TextStyle(
        fontFamily: "SF Pro Rounded",
        fontSize: 15.sp,
        fontWeight: FontWeight.w400,
        color: AppColors.cE9EAE9,
      ),
      cursorColor: Colors.white,
      decoration: InputDecoration(
        hintText: widget.hintText,
        hintStyle: TextStyle(
          fontFamily: "SF Pro",
          fontSize: 15.sp,
          fontWeight: FontWeight.w400,
          color: AppColors.cFFFFFF.withValues(alpha: .3),
        ),
        filled: true,
        fillColor: AppColors.c242A34,
        contentPadding: EdgeInsets.symmetric(
          horizontal: 20.w,
          vertical: 18.h,
        ),
        prefixIcon: widget.prefixIcon != null
            ? Icon(
          widget.prefixIcon,
          color: Colors.white.withValues(alpha: 0.4),
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
            _obscureText
                ? Icons.visibility_off
                : Icons.visibility,
            color: Colors.white,
            size: 20.w,
          ),
        )
            : null,
        border: OutlineInputBorder(
          borderRadius: borderRadius,
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: borderRadius,
          borderSide: BorderSide.none,
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
          borderSide: BorderSide(
            color: Colors.redAccent,
            width: 1.w,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: borderRadius,
          borderSide: BorderSide(
            color: Colors.redAccent,
            width: 1.w,
          ),
        ),
      ),
    );
  }
}