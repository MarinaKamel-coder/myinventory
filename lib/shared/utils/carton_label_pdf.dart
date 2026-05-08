import 'package:barcode/barcode.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:supermoms/src/models/carton.dart';

/// Génère un PDF d'étiquette (nom, pièce, QR, nombre d'objets) pour impression ou partage.
Future<Uint8List> buildCartonLabelPdf(Carton box, {required int itemCount}) async {
  final pdf = pw.Document();
  final dateStr = DateFormat('dd MMM yyyy').format(box.createdAt);

  pw.MemoryImage? logoImage;
  try {
    final data = await rootBundle.load('assets/images/logo.png');
    logoImage = pw.MemoryImage(data.buffer.asUint8List());
  } catch (_) {
    logoImage = null;
  }

  final qr = Barcode.qrCode();
  final shortId = box.id.length > 16 ? '${box.id.substring(0, 16)}...' : box.id;

  pdf.addPage(
    pw.Page(
      pageFormat: PdfPageFormat.a4,
      margin: const pw.EdgeInsets.all(20),
      build: (context) => pw.Column(
        children: [
          pw.SizedBox(height: 24),
          pw.Container(
            width: 340,
            decoration: pw.BoxDecoration(
              color: PdfColors.white,
              borderRadius: pw.BorderRadius.circular(10),
              border: pw.Border.all(color: PdfColors.blueGrey100, width: 1),
            ),
            child: pw.Column(
              children: [
                pw.Container(
                  width: double.infinity,
                  padding: const pw.EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  decoration: const pw.BoxDecoration(
                    color: PdfColor(0.93, 0.96, 1),
                    borderRadius: pw.BorderRadius.only(
                      topLeft: pw.Radius.circular(9),
                      topRight: pw.Radius.circular(9),
                    ),
                  ),
                  child: pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.center,
                    children: [
                      if (logoImage != null) pw.Image(logoImage, width: 24, height: 24),
                      if (logoImage != null) pw.SizedBox(width: 8),
                      pw.Text(
                        'ETIQUETTE DE CARTON',
                        style: pw.TextStyle(
                          fontSize: 14,
                          fontWeight: pw.FontWeight.bold,
                          color: PdfColors.blueGrey900,
                        ),
                      ),
                    ],
                  ),
                ),
                pw.Padding(
                  padding: const pw.EdgeInsets.fromLTRB(18, 14, 18, 16),
                  child: pw.Column(
                    children: [
                      pw.Text(
                        'Identification rapide du carton',
                        style: pw.TextStyle(fontSize: 8.5, color: PdfColors.blueGrey500),
                      ),
                      pw.SizedBox(height: 12),
                pw.Container(
                        width: 150,
                        height: 150,
                        padding: const pw.EdgeInsets.all(8),
                        decoration: pw.BoxDecoration(
                          color: PdfColors.white,
                          border: pw.Border.all(color: PdfColors.blueGrey100, width: 1),
                          borderRadius: pw.BorderRadius.circular(6),
                        ),
                        child: pw.BarcodeWidget(
                          barcode: qr,
                          data: box.id,
                          drawText: false,
                        ),
                      ),
                      pw.SizedBox(height: 14),
                      pw.Container(
                        width: double.infinity,
                        padding: const pw.EdgeInsets.symmetric(horizontal: 10, vertical: 9),
                        decoration: pw.BoxDecoration(
                          color: const PdfColor(0.99, 0.99, 1),
                          border: pw.Border.all(color: PdfColors.blueGrey100, width: 0.8),
                          borderRadius: pw.BorderRadius.circular(5),
                        ),
                        child: pw.Column(
                          children: [
                            _buildInfoLine('Nom du carton', box.name),
                            _buildLineSeparator(),
                            _buildInfoLine('Piece', box.room.label),
                            _buildLineSeparator(),
                            _buildInfoLine('ID', shortId),
                            _buildLineSeparator(),
                            _buildInfoLine('Date', dateStr),
                            _buildLineSeparator(),
                            _buildInfoLine('Objets', '$itemCount', emphasizeValue: true),
                            if (box.fragile) ...[
                              pw.SizedBox(height: 6),
                              pw.Align(
                                alignment: pw.Alignment.centerLeft,
                                child: pw.Container(
                                  padding: const pw.EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                                  decoration: pw.BoxDecoration(
                                    color: const PdfColor(1, 0.95, 0.9),
                                    borderRadius: pw.BorderRadius.circular(10),
                                  ),
                                  child: pw.Text(
                                    '! FRAGILE',
                                    style: pw.TextStyle(
                                      fontSize: 8.5,
                                      fontWeight: pw.FontWeight.bold,
                                      color: PdfColors.orange800,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                      pw.SizedBox(height: 12),
                      pw.Text(
                        'MyINVENTORY - Carton de demenagement',
                        style: pw.TextStyle(fontSize: 8, color: PdfColors.grey600),
                      ),
                      pw.SizedBox(height: 2),
                      pw.Text(
                        'Scanner le QR pour identifier le carton',
                        style: pw.TextStyle(fontSize: 7.8, color: PdfColors.grey500),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          pw.Spacer(),
          pw.Align(
            alignment: pw.Alignment.centerRight,
            child: pw.Text(
              'Genere le $dateStr',
              style: pw.TextStyle(fontSize: 8, color: PdfColors.grey500),
            ),
          ),
        ],
      ),
    ),
  );

  return pdf.save();
}

pw.Widget _buildLineSeparator() {
  return pw.Padding(
    padding: const pw.EdgeInsets.symmetric(vertical: 3),
    child: pw.Divider(color: PdfColors.blueGrey100, thickness: 0.5),
  );
}

pw.Widget _buildInfoLine(String label, String value, {bool emphasizeValue = false}) {
  return pw.Row(
    crossAxisAlignment: pw.CrossAxisAlignment.start,
    children: [
      pw.SizedBox(
        width: 76,
        child: pw.Text(
          '$label:',
          style: pw.TextStyle(fontSize: 8.8, color: PdfColors.blueGrey600),
        ),
      ),
      pw.Expanded(
        child: pw.Text(
          value,
          textAlign: pw.TextAlign.right,
          style: pw.TextStyle(
            fontSize: 9,
            fontWeight: emphasizeValue ? pw.FontWeight.bold : pw.FontWeight.normal,
            color: emphasizeValue ? PdfColors.blueGrey900 : PdfColors.black,
          ),
          maxLines: 1,
          overflow: pw.TextOverflow.clip,
        ),
      ),
    ],
  );
}
