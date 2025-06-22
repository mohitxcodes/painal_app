import 'package:flutter/material.dart';
import 'widgets/CarouselWidget.dart';
import 'widgets/AboutVillageWidget.dart';
import 'widgets/CurrentWeatherWidget.dart';
import 'widgets/LocationInfoWidget.dart';
import 'widgets/DemographicsWidget.dart';

class OverviewScreen extends StatelessWidget {
  const OverviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const CarouselWidget(),
          const SizedBox(height: 20),
          const AboutVillageWidget(),
          const SizedBox(height: 20),
          const CurrentWeatherWidget(),
          const SizedBox(height: 20),
          const LocationInfoWidget(),
          const SizedBox(height: 20),
          const DemographicsWidget(),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
