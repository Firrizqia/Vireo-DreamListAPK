import 'package:flutter/material.dart';
import 'package:vireo/constants/primary_colors.dart'; // Sesuaikan dengan path-mu
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:vireo/main.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  bool _isLastPage = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _controller,
        onPageChanged: (index) {
          setState(() {
            _isLastPage = index == 2;
          });
        },
        children: [
          _buildPage(
            image: 'assets/images/onboarding1.png',
            title: 'Selamat Datang di Vireo',
            description: 'Tempat impianmu menjadi lebih terarah dan tercapai.',
          ),
          _buildPage(
            image: 'assets/images/onboarding2.png',
            title: 'Pantau Progresmu',
            description: 'Catat perkembangan mimpimu setiap hari dengan mudah.',
          ),
          _buildPage(
            image: 'assets/images/onboarding3.png',
            title: 'Wujudkan Impianmu',
            description: 'Ayo mulai langkah kecilmu menuju mimpi besar!',
          ),
        ],
      ),
      bottomSheet: _isLastPage
          ? TextButton(
              onPressed: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => const MainScreen()),
                );
              },
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                color: primaryColor,
                child: const Center(
                  child: Text(
                    'Mulai Sekarang',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ),
            )
          : Container(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              height: 80,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () {
                      _controller.jumpToPage(2);
                    },
                    child: const Text('Lewati'),
                  ),
                  SmoothPageIndicator(
                    controller: _controller,
                    count: 3,
                    effect: WormEffect(dotColor: Colors.grey, activeDotColor: primaryColor),
                  ),
                  TextButton(
                    onPressed: () {
                      _controller.nextPage(
                          duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
                    },
                    child: const Text('Lanjut'),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildPage({required String image, required String title, required String description}) {
    return Padding(
      padding: const EdgeInsets.all(40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(image, height: 250),
          const SizedBox(height: 32),
          Text(title, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          Text(description,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16, color: Colors.grey)),
        ],
      ),
    );
  }
}