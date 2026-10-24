import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:teamstreakpromo/constants/text_font_style.dart';
import 'package:teamstreakpromo/gen/colors.gen.dart';

class AnimatedMovingBorderButton extends StatefulWidget {
  final VoidCallback onPressed;
  final String title;
  final double? height;
  final double? width;
  final double borderRadius;
  final double borderWidth;
  final TextStyle? textStyle;
  final Color backgroundColor;

  const AnimatedMovingBorderButton({
    super.key,
    required this.onPressed,
    required this.title,
    this.height,
    this.width,
    this.borderRadius = 100,
    this.borderWidth = 2.0,
    this.textStyle,
    this.backgroundColor = const Color(0xFF1E222B),
  });

  @override
  State<AnimatedMovingBorderButton> createState() =>
      _AnimatedMovingBorderButtonState();
}

class _AnimatedMovingBorderButtonState extends State<AnimatedMovingBorderButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2500),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double buttonHeight = widget.height ?? 48.h;

    return SizedBox(
      height: buttonHeight,
      width: widget.width ?? double.infinity,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return CustomPaint(
            painter: _MovingBorderPainter(
              animationProgress: _controller.value,
              strokeWidth: widget.borderWidth,
              borderRadius: widget.borderRadius.r,
              colors: const [
                AppColors.primaryColorFirst,
                AppColors.primaryColorSecond,
                AppColors.primaryColorFirst,
                AppColors.primaryColorSecond,
                AppColors.primaryColorFirst,
              ],
            ),
            child: child,
          );
        },
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: widget.onPressed,
            borderRadius: BorderRadius.circular(widget.borderRadius.r),
            child: Container(
              margin: EdgeInsets.all(widget.borderWidth),
              decoration: BoxDecoration(
                color: widget.backgroundColor,
                borderRadius: BorderRadius.circular(
                  (widget.borderRadius.r - widget.borderWidth)
                      .clamp(0.0, 1000.0),
                ),
              ),
              alignment: Alignment.center,
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: ShaderMask(
                shaderCallback: (bounds) => const LinearGradient(
                  colors: [
                    AppColors.primaryColorFirst,
                    AppColors.primaryColorSecond,
                  ],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ).createShader(bounds),
                blendMode: BlendMode.srcIn,
                child: Text(
                  widget.title,
                  style: widget.textStyle ??
                      TextFontStyle.textStyle14cFFFFFFSFProRounded400.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 16.sp,
                      ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _MovingBorderPainter extends CustomPainter {
  final double animationProgress;
  final double strokeWidth;
  final double borderRadius;
  final List<Color> colors;

  _MovingBorderPainter({
    required this.animationProgress,
    required this.strokeWidth,
    required this.borderRadius,
    required this.colors,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (size.width <= 0 || size.height <= 0) return;

    final rect = Offset.zero & size;
    final rrect = RRect.fromRectAndRadius(
      rect.deflate(strokeWidth / 2),
      Radius.circular(borderRadius),
    );

    final sweepGradient = SweepGradient(
      center: Alignment.center,
      startAngle: 0.0,
      endAngle: 2 * math.pi,
      transform: GradientRotation(animationProgress * 2 * math.pi),
      colors: colors,
    );

    // Subtle glow layer for extra vitality
    final glowPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth + 2.0
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3.0)
      ..shader = sweepGradient.createShader(rect);

    canvas.drawRRect(rrect, glowPaint);

    // Crisp foreground stroke
    final mainPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..shader = sweepGradient.createShader(rect);

    canvas.drawRRect(rrect, mainPaint);
  }

  @override
  bool shouldRepaint(covariant _MovingBorderPainter oldDelegate) {
    return oldDelegate.animationProgress != animationProgress ||
        oldDelegate.strokeWidth != strokeWidth ||
        oldDelegate.borderRadius != borderRadius;
  }
}
