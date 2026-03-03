// ============================================================
// FILE: lib/features/services/presentation/screens/services_list_screen.dart
// PURPOSE: Browsable, filterable list of service providers.
//          Uses ServicesNotifier for state, shows category chips
//          + a shimmer loading state + LazyLoad pagination.
// ============================================================

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../shared/widgets/app_error_view.dart';
import '../../../../shared/widgets/app_shimmer_card.dart';
import '../viewmodels/services_viewmodel.dart';
import '../widgets/service_card.dart';

class ServicesListScreen extends ConsumerWidget {
  const ServicesListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(servicesProvider);
    final notifier = ref.read(servicesProvider.notifier);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Services'),
        actions: [
          IconButton(
            icon: const Icon(Icons.tune_outlined),
            onPressed: () {
              // TODO: open filter bottom sheet.
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // ── Search ─────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppDimensions.pagePadding,
              AppDimensions.s12,
              AppDimensions.pagePadding,
              0,
            ),
            child: TextField(
              onChanged: notifier.search,
              decoration: const InputDecoration(
                hintText: 'Search services…',
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),

          const SizedBox(height: AppDimensions.s12),

          // ── Body ───────────────────────────────────────
          Expanded(
            child: state.isLoading
                ? const Padding(
                    padding: EdgeInsets.all(AppDimensions.pagePadding),
                    child: AppShimmerList(count: 6, cardHeight: 100),
                  )
                : state.error != null
                    ? AppErrorView(
                        message: state.error,
                        onRetry: notifier.load,
                      )
                    : RefreshIndicator(
                        onRefresh: () => notifier.load(refresh: true),
                        child: ListView.separated(
                          padding: const EdgeInsets.all(AppDimensions.pagePadding),
                          itemCount: state.services.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(height: AppDimensions.s12),
                          itemBuilder: (context, index) {
                            final service = state.services[index];
                            return ServiceCard(
                              service: service,
                              onTap: () =>
                                  context.push('/services/${service.id}'),
                            );
                          },
                        ),
                      ),
          ),
        ],
      ),
    );
  }
}
