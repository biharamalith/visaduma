// ============================================================
// FILE: lib/features/reviews/presentation/screens/reviews_screen.dart
// PURPOSE: ShowS all reviews for a given provider.
//          Imported by app_router as "/reviews/:providerId".
// ============================================================
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/utils/formatters.dart';

class ReviewsScreen extends ConsumerWidget {
  final String providerId;
  const ReviewsScreen({super.key, required this.providerId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Reviews')),
      body: Column(
        children: [
          // ── Summary card ─────────────────────────────
          Padding(
            padding: const EdgeInsets.all(AppDimensions.pagePadding),
            child: Container(
              padding: const EdgeInsets.all(AppDimensions.s16),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.shadow,
                    blurRadius: 12,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Column(
                    children: [
                      Text('4.7', style: AppTextStyles.displayLg),
                      Row(
                        children: List.generate(
                          5,
                          (i) => Icon(
                            i < 4
                                ? Icons.star_rounded
                                : Icons.star_half_rounded,
                            color: AppColors.ratingStarFill,
                            size: 16,
                          ),
                        ),
                      ),
                      Text('128 reviews', style: AppTextStyles.caption),
                    ],
                  ),
                  const SizedBox(width: AppDimensions.s24),
                  Expanded(
                    child: Column(
                      children: [5, 4, 3, 2, 1].map((star) {
                        final fraction = [0.7, 0.2, 0.05, 0.03, 0.02][5 - star];
                        return Row(
                          children: [
                            Text('$star', style: AppTextStyles.caption),
                            const SizedBox(width: 4),
                            const Icon(Icons.star_rounded,
                                size: 12, color: AppColors.ratingStarFill),
                            const SizedBox(width: 4),
                            Expanded(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(4),
                                child: LinearProgressIndicator(
                                  value: fraction,
                                  backgroundColor:
                                      AppColors.surfaceVariant,
                                  valueColor:
                                      const AlwaysStoppedAnimation<Color>(
                                          AppColors.ratingStarFill),
                                  minHeight: 6,
                                ),
                              ),
                            ),
                          ],
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ── Review list ──────────────────────────────
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.pagePadding),
              itemCount: 10,
              separatorBuilder: (_, __) => const Divider(height: 24),
              itemBuilder: (_, i) => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 18,
                        backgroundColor: AppColors.primarySurface,
                        child: Text(
                          'U${i + 1}',
                          style: AppTextStyles.caption
                              .copyWith(color: AppColors.primary),
                        ),
                      ),
                      const SizedBox(width: AppDimensions.s8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('User ${i + 1}',
                                style: AppTextStyles.labelMd),
                            Text(
                              Formatters.timeAgo(
                                DateTime.now()
                                    .subtract(Duration(days: i + 1)),
                              ),
                              style: AppTextStyles.caption,
                            ),
                          ],
                        ),
                      ),
                      Row(
                        children: List.generate(
                          5,
                          (s) => Icon(
                            s < 4 ? Icons.star_rounded : Icons.star_outline,
                            color: AppColors.ratingStarFill,
                            size: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppDimensions.s8),
                  Text(
                    'Great service! Very professional and on time. Highly recommended for everyone. ${i + 1}',
                    style: AppTextStyles.bodyMd,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
