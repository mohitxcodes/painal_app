import 'package:flutter/material.dart';

class AppFounderScreen extends StatelessWidget {
  const AppFounderScreen({super.key});

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
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios_new_rounded,
              color: Colors.white,
            ),
            onPressed: () => Navigator.pop(context),
          ),
          centerTitle: true,
          title: const Text(
            'App Founders',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 20,
              letterSpacing: 0.5,
            ),
          ),
        ),
        body: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            children: [
              _buildPersonCard(
                name: 'Sabhajeet Kumar',
                role: 'Visionary & Guide',
                description:
                    'इस एप्लिकेशन का मूल विचार श्री सभजीत कुमार जी द्वारा दिया गया था। उन्होंने महसूस किया कि हमारे समाज को एक डिजिटल मंच की आवश्यकता है जो हमें एक साथ ला सके और हमारी संस्कृति को संरक्षित कर सके। उनके मार्गदर्शन और दूरदर्शिता ने हमें इस ऐप को विकसित करने के लिए प्रेरित किया। यह प्रयास उनके सपने को साकार करने की दिशा में एक छोटा सा कदम है।',
                image: 'assets/logo/sabhajeet-logo.png',
                isFather: true,
              ),
              const SizedBox(height: 24),
              _buildPersonCard(
                name: 'Mohit Singh',
                role: 'Developer & Creator',
                description:
                    'इस ऐप को बनाने की प्रेरणा मुझे मेरे पिताजी से मिली। उनकी सोच थी कि हमारे गांव का इतिहास और धरोहर डिजिटल रूप में सुरक्षित रहे। मैंने उनकी (Satendra Singh) इस सोच को हकीकत में बदलने के लिए यह ऐप बनाया है। यह ऐप हमारी जड़ों को आधुनिक तकनीक से जोड़ने का एक छोटा सा प्रयास है।',
                image: 'assets/logo/mohit-dp.jpeg',
                isFather: false,
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPersonCard({
    required String name,
    required String role,
    required String description,
    required String image,
    required bool isFather,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withOpacity(0.1), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withOpacity(0.1),
              border: Border.all(
                color: Colors.white.withOpacity(0.2),
                width: 1,
              ),
            ),
            child: CircleAvatar(radius: 50, backgroundImage: AssetImage(image)),
          ),
          const SizedBox(height: 16),
          Text(
            name,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 4),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              role.toUpperCase(),
              style: TextStyle(
                color: Colors.white.withOpacity(0.9),
                fontSize: 10,
                fontWeight: FontWeight.w600,
                letterSpacing: 1.0,
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            description,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white.withOpacity(0.8),
              fontSize: 15,
              height: 1.6,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}
