import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// A reusable container that applies the app's standard warm gradient
/// (orange → green, 10% opacity) with rounded corners.
///
/// Usage:
/// ```dart
/// GradientContainer(
///   child: YourWidget(),
/// )
/// ```
class GradientContainer extends StatelessWidget {
  const GradientContainer({
    super.key,
    required this.child,
    this.padding,
    this.borderRadius,
    this.gradient,
    this.border,
    this.width,
    this.height,
    this.onTap,
    this.color,
  });

  final Widget child;
  final EdgeInsetsGeometry? padding;
  final BorderRadiusGeometry? borderRadius;
  final Gradient? gradient;
  final BoxBorder? border;
  final double? width;
  final double? height;
  final VoidCallback? onTap;
  final Color? color;

  /// Default gradient used across ticket cards and similar surfaces.
  static const LinearGradient defaultGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    stops: [-0.375, 1.2411],
    colors: [
      Color(0x1AF28F31), // rgba(242,143,49, 0.10)
      Color(0x1A72E84F), // rgba(114,232,79, 0.10)
    ],
  );

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        height: height,
        padding: padding,
        decoration: BoxDecoration(
          color: color,
          gradient: gradient ?? defaultGradient,
          borderRadius: borderRadius ?? BorderRadius.circular(16.r),
          border: border,
        ),
        child: child,
      ),
    );
  }
}
