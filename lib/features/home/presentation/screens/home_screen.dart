// ============================================================
// FILE: lib/features/home/presentation/screens/home_screen.dart
// PURPOSE: Main home screen — gradient header, quick actions,
//          promo banner, service grid, jobs & boarding cards.
// ============================================================

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/home_service_grid.dart';
import '../widgets/home_header.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFF),
      body: CustomScrollView(
        slivers: [
          // ── Gradient header + search ─────────────────────
          SliverToBoxAdapter(child: HomeHeader()),

          // ── Body content ─────────────────────────────────
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 2),

                // ── Main navigation grid ───────────────────
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: HomeServiceGrid(
                    onServiceTap: (route) => context.push(route),
                  ),
                ),

                const SizedBox(height: 6),

                // ── Promo banner ──────────────────────────
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF2563EB), Color(0xFF1D4ED8)],
                      ),
                      borderRadius: BorderRadius.circular(18),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Special Offer',
                                style: GoogleFonts.dmSans(
                                  fontSize: 11,
                                  color: Colors.white.withOpacity(0.8),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '20% off your\nfirst booking!',
                                style: GoogleFonts.dmSans(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                  height: 1.3,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  'Book Now',
                                  style: GoogleFonts.dmSans(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w700,
                                    color: const Color(0xFF2563EB),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Text('🎉', style: TextStyle(fontSize: 52)),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 6),

                // ── Popular Services heading ───────────────
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Popular Services',
                        style: GoogleFonts.dmSans(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF111827),
                        ),
                      ),
                      GestureDetector(
                        onTap: () => context.push('/services'),
                        child: Text(
                          'See all',
                          style: GoogleFonts.dmSans(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF2563EB),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 2),

                // ── Popular services grid ─────────────────
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: _PopularServicesGrid(),
                ),

                const SizedBox(height: 32),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Popular Services grid ─────────────────────────────────

class _PopularServicesGrid extends StatelessWidget {
  const _PopularServicesGrid();

  static const _items = [
    _PSItem(icon: Icons.handyman_rounded,          label: 'Carpenters',    color: Color(0xFF2563EB), bg: Color(0xFFEFF6FF)),
    _PSItem(icon: Icons.bolt_rounded,              label: 'Electricians',  color: Color(0xFFD97706), bg: Color(0xFFFFFBEB)),
    _PSItem(icon: Icons.plumbing_rounded,          label: 'Plumbers',      color: Color(0xFF0891B2), bg: Color(0xFFECFEFF)),
    _PSItem(icon: Icons.format_paint_rounded,      label: 'Painters',      color: Color(0xFFDB2777), bg: Color(0xFFFDF2F8)),
    _PSItem(icon: Icons.ac_unit_rounded,           label: 'AC Repair',     color: Color(0xFF7C3AED), bg: Color(0xFFF5F3FF)),
    _PSItem(icon: Icons.cleaning_services_rounded, label: 'Cleaning',      color: Color(0xFF059669), bg: Color(0xFFECFDF5)),
  ];

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 3,
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      childAspectRatio: 0.95,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: _items.map((item) => _PSCard(item: item)).toList(),
    );
  }
}

class _PSCard extends StatelessWidget {
  final _PSItem item;
  const _PSCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF2563EB).withOpacity(0.08),
            blurRadius: 14,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: item.bg,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(item.icon, color: item.color, size: 24),
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
    );
  }
}

class _PSItem {
  final IconData icon;
  final String label;
  final Color color;
  final Color bg;
  const _PSItem({required this.icon, required this.label, required this.color, required this.bg});
}
