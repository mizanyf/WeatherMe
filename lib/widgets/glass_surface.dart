import 'dart:ui';

import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// A versatile, high-performance Glassmorphism surface widget.
///
/// Wraps its child in `ClipRRect` -> `BackdropFilter` (Gaussian blur) ->
/// translucent frosted container with luminous glass border highlight
/// and soft ambient depth.
class GlassSurface extends StatelessWidget {
  final Widget child;
  final double borderRadius;
  final BorderRadiusGeometry? customBorderRadius;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double blurSigma;
  final Color? fillColor;
  final Color? borderColor;
  final double borderWidth;
  final Gradient? gradient;
  final List<BoxShadow>? boxShadow;
  final Clip clipBehavior;

  const GlassSurface({
    super.key,
    required this.child,
    this.borderRadius = 20.0,
    this.customBorderRadius,
    this.padding,
    this.margin,
    this.blurSigma = AppColors.glassBlurSigmaLight,
    this.fillColor,
    this.borderColor,
    this.borderWidth = 0.8,
    this.gradient,
    this.boxShadow,
    this.clipBehavior = Clip.antiAlias,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveRadius =
        customBorderRadius ?? BorderRadius.circular(borderRadius);

    return Container(
      margin: margin,
      child: ClipRRect(
        borderRadius: effectiveRadius,
        clipBehavior: clipBehavior,
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: blurSigma, sigmaY: blurSigma),
          child: Container(
            padding: padding,
            decoration: BoxDecoration(
              color: gradient == null
                  ? (fillColor ?? AppColors.glassFill)
                  : null,
              gradient: gradient,
              borderRadius: effectiveRadius,
              border: Border.all(
                color: borderColor ?? AppColors.glassBorder,
                width: borderWidth,
              ),
              boxShadow:
                  boxShadow ??
                  [
                    BoxShadow(
                      color: AppColors.glassShadow,
                      blurRadius: 16,
                      offset: const Offset(0, 6),
                    ),
                  ],
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}
