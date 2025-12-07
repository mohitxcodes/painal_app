import 'package:flutter/material.dart';
import 'widgets/AboutVillageWidget.dart';
import 'widgets/CurrentWeatherWidget.dart';
import 'widgets/LocationInfoWidget.dart';

class OverviewScreen extends StatelessWidget {
  const OverviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF0B3B2D), Color(0xFF155D42)],
          stops: [0.0, 1.0],
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
