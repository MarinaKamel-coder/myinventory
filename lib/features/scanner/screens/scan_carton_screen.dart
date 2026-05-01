import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:provider/provider.dart';
import 'package:supermoms/app/theme/app_colors.dart';
import 'package:supermoms/features/cartons/screens/carton_detail_screen.dart';
import 'package:supermoms/src/providers/carton_provider.dart';

class ScanCartonScreen extends StatefulWidget {
  const ScanCartonScreen({super.key});

  @override
  State<ScanCartonScreen> createState() => _ScanCartonScreenState();
}

class _ScanCartonScreenState extends State<ScanCartonScreen> {
  final MobileScannerController _controller = MobileScannerController(
    detectionSpeed: DetectionSpeed.noDuplicates,
    facing: CameraFacing.back,
  );

  bool _isNavigating = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _openCartonFromQr(String rawValue) async {
    if (_isNavigating) return;

    final provider = context.read<CartonProvider>();
    if (provider.totalCartons == 0) {
      await provider.loadCartons();
    }

    final cartonId = rawValue.trim();
    final carton = provider.findById(cartonId);

    if (carton == null) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Aucun carton ne correspond à ce QR code.')),
      );
      return;
    }

    _isNavigating = true;
    await _controller.stop();
    if (!mounted) return;

    await Navigator.push(
      context,
      MaterialPageRoute<void>(builder: (_) => CartonDetailScreen(box: carton)),
    );

    if (!mounted) return;
    _isNavigating = false;
    await _controller.start();
  }

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
        body: Stack(
          fit: StackFit.expand,
          children: [
            MobileScanner(
              controller: _controller,
              onDetect: (capture) {
                final barcode = capture.barcodes.isNotEmpty ? capture.barcodes.first : null;
                final rawValue = barcode?.rawValue;
                if (rawValue == null || rawValue.isEmpty) return;
                _openCartonFromQr(rawValue);
              },
              errorBuilder: (context, error) => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error, color: Colors.red, size: 48),
                    const SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        error.errorCode == MobileScannerErrorCode.permissionDenied
                            ? "Permission caméra refusée. Activez-la dans les réglages."
                            : "Impossible d'utiliser la caméra (${error.errorCode.name}).",
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.white, fontSize: 13),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            IgnorePointer(
              child: Center(
                child: Container(
                  width: 250,
                  height: 250,
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.headerMid, width: 4),
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 60,
               child: Column(
                  children: [
                    const Text(
                      'Placez le QR Code dans le cadre',
                      style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
            ),
          ],
        ),
      );
}
