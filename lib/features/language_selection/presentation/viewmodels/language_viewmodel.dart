// ============================================================
// FILE: lib/features/language_selection/presentation/viewmodels/language_viewmodel.dart
// PURPOSE: Riverpod AsyncNotifier that manages the state for
//          the LanguageSelectionScreen.
//
// State: the currently *highlighted* (but not yet saved) code.
// Calling selectLanguage() saves to storage, updates locale
// and navigates forward via GoRouter.
// ============================================================

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../shared/providers/locale_provider.dart';
import '../../data/datasources/language_local_datasource.dart';
import '../../data/repositories/language_repository_impl.dart';
import '../../domain/usecases/save_language_usecase.dart';

// ── State ─────────────────────────────────────────────────

/// Holds the language code that the user has tapped (highlighted).
/// Starts as English by default.
class LanguageState {
  final String selectedCode;
  final bool isSaving;
  final String? errorMessage;

  const LanguageState({
    this.selectedCode = AppStrings.langEnglish,
    this.isSaving = false,
    this.errorMessage,
  });

  LanguageState copyWith({
    String? selectedCode,
    bool? isSaving,
    String? errorMessage,
  }) =>
      LanguageState(
        selectedCode: selectedCode ?? this.selectedCode,
        isSaving: isSaving ?? this.isSaving,
        errorMessage: errorMessage,
      );
}

// ── Notifier ──────────────────────────────────────────────

class LanguageNotifier extends Notifier<LanguageState> {
  @override
  LanguageState build() => const LanguageState();

  /// Called when the user taps a language card (highlights it).
  void highlight(String code) {
    state = state.copyWith(selectedCode: code);
  }

  /// Called when the user taps "Continue".
  /// Saves to storage, updates app locale, then returns true on success.
  Future<bool> confirm() async {
    state = state.copyWith(isSaving: true, errorMessage: null);

    final usecase = SaveLanguageUsecase(
      LanguageRepositoryImpl(const LanguageLocalDatasourceImpl()),
    );

    final result = await usecase(state.selectedCode);

    return result.fold(
      (failure) {
        state = state.copyWith(isSaving: false, errorMessage: failure.message);
        return false;
      },
      (_) {
        // Tell the locale provider to switch the app language immediately.
        ref.read(localeProvider.notifier).setLocale(state.selectedCode);
        state = state.copyWith(isSaving: false);
        return true;
      },
    );
  }
}

// ── Provider ──────────────────────────────────────────────

final languageProvider = NotifierProvider<LanguageNotifier, LanguageState>(
  LanguageNotifier.new,
);
