// ============================================================
// FILE: lib/features/rides/presentation/screens/rides_screen.dart
// PURPOSE: Browse available rides near user; map integration placeholder.
// ============================================================
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_text_styles.dart';

class RidesScreen extends ConsumerWidget {
  const RidesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Rides')),
      body: Padding(
        padding: const EdgeInsets.all(AppDimensions.pagePadding),
        child: Column(
          children: [
            // ── Destination input ─────────────────────
            TextField(
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.search),
                hintText: 'Where to?',
              ),
            ),
            const SizedBox(height: AppDimensions.s24),
            Text('Nearby Drivers', style: AppTextStyles.h3),
            const SizedBox(height: AppDimensions.s12),
            Expanded(
              child: ListView.builder(
                itemCount: 5,
                itemBuilder: (context, i) => Card(
                  child: ListTile(
                    leading: const CircleAvatar(
                      child: Icon(Icons.directions_car),
                    ),
                    title: Text('Driver ${i + 1}'),
                    subtitle: const Text('Sedan • Rs. 60/km'),
                    trailing: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.star_rounded, color: AppColors.ratingStarFill, size: 14),
                        Text('4.${8 - i}', style: AppTextStyles.caption),
                      ],
                    ),
                    onTap: () {},
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
