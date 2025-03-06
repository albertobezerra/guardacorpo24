import 'package:flutter/material.dart';
import 'package:guarda_corpo_2024/matriz/04_premium/subscription_service.dart';
import 'package:guarda_corpo_2024/services/admob/conf/interstitial_ad_manager.dart';

class PremiumButton extends StatelessWidget {
  final String buttonText;
  final String imagePath;
  final Widget destinationScreen;
  final double buttonHeight;

  const PremiumButton({
    super.key,
    required this.buttonText,
    required this.imagePath,
    required this.destinationScreen,
    this.buttonHeight = 250,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: SubscriptionService().isUserPremium(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }

        final isPremium = snapshot.data ?? false;

        return MaterialButton(
          padding: const EdgeInsets.only(left: 16, right: 16, bottom: 12),
          onPressed: isPremium
              ? () => InterstitialAdManager.showInterstitialAd(
                    context,
                    destinationScreen,
                  )
              : null,
          child: Stack(
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                height: buttonHeight,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18),
                  image: DecorationImage(
                    image: ExactAssetImage(imagePath),
                    colorFilter: !isPremium
                        ? const ColorFilter.mode(
                            Colors.grey,
                            BlendMode.saturation,
                          )
                        : null,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Positioned(
                left: 12, // Alinha horizontalmente à esquerda
                bottom: 8, // Alinha verticalmente à base
                child: Text(
                  buttonText.toUpperCase(),
                  style: TextStyle(
                    color: !isPremium ? Colors.grey : Colors.white,
                    fontFamily: 'Segoe Bold',
                    fontSize: 16,
                  ),
                ),
              ),
              if (!isPremium)
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    width: 32,
                    height: 32,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Image.asset(
                        'assets/images/crown.png',
                        width: 22,
                        height: 22,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
