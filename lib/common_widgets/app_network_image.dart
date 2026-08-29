// lib/common_widgets/generic_cached_image.dart
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';
import 'package:teamstreakpromo/gen/assets.gen.dart';

class AppNetworkImage extends StatelessWidget {
  final String imageUrl;
  final double? height;
  final double? width;
  final BoxFit fit;
  final BorderRadiusGeometry? borderRadius;
  final Color placeholderColor;
  final Color errorColor;
  final Widget? customPlaceholder;
  final Widget? customErrorWidget;
  final double placeholderIconSize;
  final double errorIconSize;

  const AppNetworkImage({
    super.key,
    required this.imageUrl,
    this.height,
    this.width,
    this.fit = BoxFit.cover,
    this.borderRadius,
    this.placeholderColor = const Color(0xFFF5F5F5),
    this.errorColor = const Color(0xFFE8E8E8),
    this.customPlaceholder,
    this.customErrorWidget,
    this.placeholderIconSize = 24,
    this.errorIconSize = 32,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: borderRadius ?? BorderRadius.zero,
      child: CachedNetworkImage(
        imageUrl: imageUrl,
        height: height?.h,
        width: width?.w,
        fit: fit,
        fadeInDuration: const Duration(milliseconds: 300),
        fadeOutDuration: const Duration(milliseconds: 300),
        placeholder: (context, url) => customPlaceholder ?? _buildPlaceholder(),
        errorWidget: (context, url, error) =>
            customErrorWidget ?? _buildErrorWidget(),
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Shimmer.fromColors(
      baseColor: const Color(0xFF1E222B),
      highlightColor: Colors.white.withValues(alpha: 0.05),
      child: Container(
        height: height?.h ?? double.infinity,
        width: width?.w ?? double.infinity,
        color: const Color(0xFF1E222B),
      ),
    );
  }

  Widget _buildErrorWidget() {
    return Container(
      height: height?.h,
      width: width?.w,
      color: errorColor,
      child: Center(
        child: Image.asset(
          Assets.images.placeholderImage.path,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
