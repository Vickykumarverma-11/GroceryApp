import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF6FCF97), // Green background
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            const Spacer(),
            // Carrot Icon
            Icon(
              Icons.emoji_food_beverage_rounded, // Placeholder for carrot
              size: 64,
              color: Colors.white,
            ),
            const SizedBox(height: 16),
            // Brand Name
            const Text(
              'Grocery',
              style: TextStyle(
                color: Colors.white,
                fontSize: 48,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 6),
            // Subtitle
            const Text(
              'online groceriet',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                letterSpacing: 2,
                fontWeight: FontWeight.w400,
              ),
            ),
            const Spacer(),
            const SizedBox(height: 44), // For bottom padding
          ],
        ),
      ),
    );
  }
}
