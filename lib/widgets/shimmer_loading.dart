import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerLoading extends StatelessWidget {
  final Widget child;
  final bool isLoading;
  final Color? baseColor;
  final Color? highlightColor;

  const ShimmerLoading({
    super.key,
    required this.child,
    required this.isLoading,
    this.baseColor,
    this.highlightColor,
  });

  @override
  Widget build(BuildContext context) {
    if (!isLoading) return child;

    return Shimmer.fromColors(
      baseColor: baseColor ?? Colors.grey.shade300,
      highlightColor: highlightColor ?? Colors.grey.shade100,
      period: Duration(milliseconds: 1500),
      child: child,
    );
  }
}

class ShimmerCard extends StatelessWidget {
  final double? width;
  final double? height;
  final double? borderRadius;

  const ShimmerCard({
    super.key,
    this.width,
    this.height,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width ?? double.infinity,
      height: height ?? 100,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(borderRadius ?? 12),
      ),
    );
  }
}

class ShimmerText extends StatelessWidget {
  final double? width;
  final double? height;
  final double? fontSize;

  const ShimmerText({
    super.key,
    this.width,
    this.height,
    this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width ?? double.infinity,
      height: height ?? fontSize ?? 16,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}

class ShimmerCircle extends StatelessWidget {
  final double? size;

  const ShimmerCircle({
    super.key,
    this.size,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size ?? 50,
      height: size ?? 50,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
      ),
    );
  }
}