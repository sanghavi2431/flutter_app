import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:share_plus/share_plus.dart';
import 'package:woloo_smart_hygiene/screens/attendance_history_screen/data/model/attendance_history_model.dart';

class AttendanceHistoryPdfBuilder {
  static Future<void> generateAndShare({
    required List<AttendanceHistoryModel> attendance,
    String? monthLabel,
    String? janitorName,
  }) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        build: (context) {
          return [
            pw.Center(
              child: pw.Text(
                'Janitor Attendance History',
                style: pw.TextStyle(
                  fontSize: 22,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
            ),
            if (janitorName != null && janitorName.isNotEmpty) ...[
              pw.SizedBox(height: 4),
              pw.Center(
                child: pw.Text(
                  'Janitor: $janitorName',
                  style: const pw.TextStyle(fontSize: 14),
                ),
              ),
            ],
            if (monthLabel != null) ...[
              pw.SizedBox(height: 4),
              pw.Center(
                child: pw.Text(
                  monthLabel,
                  style: const pw.TextStyle(fontSize: 12),
                ),
              ),
            ],
            pw.SizedBox(height: 16),
            pw.Table(
              border: pw.TableBorder.all(width: 0.8),
              columnWidths: const {
                0: pw.FlexColumnWidth(1),
                1: pw.FlexColumnWidth(1.5),
                2: pw.FlexColumnWidth(2),
                3: pw.FlexColumnWidth(2),
                4: pw.FlexColumnWidth(2),
              },
              children: [
                pw.TableRow(
                  decoration:
                      const pw.BoxDecoration(color: PdfColors.grey300),
                  children: _buildHeaderRow(),
                ),
                if (attendance.isEmpty)
                  pw.TableRow(
                    children: [
                      _buildCell('No data', colspan: 5),
                    ],
                  )
                else
                  ...attendance.map(
                    (item) => pw.TableRow(
                      children: [
                        _buildCell(item.date ?? '-'),
                        _buildCell(item.dayOfWeek ?? '-'),
                        _buildCell(item.checkIn ?? '-'),
                        _buildCell(item.checkOut ?? '-'),
                        _buildStatusCell(item.attendance ?? '-'),
                      ],
                    ),
                  ),
              ],
            ),
          ];
        },
      ),
    );

    final directory = await getTemporaryDirectory();
    final file = File(
      '${directory.path}/attendance_history_${DateTime.now().millisecondsSinceEpoch}.pdf',
    );

    await file.writeAsBytes(await pdf.save());

    await Share.shareXFiles(
      [XFile(file.path)],
      text: 'Janitor Attendance History',
    );
  }

  static List<pw.Widget> _buildHeaderRow() {
    const headers = ['Date', 'Day', 'Check-in', 'Check-out', 'Status'];
    return headers
        .map(
          (h) => pw.Padding(
            padding: const pw.EdgeInsets.all(6),
            child: pw.Text(
              h,
              style: pw.TextStyle(
                fontSize: 10,
                fontWeight: pw.FontWeight.bold,
              ),
            ),
          ),
        )
        .toList();
  }

  static pw.Widget _buildCell(
    String text, {
    int colspan = 1,
  }) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(6),
      alignment: pw.Alignment.centerLeft,
      child: pw.Text(
        text,
        style: const pw.TextStyle(fontSize: 9),
      ),
    );
  }

  static pw.Widget _buildStatusCell(String status) {
    final lower = status.toLowerCase();
    PdfColor bg;
    PdfColor textColor;

    if (lower.contains('present')) {
      bg = PdfColor.fromHex('#E0F2F1');
      textColor = PdfColor.fromHex('#00796B');
    } else if (lower.contains('absent')) {
      bg = PdfColor.fromHex('#FFEBEE');
      textColor = PdfColor.fromHex('#C62828');
    } else {
      bg = PdfColors.grey200;
      textColor = PdfColors.black;
    }

    return pw.Container(
      padding: const pw.EdgeInsets.symmetric(vertical: 4, horizontal: 6),
      alignment: pw.Alignment.center,
      decoration: pw.BoxDecoration(
        color: bg,
        borderRadius: pw.BorderRadius.circular(4),
      ),
      child: pw.Text(
        status,
        style: pw.TextStyle(
          fontSize: 9,
          fontWeight: pw.FontWeight.bold,
          color: textColor,
        ),
      ),
    );
  }
}

