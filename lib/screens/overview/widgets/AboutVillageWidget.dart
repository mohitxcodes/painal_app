import 'package:flutter/material.dart';

class AboutVillageWidget extends StatelessWidget {
  const AboutVillageWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Card(
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.location_city, color: Colors.green[700], size: 30),
                  const SizedBox(width: 10),
                  const Text(
                    'About Painal Village',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              const Text(
                'पैनाल',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Painal is a vibrant village located in Bihta Block of Patna District, Bihar. With a population of 9,618 people, it represents the rich cultural heritage and agricultural traditions of rural India. The village is known for its strong community bonds, traditional festivals, and active participation in local governance.',
                style: TextStyle(fontSize: 16, height: 1.5, color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
