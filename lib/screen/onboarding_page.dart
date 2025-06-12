import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:vireo/constants/primary_colors.dart';

class OnboardingScreen extends StatefulWidget {
  final VoidCallback onFinish;

  const OnboardingScreen({super.key, required this.onFinish});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int _currentIndex = 0;

  final List<Map<String, String>> onboardingData = [
    {
      'image': 'assets/images/onboarding1.png',
      'title': 'Selamat Datang di Vireo',
      'desc':
          'Tempat semua impianmu hidup, tumbuh, dan jadi nyata. Yuk mulai menulis mimpi besar maupun kecil',
      'button': 'Let\'s Start',
    },
    {
      'image': 'assets/images/onboarding2.png',
      'title': 'Buat & Kelola Impianmu',
      'desc':
          'Tambahkan impian sesuasanya, beri kategori, dan pantau progresnya langkah demi langkah.',
    },
    {
      'image': 'assets/images/onboarding3.png',
      'title': 'Wujudkan Impianmu',
      'desc':
          'Atur tanggal target dan biarkan kami bantu mengingatkannya. Karena setiap impian butuh aksi nyata.',
    },
    {
      'image': 'assets/images/onboarding4.png',
      'title': 'Yuk Mulai!',
      'desc':
          'Ayo mulai perjalananmu hari ini. Impianmu menunggu untuk diwujudkan!',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView.builder(
            controller: _controller,
            itemCount: onboardingData.length,
            onPageChanged: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            itemBuilder: (context, index) {
              final item = onboardingData[index];
              return Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 60,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    //sisanya masuk ke sini
                    if (item['image'] != null)
                      Image.asset(item['image']!, height: 250),
                    const SizedBox(height: 48),
                    Text(
                      item['title'] ?? '',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w900,
                        color: primaryColor,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      item['desc'] ?? '',
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 16, color: Colors.black),
                    ),
                    const SizedBox(height: 60),
                    //awal masuk disini karena index 0
                    if (index == 0)
                      ElevatedButton(
                        onPressed: () {
                          _controller.nextPage(
                            duration: const Duration(milliseconds: 400),
                            curve: Curves.easeInOut,
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 120,
                            vertical: 16,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Let\'s Start',
                              style: TextStyle(fontSize: 16),
                            ),
                            SizedBox(width: 8),
                            Icon(Icons.arrow_forward),
                          ],
                        ),
                      ),
                  ],
                ),
              );
            },
          ),
          if (_currentIndex != 0)
            Positioned(
              bottom: 40,
              left: 24,
              right: 24,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,

                children: [
                  TextButton(
                    onPressed:
                        () => _controller.jumpToPage(onboardingData.length - 1),
                    child: const Text('Skip'),
                  ),
                  SmoothPageIndicator(
                    controller: _controller,
                    count: onboardingData.length,
                    effect: WormEffect(
                      dotColor: Colors.grey.shade300,
                      activeDotColor: primaryColor,
                      dotWidth: 15,
                      dotHeight: 7,
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: primaryColor,
                      shape: BoxShape.circle,
                      
                    ),
                    child: IconButton(
                      icon: Icon(
                        _currentIndex == onboardingData.length - 1
                            ? Icons.check
                            : Icons.arrow_forward_ios_rounded,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        if (_currentIndex == onboardingData.length - 1) {
                          widget.onFinish();
                        } else {
                          _controller.nextPage(
                            duration: const Duration(milliseconds: 400),
                            curve: Curves.easeInOut,
                          );
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
