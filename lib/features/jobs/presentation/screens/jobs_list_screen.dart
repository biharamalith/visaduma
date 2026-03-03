// ============================================================
// FILE: lib/features/jobs/presentation/screens/jobs_list_screen.dart
// ============================================================
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_text_styles.dart';

class JobsListScreen extends ConsumerWidget {
  const JobsListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Jobs')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppDimensions.pagePadding,
              AppDimensions.s12,
              AppDimensions.pagePadding,
              0,
            ),
            child: TextField(
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.search),
                hintText: 'Search jobs…',
              ),
            ),
          ),
          const SizedBox(height: AppDimensions.s12),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.pagePadding),
              itemCount: 8,
              itemBuilder: (_, i) => Card(
                margin: const EdgeInsets.only(bottom: AppDimensions.s12),
                child: Padding(
                  padding: const EdgeInsets.all(AppDimensions.s16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: AppColors.primarySurface,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(Icons.business_outlined,
                                color: AppColors.primary, size: 20),
                          ),
                          const SizedBox(width: AppDimensions.s12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Job Title ${i + 1}',
                                    style: AppTextStyles.labelLg),
                                Text('Company ${i + 1}',
                                    style: AppTextStyles.bodySm.copyWith(
                                        color: AppColors.textSecondary)),
                              ],
                            ),
                          ),
                          Chip(
                            label: Text(
                              i % 2 == 0 ? 'Full-time' : 'Part-time',
                              style: AppTextStyles.caption,
                            ),
                            backgroundColor: AppColors.primarySurface,
                            padding: EdgeInsets.zero,
                          ),
                        ],
                      ),
                      const SizedBox(height: AppDimensions.s8),
                      Row(
                        children: [
                          const Icon(Icons.location_on_outlined,
                              size: 14, color: AppColors.textHint),
                          const SizedBox(width: 4),
                          Text('Colombo', style: AppTextStyles.caption),
                          const SizedBox(width: AppDimensions.s16),
                          const Icon(Icons.attach_money_outlined,
                              size: 14, color: AppColors.textHint),
                          Text(
                            'Rs. ${(30000 + i * 5000)}+ /month',
                            style: AppTextStyles.caption,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
