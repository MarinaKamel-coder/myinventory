import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:supermoms/src/models/carton.dart';

class CartonLabelPreviewScreen extends StatelessWidget {
  const CartonLabelPreviewScreen({
    required this.box,
    required this.bytes,
    super.key,
  });

  final Carton box;
  final Uint8List bytes;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Aperçu de l’étiquette')),
      body: PdfPreview(
        build: (PdfPageFormat format) async => bytes,
        allowPrinting: true,
        allowSharing: true,
        canChangePageFormat: false,
        canChangeOrientation: false,
        pdfFileName: 'etiquette_${box.name}.pdf',
      ),
    );
  }
}
