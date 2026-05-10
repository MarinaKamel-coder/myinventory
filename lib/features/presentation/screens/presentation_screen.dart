import 'package:flutter/material.dart';
import 'package:supermoms/features/authentification/auth_gate.dart';

class PresentationScreen extends StatelessWidget {
  const PresentationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FE),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [

              const SizedBox(height: 40),

              // LOGO
              Image.asset(
                'assets/images/logo.png',
                height: 120,
              ),

              const SizedBox(height: 25),

              // TITRE
              const Text(
                'MyInventory',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2D3142),
                ),
              ),

              const SizedBox(height: 15),

              // DESCRIPTION
              const Text(
                'L’assistant intelligent pour un déménagement sans stress',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.grey,
                  height: 1.5,
                ),
              ),

              const SizedBox(height: 40),

              // FONCTIONNALITÉS

              _buildFeature(
                Icons.inventory_2_outlined,
                'Gestion des cartons',
                'Organisez facilement vos cartons.',
              ),

              const SizedBox(height: 15),

              _buildFeature(
                Icons.photo_camera_outlined,
                'Ajout de photos',
                'Ajoutez des photos aux objets.',
              ),

              const SizedBox(height: 15),

              _buildFeature(
                Icons.qr_code,
                'QR Codes',
                'Scannez rapidement vos cartons.',
              ),

              const SizedBox(height: 50),

              // BOUTON CONNEXION

              SizedBox(
                width: double.infinity,
                height: 55,

                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF7F56D9),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
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
                    'Se connecter',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 15),

              // BOUTON CREATE ACCOUNT

              SizedBox(
                width: double.infinity,
                height: 55,

                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(
                      color: Color(0xFF7F56D9),
                    ),

                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
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
                    'Créer un compte',
                    style: TextStyle(
                      color: Color(0xFF7F56D9),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static Widget _buildFeature(
    IconData icon,
    String title,
    String description,
  ) {
    return Container(
      padding: const EdgeInsets.all(18),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
          ),
        ],
      ),

      child: Row(
        children: [

          Container(
            padding: const EdgeInsets.all(12),

            decoration: BoxDecoration(
              color: const Color(0xFFEDE7FF),
              borderRadius: BorderRadius.circular(12),
            ),

            child: Icon(
              icon,
              color: const Color(0xFF7F56D9),
            ),
          ),

          const SizedBox(width: 15),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [

                Text(
                  title,

                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),

                const SizedBox(height: 5),

                Text(
                  description,
                  style: const TextStyle(
                    color: Colors.grey,
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