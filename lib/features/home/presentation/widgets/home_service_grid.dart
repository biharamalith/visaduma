// ============================================================
// FILE: lib/features/home/presentation/widgets/home_service_grid.dart
// PURPOSE: 3×2 grid of service category cards on the HomeScreen.
// ============================================================

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeServiceGrid extends StatelessWidget {
  final void Function(String route) onServiceTap;

  const HomeServiceGrid({super.key, required this.onServiceTap});

  static const _services = [
    _ServiceItem(
      icon: Icons.handyman_rounded,
      label: 'Services',
      route: '/services',
      color: Color(0xFF2563EB),
      bgColor: Color(0xFFEFF6FF),
    ),
    _ServiceItem(
      icon: Icons.two_wheeler_rounded,
      label: 'Rides',
      route: '/rides',
      color: Color(0xFF7C3AED),
      bgColor: Color(0xFFF5F3FF),
    ),
    _ServiceItem(
      icon: Icons.storefront_rounded,
      label: 'Shops',
      route: '/shops',
      color: Color(0xFF0891B2),
      bgColor: Color(0xFFECFEFF),
    ),
    _ServiceItem(
      icon: Icons.directions_car_rounded,
      label: 'Vehicles',
      route: '/vehicles',
      color: Color(0xFF059669),
      bgColor: Color(0xFFECFDF5),
    ),
    _ServiceItem(
      icon: Icons.work_rounded,
      label: 'Jobs',
      route: '/jobs',
      color: Color(0xFFD97706),
      bgColor: Color(0xFFFFFBEB),
    ),
    _ServiceItem(
      icon: Icons.apartment_rounded,
      label: 'Boarding',
      route: '/boarding',
      color: Color(0xFFDB2777),
      bgColor: Color(0xFFFDF2F8),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 3,
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      childAspectRatio: 1,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: _services
          .map((s) => _ServiceCard(item: s, onTap: () => onServiceTap(s.route)))
          .toList(),
    );
  }
}

class _ServiceCard extends StatelessWidget {
  final _ServiceItem item;
  final VoidCallback onTap;

  const _ServiceCard({required this.item, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF2563EB).withOpacity(0.10),
              blurRadius: 16,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: item.bgColor,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(item.icon, color: item.color, size: 26),
            ),
            const SizedBox(height: 8),
            Text(
              item.label,
              style: GoogleFonts.dmSans(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF111827),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _ServiceItem {
  final IconData icon;
  final String label;
  final String route;
  final Color color;
  final Color bgColor;

  const _ServiceItem({
    required this.icon,
    required this.label,
    required this.route,
    required this.color,
    required this.bgColor,
  });
}
