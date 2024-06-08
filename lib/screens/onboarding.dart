import 'package:flutter/material.dart';
import 'package:gericare/constants.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: Stack(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    logoPath,
                    height: 107,
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "Let's get started!",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Login to enjoy the features we’ve provided, and stay healthy!",
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: pageButton(
                  "Continue",
                  primaryColor,
                  Colors.white,
                  onPressed: () {
                    Navigator.pushNamed(context, '/login');
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget pageButton(title, Color bgColor, Color textColor,
      {Function()? onPressed}) {
    return Container(
      width: double.infinity,
      height: 55,
      margin: const EdgeInsets.only(bottom: 20),
      child: TextButton(
        style: TextButton.styleFrom(
          backgroundColor: bgColor,
          foregroundColor: textColor,
          shape: const StadiumBorder(
              side: BorderSide(color: primaryColor, width: 1)),
        ),
        onPressed: onPressed,
        child: Text(title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
      ),
    );
  }
}
