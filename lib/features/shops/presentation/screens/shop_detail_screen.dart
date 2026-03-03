// ============================================================
// FILE: lib/features/shops/presentation/screens/shop_detail_screen.dart
// ============================================================
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_text_styles.dart';

class ShopDetailScreen extends ConsumerWidget {
  final String shopId;
  const ShopDetailScreen({super.key, required this.shopId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Shop Detail')),
      body: Padding(
        padding: const EdgeInsets.all(AppDimensions.pagePadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 180,
              decoration: BoxDecoration(
                color: AppColors.primarySurface,
                borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
              ),
              child: const Center(
                child: Icon(Icons.store_outlined, size: 60, color: AppColors.primary),
              ),
            ),
            const SizedBox(height: AppDimensions.s16),
            Text('Shop Name', style: AppTextStyles.h2),
            const SizedBox(height: AppDimensions.s8),
            Text('Shop description and details go here.', style: AppTextStyles.bodyMd),
            const SizedBox(height: AppDimensions.s16),
            Text('Products', style: AppTextStyles.h3),
            const SizedBox(height: AppDimensions.s12),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: AppDimensions.s12,
                  mainAxisSpacing: AppDimensions.s12,
                  childAspectRatio: 0.9,
                ),
                itemCount: 4,
                itemBuilder: (_, i) => Card(
                  child: Column(
                    children: [
                      Expanded(
                        child: Container(
                          color: AppColors.surfaceVariant,
                          child: const Icon(Icons.inventory_2_outlined, size: 40),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('Product ${i + 1}', style: AppTextStyles.labelSm),
                      ),
                    ],
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
