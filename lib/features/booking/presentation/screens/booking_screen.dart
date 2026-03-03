// ============================================================
// FILE: lib/features/booking/presentation/screens/booking_screen.dart
// PURPOSE: Form to create a new booking — date picker, duration,
//          notes, confirm. Imported by app_router as "/booking".
// ============================================================
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../shared/widgets/app_button.dart';
import '../viewmodels/booking_viewmodel.dart';

class BookingScreen extends ConsumerStatefulWidget {
  const BookingScreen({super.key});

  @override
  ConsumerState<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends ConsumerState<BookingScreen> {
  final _formKey = GlobalKey<FormState>();
  DateTime _scheduledAt = DateTime.now().add(const Duration(hours: 1));
  int _durationHours = 1;
  final _notesController = TextEditingController();

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(bookingProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('New Booking')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppDimensions.pagePadding),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Schedule Date & Time', style: AppTextStyles.labelLg),
              const SizedBox(height: AppDimensions.s8),
              InkWell(
                onTap: _pickDateTime,
                child: Container(
                  padding: const EdgeInsets.all(AppDimensions.s16),
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.border),
                    borderRadius:
                        BorderRadius.circular(AppDimensions.radiusMd),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.calendar_today_outlined,
                          color: AppColors.primary),
                      const SizedBox(width: AppDimensions.s12),
                      Text(
                        '${_scheduledAt.day}/${_scheduledAt.month}/${_scheduledAt.year}  '
                        '${_scheduledAt.hour.toString().padLeft(2, '0')}:${_scheduledAt.minute.toString().padLeft(2, '0')}',
                        style: AppTextStyles.bodyMd,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: AppDimensions.s24),
              Text('Duration (hours)', style: AppTextStyles.labelLg),
              const SizedBox(height: AppDimensions.s8),
              Row(
                children: [
                  IconButton(
                    onPressed: () => setState(() {
                      if (_durationHours > 1) _durationHours--;
                    }),
                    icon: const Icon(Icons.remove_circle_outline),
                  ),
                  Text('$_durationHours', style: AppTextStyles.h3),
                  IconButton(
                    onPressed: () =>
                        setState(() => _durationHours++),
                    icon: const Icon(Icons.add_circle_outline),
                  ),
                ],
              ),
              const SizedBox(height: AppDimensions.s24),
              Text('Notes (optional)', style: AppTextStyles.labelLg),
              const SizedBox(height: AppDimensions.s8),
              TextFormField(
                controller: _notesController,
                maxLines: 3,
                decoration: const InputDecoration(
                  hintText: 'Any special requirements…',
                ),
              ),
              const SizedBox(height: AppDimensions.s32),
              if (state.error != null) ...[
                Text(state.error!,
                    style:
                        AppTextStyles.bodySm.copyWith(color: AppColors.error)),
                const SizedBox(height: AppDimensions.s16),
              ],
              AppButton(
                label: 'Proceed to Confirm',
                isLoading: state.isSubmitting,
                onPressed: () =>
                    context.push('/booking/confirm'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _pickDateTime() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _scheduledAt,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 90)),
    );
    if (date == null || !mounted) return;
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_scheduledAt),
    );
    if (time == null || !mounted) return;
    setState(() {
      _scheduledAt = DateTime(
        date.year,
        date.month,
        date.day,
        time.hour,
        time.minute,
      );
    });
  }
}
