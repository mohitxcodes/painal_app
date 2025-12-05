import 'package:flutter/material.dart';
import 'widgets/AboutVillageWidget.dart';
import 'widgets/CurrentWeatherWidget.dart';
import 'widgets/LocationInfoWidget.dart';
import 'widgets/AppFeaturesCarousel.dart';

class OverviewScreen extends StatelessWidget {
  const OverviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF0B3B2D), Color(0xFF1F6B3A)],
        ),
      ),
      child: SingleChildScrollView(
        child: Column(
          children: const [
            AboutVillageWidget(),
            CurrentWeatherWidget(),
            SizedBox(height: 12),
            LocationInfoWidget(),
            SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}
