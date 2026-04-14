import 'package:flutter/material.dart';
import 'package:supermoms/app/theme/app_colors.dart';

class ScanCartonScreen extends StatelessWidget {
  const ScanCartonScreen({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: Colors.black, // Effet caméra
        appBar: AppBar(
          title: const Text('Scanner un carton', style: TextStyle(color: Colors.white)),
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 250,
                height: 250,
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.headerMid, width: 4),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Icon(Icons.qr_code_scanner, size: 100, color: Colors.white54),
              ),
              const SizedBox(height: 30),
              const Text(
                'Placez le QR Code dans le cadre',
                style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ),
      );
}
