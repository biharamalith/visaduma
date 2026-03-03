// ============================================================
// FILE: lib/features/booking/presentation/screens/booking_confirm_screen.dart
// PURPOSE: Summary + final confirm step for a booking.
// ============================================================
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../shared/widgets/app_button.dart';

class BookingConfirmScreen extends ConsumerWidget {
  const BookingConfirmScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Confirm Booking')),
      body: Padding(
        padding: const EdgeInsets.all(AppDimensions.pagePadding),
        child: Column(
          children: [
            const Spacer(),
            Icon(Icons.check_circle_outline,
                size: 80, color: AppColors.success),
            const SizedBox(height: AppDimensions.s24),
            Text('Booking Confirmed!',
                style: AppTextStyles.h2
                    .copyWith(color: AppColors.success)),
            const SizedBox(height: AppDimensions.s12),
            Text(
              'The service provider has been notified and will confirm shortly.',
              style: AppTextStyles.bodyMd,
              textAlign: TextAlign.center,
            ),
            const Spacer(),
            AppButton(
              label: 'View My Bookings',
              onPressed: () => context.go('/home'),
            ),
            const SizedBox(height: AppDimensions.s16),
            TextButton(
              onPressed: () => context.go('/home'),
              child: const Text('Back to Home'),
            ),
          ],
        ),
      ),
    );
  }
}
