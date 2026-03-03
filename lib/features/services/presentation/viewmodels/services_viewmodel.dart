// ============================================================
// FILE: lib/features/services/presentation/viewmodels/services_viewmodel.dart
// PURPOSE: Riverpod providers for services list + detail state.
// ============================================================

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/dio_client.dart';
import '../../data/datasources/services_remote_datasource.dart';
import '../../data/repositories/services_repository_impl.dart';
import '../../domain/entities/service_entity.dart';
import '../../domain/usecases/get_services_usecase.dart';

// ── Services list state ───────────────────────────────────

class ServicesState {
  final List<ServiceEntity> services;
  final bool isLoading;
  final bool isLoadingMore;
  final String? error;
  final String? selectedCategory;
  final String searchQuery;
  final int currentPage;
  final bool hasMore;

  const ServicesState({
    this.services = const [],
    this.isLoading = false,
    this.isLoadingMore = false,
    this.error,
    this.selectedCategory,
    this.searchQuery = '',
    this.currentPage = 1,
    this.hasMore = true,
  });

  ServicesState copyWith({
    List<ServiceEntity>? services,
    bool? isLoading,
    bool? isLoadingMore,
    String? error,
    String? selectedCategory,
    String? searchQuery,
    int? currentPage,
    bool? hasMore,
  }) =>
      ServicesState(
        services: services ?? this.services,
        isLoading: isLoading ?? this.isLoading,
        isLoadingMore: isLoadingMore ?? this.isLoadingMore,
        error: error,
        selectedCategory: selectedCategory ?? this.selectedCategory,
        searchQuery: searchQuery ?? this.searchQuery,
        currentPage: currentPage ?? this.currentPage,
        hasMore: hasMore ?? this.hasMore,
      );
}

// ── Notifier ──────────────────────────────────────────────

class ServicesNotifier extends Notifier<ServicesState> {
  late final GetServicesUsecase _getServices;

  @override
  ServicesState build() {
    _getServices = GetServicesUsecase(
      ServicesRepositoryImpl(
        ServicesRemoteDatasourceImpl(DioClient.instance),
      ),
    );
    // Load initial services.
    Future.microtask(() => load());
    return const ServicesState(isLoading: true);
  }

  Future<void> load({bool refresh = false}) async {
    if (refresh) {
      state = state.copyWith(isLoading: true, currentPage: 1);
    }

    final result = await _getServices(
      category: state.selectedCategory,
      searchQuery: state.searchQuery.isEmpty ? null : state.searchQuery,
      page: 1,
    );

    result.fold(
      (failure) => state = state.copyWith(
        isLoading: false,
        error: failure.message,
      ),
      (services) => state = state.copyWith(
        services: services,
        isLoading: false,
        currentPage: 1,
        hasMore: services.length >= 20,
      ),
    );
  }

  void filterByCategory(String? category) {
    state = state.copyWith(selectedCategory: category);
    load();
  }

  void search(String query) {
    state = state.copyWith(searchQuery: query);
    load();
  }
}

// ── Providers ─────────────────────────────────────────────

final servicesProvider = NotifierProvider<ServicesNotifier, ServicesState>(
  ServicesNotifier.new,
);

/// Provides a single service's detail for the detail screen.
final serviceDetailProvider =
    FutureProvider.family<ServiceEntity, String>((ref, id) async {
  final repo = ServicesRepositoryImpl(
    ServicesRemoteDatasourceImpl(DioClient.instance),
  );
  final result = await repo.getServiceById(id);
  return result.fold(
    (failure) => throw Exception(failure.message),
    (service) => service,
  );
});
