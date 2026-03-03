// ============================================================
// FILE: lib/features/services/presentation/screens/service_detail_screen.dart
// PURPOSE: Full-screen detail view for a single service/provider.
//          Shows images, bio, rating, reviews button, Book Now CTA.
// ============================================================

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_error_view.dart';
import '../../../../shared/widgets/app_loading.dart';
import '../viewmodels/services_viewmodel.dart';

class ServiceDetailScreen extends ConsumerWidget {
  final String serviceId;
  const ServiceDetailScreen({super.key, required this.serviceId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncService = ref.watch(serviceDetailProvider(serviceId));

    return Scaffold(
      backgroundColor: AppColors.background,
      body: asyncService.when(
        loading: () => const AppLoading(),
        error: (e, _) => AppErrorView(
          message: e.toString(),
          onRetry: () => ref.invalidate(serviceDetailProvider(serviceId)),
        ),
        data: (service) => CustomScrollView(
          slivers: [
            // ── Hero image ──────────────────────────────
            SliverAppBar(
              expandedHeight: 240,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                background: service.imageUrls.isNotEmpty
                    ? Image.network(
                        service.imageUrls.first,
                        fit: BoxFit.cover,
                      )
                    : Container(color: AppColors.primarySurface),
              ),
            ),

            // ── Content ─────────────────────────────────
            SliverPadding(
              padding: const EdgeInsets.all(AppDimensions.pagePadding),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  Text(service.name, style: AppTextStyles.h1),
                  const SizedBox(height: AppDimensions.s8),
                  Row(
                    children: [
                      const Icon(
                        Icons.star_rounded,
                        color: AppColors.ratingStarFill,
                        size: 18,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        Formatters.rating(service.rating),
                        style: AppTextStyles.labelLg,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '(${service.reviewCount} reviews)',
                        style: AppTextStyles.bodySm,
                      ),
                    ],
                  ),
                  const SizedBox(height: AppDimensions.s16),
                  Text(service.description, style: AppTextStyles.bodyMd),
                  const SizedBox(height: AppDimensions.s24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Price', style: AppTextStyles.labelSm),
                          Text(
                            Formatters.currency(service.pricePerHour),
                            style: AppTextStyles.h3.copyWith(
                              color: AppColors.primary,
                            ),
                          ),
                          Text(
                            'per hour',
                            style: AppTextStyles.caption,
                          ),
                        ],
                      ),
                      AppButton(
                        label: 'Book Now',
                        onPressed: () => context.push('/booking'),
                        width: 160,
                      ),
                    ],
                  ),
                  const SizedBox(height: AppDimensions.s24),
                  OutlinedButton.icon(
                    onPressed: () =>
                        context.push('/reviews/${service.providerId}'),
                    icon: const Icon(Icons.reviews_outlined),
                    label: const Text('View All Reviews'),
                  ),
                  const SizedBox(height: AppDimensions.s16),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () =>
                              context.push('/chat/${service.providerId}'),
                          icon: const Icon(Icons.chat_outlined),
                          label: const Text('Chat'),
                        ),
                      ),
                      const SizedBox(width: AppDimensions.s12),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {
                            // TODO: initiate in-app call.
                          },
                          icon: const Icon(Icons.call_outlined),
                          label: const Text('Call'),
                        ),
                      ),
                    ],
                  ),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
