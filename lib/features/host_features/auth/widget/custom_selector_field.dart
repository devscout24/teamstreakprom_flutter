import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:teamstreakpromo/gen/colors.gen.dart';

class CustomSelectorField extends StatelessWidget {
  final String? value;
  final String hintText;
  final String? labelText;
  final VoidCallback onTap;
  final String? Function(String?)? validator;

  const CustomSelectorField({
    super.key,
    required this.value,
    required this.hintText,
    this.labelText,
    required this.onTap,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return FormField<String>(
      key: ValueKey(value),
      validator: validator,
      initialValue: value,
      builder: (state) {
        final hasError = state.hasError;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (labelText != null) ...[
              Text(
                labelText!,
                style: TextStyle(
                  fontFamily: "SF Pro Rounded",
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 8.h),
            ],
            GestureDetector(
              onTap: onTap,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 18.h),
                decoration: BoxDecoration(
                  color: AppColors.c242A34,
                  borderRadius: BorderRadius.circular(100.r),
                  border: Border.all(
                    color: hasError ? Colors.redAccent : Colors.transparent,
                    width: 1.w,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        (value != null && value!.isNotEmpty) ? value! : hintText,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontFamily: (value != null && value!.isNotEmpty)
                              ? "SF Pro Rounded"
                              : "SF Pro",
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w400,
                          color: (value != null && value!.isNotEmpty)
                              ? Colors.white
                              : AppColors.cFFFFFF.withValues(alpha: .5),
                        ),
                      ),
                    ),
                    Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: Colors.white,
                      size: 20.w,
                    ),
                  ],
                ),
              ),
            ),
            if (hasError)
              Padding(
                padding: EdgeInsets.only(left: 20.w, top: 6.h),
                child: Text(
                  state.errorText ?? '',
                  style: TextStyle(
                    color: Colors.redAccent,
                    fontSize: 12.sp,
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
