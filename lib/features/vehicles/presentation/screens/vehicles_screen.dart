// ============================================================
// FILE: lib/features/vehicles/presentation/screens/vehicles_screen.dart
// ============================================================
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/utils/formatters.dart';

class VehiclesScreen extends ConsumerWidget {
  const VehiclesScreen({super.key});

  static const _types = ['All', 'Car', 'Van', 'Bike', 'Lorry'];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Vehicle Rentals')),
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
              padding: const EdgeInsets.all(AppDimensions.pagePadding),
              itemCount: 5,
              itemBuilder: (_, i) => Card(
                margin: const EdgeInsets.only(bottom: AppDimensions.s12),
                child: ListTile(
                  leading: Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: AppColors.primarySurface,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.directions_car_outlined,
                        color: AppColors.primary),
                  ),
                  title: Text('Toyota Corolla ${2018 + i}',
                      style: AppTextStyles.labelLg),
                  subtitle: Text(Formatters.currency(3500 + i * 500.0),
                      style: AppTextStyles.bodySm
                          .copyWith(color: AppColors.primary)),
                  trailing: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.success.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text('Available',
                        style: AppTextStyles.caption
                            .copyWith(color: AppColors.success)),
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
