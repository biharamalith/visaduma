// ============================================================
// FILE: lib/features/language_selection/presentation/screens/language_selection_screen.dart
// PURPOSE: Priority #1 screen.
//          Displays three language options (Sinhala / Tamil / English)
//          with a Helakuru-style card UI.
//          Saves selection → updates locale → navigates to /login.
// ============================================================

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/utils/helpers.dart';
import '../viewmodels/language_viewmodel.dart';
import '../widgets/language_card.dart';

class LanguageSelectionScreen extends ConsumerWidget {
  const LanguageSelectionScreen({super.key});

  // ── Language options ──────────────────────────────────────
  static const _languages = [
    _LanguageOption(
      code: AppStrings.langSinhala,
      nativeName: 'සිංහල',
      englishName: 'Sinhala',
      flag: '🇱🇰',
    ),
    _LanguageOption(
      code: AppStrings.langTamil,
      nativeName: 'தமிழ்',
      englishName: 'Tamil',
      flag: '🇱🇰',
    ),
    _LanguageOption(
      code: AppStrings.langEnglish,
      nativeName: 'English',
      englishName: 'English',
      flag: '🇬🇧',
    ),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(languageProvider);
    final notifier = ref.read(languageProvider.notifier);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.pagePadding,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: AppDimensions.s48),

              // ── Logo / Illustration ──────────────────────
              Center(
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: AppColors.primarySurface,
                    borderRadius: BorderRadius.circular(AppDimensions.radius2Xl),
                  ),
                  child: const Icon(
                    Icons.bolt_rounded,
                    color: AppColors.primary,
                    size: 44,
                  ),
                ),
              ),

              const SizedBox(height: AppDimensions.s32),

              // ── Heading ───────────────────────────────────
              Text(
                'Select Your Language',
                style: AppTextStyles.displayMd,
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: AppDimensions.s8),

              Text(
                'Choose the language you are most\ncomfortable with',
                style: AppTextStyles.bodyMd.copyWith(
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: AppDimensions.s40),

              // ── Language cards ────────────────────────────
              ...List.generate(_languages.length, (i) {
                final lang = _languages[i];
                return Padding(
                  padding: EdgeInsets.only(
                    bottom: i < _languages.length - 1 ? AppDimensions.s12 : 0,
                  ),
                  child: LanguageCard(
                    languageCode: lang.code,
                    nativeName: lang.nativeName,
                    englishName: lang.englishName,
                    flagEmoji: lang.flag,
                    isSelected: state.selectedCode == lang.code,
                    onTap: () => notifier.highlight(lang.code),
                  ),
                );
              }),

              const Spacer(),

              // ── Continue button ───────────────────────────
              ElevatedButton(
                onPressed: state.isSaving
                    ? null
                    : () async {
                        final success = await notifier.confirm();
                        if (success && context.mounted) {
                          context.go('/login');
                        } else if (!success && context.mounted) {
                          AppHelpers.showSnackBar(
                            context,
                            state.errorMessage ?? 'Failed to save. Please try again.',
                            isError: true,
                          );
                        }
                      },
                child: state.isSaving
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2.5,
                        ),
                      )
                    : const Text('Continue'),
              ),

              const SizedBox(height: AppDimensions.s32),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Language option model (private, screen-scoped) ────────

class _LanguageOption {
  final String code;
  final String nativeName;
  final String englishName;
  final String flag;

  const _LanguageOption({
    required this.code,
    required this.nativeName,
    required this.englishName,
    required this.flag,
  });
}
