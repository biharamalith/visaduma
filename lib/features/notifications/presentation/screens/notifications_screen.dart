// ============================================================
// FILE: lib/features/notifications/presentation/screens/notifications_screen.dart
// ============================================================
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/utils/formatters.dart';

class NotificationsScreen extends ConsumerWidget {
  const NotificationsScreen({super.key});

  static const _types = [
    (icon: Icons.calendar_today_outlined, color: AppColors.primary),
    (icon: Icons.chat_bubble_outline, color: AppColors.infoBlue),
    (icon: Icons.campaign_outlined, color: AppColors.warningAmber),
    (icon: Icons.info_outline, color: AppColors.success),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Notifications'),
        actions: [
          TextButton(
            onPressed: () {},
            child: const Text('Mark all read'),
          ),
        ],
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(AppDimensions.pagePadding),
        itemCount: 10,
        separatorBuilder: (_, __) => const Divider(height: 1),
        itemBuilder: (_, i) {
          final typeInfo = _types[i % _types.length];
          final isRead = i % 3 == 0;
          return ListTile(
            tileColor: isRead ? null : AppColors.primarySurface,
            leading: Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: typeInfo.color.withOpacity(0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(typeInfo.icon, color: typeInfo.color, size: 22),
            ),
            title: Text(
              'Notification title ${i + 1}',
              style: AppTextStyles.labelMd,
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Notification body message for item ${i + 1}.',
                  style: AppTextStyles.bodySm
                      .copyWith(color: AppColors.textSecondary),
                ),
                const SizedBox(height: 2),
                Text(
                  Formatters.timeAgo(
                    DateTime.now().subtract(Duration(hours: i + 1)),
                  ),
                  style: AppTextStyles.caption,
                ),
              ],
            ),
            trailing: isRead
                ? null
                : Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                    ),
                  ),
            onTap: () {},
          );
        },
      ),
    );
  }
}
