import 'package:flutter/material.dart';

class VillageStatCard extends StatelessWidget {
  const VillageStatCard({
    super.key,
    required this.icon,
    required this.value,
    required this.primaryLabel,
    required this.secondaryLabel,
    this.duration = const Duration(milliseconds: 600),
    this.curve = Curves.easeInOut,
  });

  final IconData icon;
  final String value;
  final String primaryLabel;
  final String secondaryLabel;
  final Duration duration;
  final Curve curve;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: duration,
      curve: curve,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
        gradient: LinearGradient(
          colors: [
            Colors.white.withOpacity(0.18),
            Colors.white.withOpacity(0.06),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 4),
          Icon(icon, color: Colors.white, size: 24),
          const SizedBox(height: 6),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            primaryLabel,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Colors.white70,
            ),
          ),
          Text(
            secondaryLabel,
            style: const TextStyle(fontSize: 11, color: Colors.white60),
          ),
        ],
      ),
    );
  }
}
