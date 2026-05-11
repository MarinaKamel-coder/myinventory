import 'package:flutter/material.dart';
import 'package:supermoms/features/authentification/auth_gate.dart';

class PresentationScreen extends StatelessWidget {
  const PresentationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,

        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF7F56D9),
              Color(0xFF4A90E2),
              Color(0xFFF8F9FE),
            ],
          ),
        ),

        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(30),

            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                // LOGO
                Container(
                  padding: const EdgeInsets.all(25),

                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    shape: BoxShape.circle,
                  ),

                  child: Image.asset(
                    'assets/images/logo.png',
                    height: 120,
                  ),
                ),

                const SizedBox(height: 40),

                // TITRE
                const Text(
                  'MyInventory',
                  textAlign: TextAlign.center,

                  style: TextStyle(
                    fontSize: 38,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 1,
                  ),
                ),

                const SizedBox(height: 20),

                // SLOGAN
                const Text(
                  'L’assistant intelligent pour un déménagement sans stress',
                  textAlign: TextAlign.center,

                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white70,
                    height: 1.5,
                  ),
                ),

                const SizedBox(height: 80),

                // BOUTON DÉCOUVRIR

                SizedBox(
                  width: double.infinity,
                  height: 60,

                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,

                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                    ),

                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const AuthGate(),
                        ),
                      );
                    },

                    child: const Text(
                      'Découvrir',
                      style: TextStyle(
                        color: Color(0xFF7F56D9),
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}