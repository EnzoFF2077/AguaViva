import 'package:flutter/material.dart';

import 'theme/app_theme.dart';

class StartupPage extends StatelessWidget {
  const StartupPage({
    super.key,
    this.message = 'Abrindo o aplicativo…',
  });

  final String message;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.water_drop, color: Colors.white, size: 64),
            const SizedBox(height: 16),
            const Text(
              'ÁguaViva',
              style: TextStyle(
                color: Colors.white,
                fontSize: 34,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 24),
            const CircularProgressIndicator(color: Colors.white),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Text(
                message,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white70, fontSize: 15),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
