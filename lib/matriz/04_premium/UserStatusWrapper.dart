import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:guarda_corpo_2024/components/autenticacao/auth_page.dart';
import 'package:guarda_corpo_2024/matriz/04_premium/subscription_service.dart';

class UserStatusWrapper extends StatefulWidget {
  final Widget child;

  const UserStatusWrapper({super.key, required this.child});

  @override
  UserStatusWrapperState createState() => UserStatusWrapperState();
}

class UserStatusWrapperState extends State<UserStatusWrapper> {
  bool _isLoading = true;
  bool _isPremium = false;

  @override
  void initState() {
    super.initState();
    _checkUserStatus();
  }

  void _checkUserStatus() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const AuthPage()),
      );
      return;
    }

    final isPremium = await SubscriptionService().isUserPremium(user.uid);
    setState(() {
      _isPremium = isPremium;
      _isLoading = false;
    });

    if (_isPremium) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Você é premium! Aproveite sem anúncios.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return widget.child;
  }
}
