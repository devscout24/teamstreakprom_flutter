import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:teamstreakpromo/gen/colors.gen.dart';
import '../constants/text_font_style.dart';
import 'package:shimmer/shimmer.dart';

class SwipeToActionButton extends StatefulWidget {
  final String text;
  final Future<void> Function() onAction;

  const SwipeToActionButton({
    super.key,
    required this.text,
    required this.onAction,
  });

  @override
  State<SwipeToActionButton> createState() => _SwipeToActionButtonState();
}

class _SwipeToActionButtonState extends State<SwipeToActionButton> {
  double _dragPosition = 4.w; // Start position
  bool _isActionCompleted = false;
  double _maxWidth = 0;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        _maxWidth = constraints.maxWidth;
        final double buttonWidth = 48
            .h; // Ensure it's perfectly round by matching container's inner height
        final double padding = 4.w;
        final double maxDrag = _maxWidth - buttonWidth - padding;

        return Container(
          height: 56.h,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100.r),
          ),
          child: Stack(
            children: [
              Positioned.fill(
                child: Shimmer.fromColors(
                  baseColor: const Color(0xFF8DB741),
                  highlightColor: const Color(0xFFD39A3D),
                  period: const Duration(seconds: 2),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(100.r),
                    ),
                  ),
                ),
              ),
              Center(
                child: Opacity(
                  opacity:
                      (1.0 -
                              ((_dragPosition - padding) /
                                  (maxDrag > padding ? maxDrag - padding : 1)))
                          .clamp(0.0, 1.0),
                  child: Text(
                    widget.text,
                    style: TextFontStyle.textStyle14cFFFFFFSFProRounded400
                        .copyWith(
                          color: AppColors.c1B1C1A, // Dark green/black tint
                          fontWeight: FontWeight.w600,
                          fontSize: 14.sp,
                          fontFamily: "SF Pro",
                        ),
                  ),
                ),
              ),
              AnimatedPositioned(
                duration: _isActionCompleted
                    ? const Duration(milliseconds: 300)
                    : Duration.zero,
                left: _dragPosition,
                top: 4.h, // Top padding
                bottom: 4.h, // Bottom padding
                child: GestureDetector(
                  onPanUpdate: (details) {
                    if (_isActionCompleted) return;
                    setState(() {
                      _dragPosition += details.delta.dx;
                      if (_dragPosition < padding) {
                        _dragPosition = padding;
                      }
                      if (_dragPosition > maxDrag) {
                        _dragPosition = maxDrag;
                      }
                    });
                  },
                  onPanEnd: (details) async {
                    if (_isActionCompleted) return;
                    if (_dragPosition > maxDrag * 0.8) {
                      setState(() {
                        _dragPosition = maxDrag;
                        _isActionCompleted = true;
                      });

                      // Call the provided action
                      await widget.onAction();

                      // Reset the button position when bottom sheet closes
                      if (mounted) {
                        setState(() {
                          _dragPosition = padding;
                          _isActionCompleted = false;
                        });
                      }
                    } else {
                      // Snap back if not swiped far enough
                      setState(() {
                        _dragPosition = padding;
                      });
                    }
                  },
                  child: Container(
                    width: buttonWidth,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                    ),
                    child: Icon(
                      Icons.chevron_right_rounded,
                      color: const Color(0xFF1E211A), // Dark arrow
                      size: 24.sp,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
