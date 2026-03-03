// ============================================================
// FILE: lib/features/boarding/presentation/screens/boarding_list_screen.dart
// ============================================================
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/utils/formatters.dart';

class BoardingListScreen extends ConsumerWidget {
  const BoardingListScreen({super.key});

  static const _types = ['All', 'Room', 'Apartment', 'House', 'Hostel'];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Boarding Places')),
      body: Column(
        children: [
          // ── Filter chips ─────────────────────────────
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.pagePadding,
              vertical: AppDimensions.s12,
            ),
            child: Row(
              children: _types.map((t) => Padding(
                padding: const EdgeInsets.only(right: 8),
                child: FilterChip(
                  label: Text(t),
                  selected: t == 'All',
                  onSelected: (_) {},
                ),
              )).toList(),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.pagePadding),
              itemCount: 6,
              itemBuilder: (_, i) => Card(
                margin: const EdgeInsets.only(bottom: AppDimensions.s12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Image placeholder
                    Container(
                      height: 150,
                      decoration: BoxDecoration(
                        color: AppColors.primarySurface,
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(AppDimensions.radiusMd),
                        ),
                      ),
                      child: const Center(
                        child: Icon(Icons.home_outlined, size: 50, color: AppColors.primary),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(AppDimensions.s12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Boarding Place ${i + 1}',
                              style: AppTextStyles.labelLg),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              const Icon(Icons.location_on_outlined,
                                  size: 14, color: AppColors.textHint),
                              const SizedBox(width: 4),
                              Text('Colombo', style: AppTextStyles.caption),
                              const Spacer(),
                              Text(
                                Formatters.currency(15000 + i * 2000.0),
                                style: AppTextStyles.labelMd.copyWith(
                                    color: AppColors.primary),
                              ),
                              Text('/month', style: AppTextStyles.caption),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Wrap(
                            spacing: 4,
                            children: ['Furnished', 'WiFi', '2 Beds']
                                .map((a) => Chip(
                                      label: Text(a, style: AppTextStyles.caption),
                                      backgroundColor: AppColors.primarySurface,
                                      padding: EdgeInsets.zero,
                                      materialTapTargetSize:
                                          MaterialTapTargetSize.shrinkWrap,
                                    ))
                                .toList(),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
