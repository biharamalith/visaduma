// ============================================================
// FILE: lib/shared/widgets/app_loading.dart
// PURPOSE: Centralised loading widget — a branded spinner.
//          Use inside AsyncValue.when(loading: ...) callbacks.
// ============================================================

import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

class AppLoading extends StatelessWidget {
  final double size;
  const AppLoading({super.key, this.size = 44});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: size,
        height: size,
        child: CircularProgressIndicator(
          color: AppColors.primary,
          strokeWidth: 3,
          strokeCap: StrokeCap.round,
        ),
      ),
    );
  }
}
