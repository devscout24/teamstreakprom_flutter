import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:teamstreakpromo/gen/colors.gen.dart';
import 'package:teamstreakpromo/helpers/ui_helpers.dart';

class DocumentUploadWidget extends StatelessWidget {
  final String label;
  final String? fileName;
  final VoidCallback onTap;
  final VoidCallback? onRemove;
  final String? Function(String?)? validator;

  const DocumentUploadWidget({
    super.key,
    required this.label,
    required this.fileName,
    required this.onTap,
    this.onRemove,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    final gradient = LinearGradient(
      colors: [
        AppColors.primaryColorFirst,
        AppColors.primaryColorSecond,
      ],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );

    return FormField<String>(
      key: ValueKey(fileName),
      validator: validator,
      initialValue: fileName,
      builder: (state) {
        final hasError = state.hasError;

        final borderGradient = hasError
            ? const LinearGradient(colors: [Colors.redAccent, Colors.redAccent])
            : gradient;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Label
            Text(
              label,
              style: TextStyle(
                fontFamily: "SF Pro Rounded",
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            UIHelper.verticalSpace(10),
            // Upload Box
            GestureDetector(
              onTap: onTap,
              child: CustomPaint(
                painter: DashedRectPainter(
                  gradient: borderGradient,
                  strokeWidth: 1.5.w,
                  dashLength: 8.w,
                  gap: 6.w,
                  borderRadius: 20.r,
                ),
                child: Container(
                  width: double.infinity,
                  height: 150.h,
                  decoration: BoxDecoration(
                    color: AppColors.c242A34.withValues(alpha: 0.25),
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: fileName != null
                      ? Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.w),
                          child: Row(
                            children: [
                              Container(
                                width: 56.w,
                                height: 56.w,
                                decoration: BoxDecoration(
                                  gradient: gradient,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.insert_drive_file,
                                  color: Colors.black,
                                ),
                              ),
                              UIHelper.horizontalSpace(16),
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      fileName!,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontFamily: "SF Pro Rounded",
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white,
                                      ),
                                    ),
                                    UIHelper.verticalSpace(4),
                                    Text(
                                      "Tap to change",
                                      style: TextStyle(
                                        fontFamily: "SF Pro",
                                        fontSize: 12.sp,
                                        color: Colors.white.withValues(alpha: 0.5),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              if (onRemove != null)
                                IconButton(
                                  onPressed: onRemove,
                                  icon: const Icon(
                                    Icons.delete_outline,
                                    color: Colors.redAccent,
                                  ),
                                ),
                            ],
                          ),
                        )
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Gradient Circle with upload arrow matching mockup exactly
                            Container(
                              width: 60.w,
                              height: 60.w,
                              decoration: BoxDecoration(
                                gradient: gradient,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.upload,
                                color: Colors.black,
                                size: 24.w,
                              ),
                            ),
                            UIHelper.verticalSpace(14),
                            Text(
                              "Click to upload",
                              style: TextStyle(
                                fontFamily: "SF Pro Rounded",
                                fontSize: 15.sp,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                            UIHelper.verticalSpace(6),
                            Text(
                              "PDF, PNG, JPG (max 10MB)",
                              style: TextStyle(
                                fontFamily: "SF Pro",
                                fontSize: 12.sp,
                                color: Colors.white.withValues(alpha: 0.45),
                              ),
                            ),
                          ],
                        ),
                ),
              ),
            ),
            if (hasError)
              Padding(
                padding: EdgeInsets.only(left: 12.w, top: 6.h),
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

class DashedRectPainter extends CustomPainter {
  final Gradient gradient;
  final double strokeWidth;
  final double gap;
  final double dashLength;
  final double borderRadius;

  DashedRectPainter({
    required this.gradient,
    this.strokeWidth = 1.0,
    this.gap = 5.0,
    this.dashLength = 5.0,
    this.borderRadius = 12.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    final paint = Paint()
      ..shader = gradient.createShader(rect)
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final path = Path();
    path.addRRect(RRect.fromRectAndRadius(
      rect,
      Radius.circular(borderRadius),
    ));

    final dashedPath = Path();
    double distance = 0.0;
    for (final pathMetric in path.computeMetrics()) {
      while (distance < pathMetric.length) {
        dashedPath.addPath(
          pathMetric.extractPath(distance, distance + dashLength),
          Offset.zero,
        );
        distance += dashLength + gap;
      }
    }
    canvas.drawPath(dashedPath, paint);
  }

  @override
  bool shouldRepaint(covariant DashedRectPainter oldDelegate) {
    return oldDelegate.gradient != gradient ||
        oldDelegate.strokeWidth != strokeWidth ||
        oldDelegate.gap != gap ||
        oldDelegate.dashLength != dashLength ||
        oldDelegate.borderRadius != borderRadius;
  }
}
