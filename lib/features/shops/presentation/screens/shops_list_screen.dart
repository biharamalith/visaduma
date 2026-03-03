// ============================================================
// FILE: lib/features/shops/presentation/screens/shops_list_screen.dart
// ============================================================
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_text_styles.dart';

class ShopsListScreen extends ConsumerWidget {
  const ShopsListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Shops')),
      body: Padding(
        padding: const EdgeInsets.all(AppDimensions.pagePadding),
        child: Column(
          children: [
            TextField(
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.search),
                hintText: 'Search shops…',
              ),
            ),
            const SizedBox(height: AppDimensions.s16),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: AppDimensions.s12,
                  mainAxisSpacing: AppDimensions.s12,
                  childAspectRatio: 0.8,
                ),
                itemCount: 6,
                itemBuilder: (context, i) => InkWell(
                  onTap: () => context.push('/shops/shop_$i'),
                  borderRadius:
                      BorderRadius.circular(AppDimensions.radiusLg),
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius:
                          BorderRadius.circular(AppDimensions.radiusLg),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.shadow,
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              color: AppColors.primarySurface,
                              borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(AppDimensions.radiusLg),
                              ),
                            ),
                            child: const Center(
                              child: Icon(Icons.store_outlined,
                                  size: 40, color: AppColors.primary),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(AppDimensions.s8),
                          child: Text('Shop ${i + 1}',
                              style: AppTextStyles.labelMd),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: AppDimensions.s8),
                          child: Text('Category',
                              style: AppTextStyles.caption),
                        ),
                        const SizedBox(height: AppDimensions.s8),
                      ],
                    ),
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
