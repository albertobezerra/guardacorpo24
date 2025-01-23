import 'package:flutter/material.dart';
import 'package:guarda_corpo_2024/splash.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  OnboardingPageState createState() => OnboardingPageState();
}

class OnboardingPageState extends State<OnboardingPage> {
  Future<void> completeOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('hasCompletedOnboarding', true);
    await prefs.setBool('hasShownSplash', true);
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const SplashScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return IntroductionScreen(
      globalBackgroundColor: const Color.fromARGB(255, 255, 255, 255),
      pages: [
        PageViewModel(
          titleWidget: Container(),
          bodyWidget: Container(),
          image: Image.asset(
            'assets/images/onb1.png',
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          decoration: const PageDecoration(
            fullScreen: true,
            bodyFlex: 0,
            imageFlex: 1,
            pageColor: Colors.transparent,
          ),
        ),
        PageViewModel(
          titleWidget: Container(),
          bodyWidget: Container(),
          image: Image.asset(
            'assets/images/onb2.png',
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          decoration: const PageDecoration(
            fullScreen: true,
            bodyFlex: 0,
            imageFlex: 1,
            pageColor: Colors.transparent,
          ),
        ),
        PageViewModel(
          titleWidget: Container(),
          bodyWidget: Container(),
          image: Image.asset(
            'assets/images/onb3.png',
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          decoration: const PageDecoration(
            fullScreen: true,
            bodyFlex: 0,
            imageFlex: 1,
            pageColor: Colors.transparent,
          ),
        ),
        PageViewModel(
          titleWidget: Container(),
          bodyWidget: Container(),
          image: Image.asset(
            'assets/images/onb4.png',
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          decoration: const PageDecoration(
            fullScreen: true,
            bodyFlex: 0,
            imageFlex: 1,
            pageColor: Colors.transparent,
          ),
        ),
        PageViewModel(
          titleWidget: Container(),
          bodyWidget: Container(),
          image: Image.asset(
            'assets/images/onb5.png',
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          decoration: const PageDecoration(
            fullScreen: true,
            bodyFlex: 0,
            imageFlex: 1,
            pageColor: Colors.transparent,
          ),
        ),
      ],
      onDone: completeOnboarding,
      onSkip: completeOnboarding,
      showSkipButton: true,
      skip: Container(),
      next: const Icon(Icons.arrow_forward, color: Colors.black),
      done: const Text("Feito",
          style: TextStyle(fontWeight: FontWeight.w600, color: Colors.black)),
      dotsDecorator: const DotsDecorator(
        color: Colors.black54,
        activeColor: Colors.black,
        size: Size(6, 6),
        activeSize: Size(10, 10),
        activeShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(25)),
        ),
      ),
    );
  }
}
