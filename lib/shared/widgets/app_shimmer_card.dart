// ============================================================
// FILE: lib/shared/widgets/app_shimmer_card.dart
// PURPOSE: Shimmer placeholder card for list loading states.
//          Usage: show while async data is loading.
// ============================================================

import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';

class AppShimmerCard extends StatelessWidget {
  final double height;
  final double? width;
  final double borderRadius;

  const AppShimmerCard({
    super.key,
    this.height = 80,
    this.width,
    this.borderRadius = AppDimensions.radiusLg,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.shimmerBase,
      highlightColor: AppColors.shimmerHighlight,
      child: Container(
        height: height,
        width: width ?? double.infinity,
        decoration: BoxDecoration(
          color: AppColors.shimmerBase,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
    );
  }
}

/// Renders [count] shimmer card placeholders separated by gaps.
class AppShimmerList extends StatelessWidget {
  final int count;
  final double cardHeight;
  final double gap;

  const AppShimmerList({
    super.key,
    this.count = 6,
    this.cardHeight = 80,
    this.gap = AppDimensions.s12,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: count,
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      separatorBuilder: (_, __) => SizedBox(height: gap),
      itemBuilder: (_, __) => AppShimmerCard(height: cardHeight),
    );
  }
}
