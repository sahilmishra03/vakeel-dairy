import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:provider/provider.dart';
import '../models/case_model.dart';
import '../providers/case_provider.dart';

/// Utility class for exporting case data to PDF
class CasePdfExportUtils {
  
  /// Export today's cases to PDF
  static Future<bool> exportTodayCases({
    required BuildContext context,
  }) async {
    try {
      final caseProvider = Provider.of<CaseProvider>(context, listen: false);
      final todayCases = caseProvider.todayHearings;
      
      if (todayCases.isEmpty) {
        _showEmptyDataDialog(context, 'No cases scheduled for today');
        return false;
      }

      return await _exportCasesToPdf(
        context: context,
        cases: todayCases,
        title: 'Today\'s Cases Report',
        fileName: 'today_cases_${_getDateString()}.pdf',
      );
    } catch (e) {
      _showErrorDialog(context, 'Failed to export today\'s cases: $e');
      return false;
    }
  }

  /// Export all cases to PDF
  static Future<bool> exportAllCases({
    required BuildContext context,
  }) async {
    try {
      final caseProvider = Provider.of<CaseProvider>(context, listen: false);
      final allCases = caseProvider.allCases;
      
      if (allCases.isEmpty) {
        _showEmptyDataDialog(context, 'No cases found in the database');
        return false;
      }

      return await _exportCasesToPdf(
        context: context,
        cases: allCases,
        title: 'All Cases Report',
        fileName: 'all_cases_${_getDateString()}.pdf',
      );
    } catch (e) {
      _showErrorDialog(context, 'Failed to export all cases: $e');
      return false;
    }
  }

  /// Internal method to export cases list to PDF
  static Future<bool> _exportCasesToPdf({
    required BuildContext context,
    required List<CaseModel> cases,
    required String title,
    required String fileName,
  }) async {
    // Show loading indicator
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const AlertDialog(
        content: Row(
          children: [
            CircularProgressIndicator(),
            SizedBox(width: 16),
            Text('Generating PDF...'),
          ],
        ),
      ),
    );

    try {
      // Generate PDF document
      final pdf = pw.Document();
      
      // Add a page to the PDF
      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4,
          margin: const pw.EdgeInsets.all(32),
          build: (pw.Context context) {
            return pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                // Title section
                pw.Container(
                  padding: const pw.EdgeInsets.only(bottom: 24),
                  child: pw.Text(
                    title,
                    style: pw.TextStyle(
                      fontSize: 24,
                      fontWeight: pw.FontWeight.bold,
                      color: PdfColors.black,
                    ),
                  ),
                ),
                
                // Summary section
                pw.Container(
                  padding: const pw.EdgeInsets.all(16),
                  decoration: pw.BoxDecoration(
                    color: PdfColors.grey100,
                    borderRadius: pw.BorderRadius.circular(8),
                  ),
                  child: pw.Row(
                    children: [
                      pw.Expanded(
                        child: pw.Text(
                          'Total Cases: ${cases.length}',
                          style: pw.TextStyle(
                            fontSize: 14,
                            fontWeight: pw.FontWeight.bold,
                            color: PdfColors.black,
                          ),
                        ),
                      ),
                      pw.Expanded(
                        child: pw.Text(
                          'Generated: ${DateTime.now().toString().substring(0, 19)}',
                          style: pw.TextStyle(
                            fontSize: 12,
                            color: PdfColors.grey700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                pw.SizedBox(height: 20),
                
                // Table header
                pw.Container(
                  padding: const pw.EdgeInsets.symmetric(vertical: 12),
                  decoration: pw.BoxDecoration(
                    border: pw.Border(bottom: pw.BorderSide(width: 2, color: PdfColors.grey800)),
                  ),
                  child: pw.Row(
                    children: [
                      pw.Expanded(flex: 1, child: _buildTableHeader('#')),
                      pw.Expanded(flex: 2, child: _buildTableHeader('Case No.')),
                      pw.Expanded(flex: 2, child: _buildTableHeader('Client')),
                      pw.Expanded(flex: 2, child: _buildTableHeader('Court')),
                      pw.Expanded(flex: 2, child: _buildTableHeader('Next Hearing')),
                      pw.Expanded(flex: 1, child: _buildTableHeader('Status')),
                    ],
                  ),
                ),
                
                // Table content
                for (int i = 0; i < cases.length; i++) ...[
                  pw.Container(
                    padding: const pw.EdgeInsets.symmetric(vertical: 8),
                    decoration: pw.BoxDecoration(
                      border: pw.Border(bottom: pw.BorderSide(width: 0.5, color: PdfColors.grey300)),
                    ),
                    child: pw.Row(
                      children: [
                        pw.Expanded(flex: 1, child: _buildTableCell('${i + 1}')),
                        pw.Expanded(flex: 2, child: _buildTableCell(cases[i].caseNumber)),
                        pw.Expanded(flex: 2, child: _buildTableCell(cases[i].clientName)),
                        pw.Expanded(flex: 2, child: _buildTableCell(cases[i].courtName)),
                        pw.Expanded(flex: 2, child: _buildTableCell(_formatDate(cases[i].nextHearing))),
                        pw.Expanded(flex: 1, child: _buildStatusCell(cases[i].status)),
                      ],
                    ),
                  ),
                ],
                
                // Footer
                pw.Spacer(),
                pw.Container(
                  padding: const pw.EdgeInsets.only(top: 24),
                  child: pw.Text(
                    'Vakeel Diary - Legal Case Management System',
                    style: pw.TextStyle(
                      fontSize: 10,
                      color: PdfColors.grey600,
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      );

      // Close loading dialog
      Navigator.of(context).pop();

      // Show sharing/printing dialog
      await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async => pdf.save(),
        name: fileName,
      );

      return true;
    } catch (e) {
      // Close loading dialog if it's still open
      if (context.mounted) {
        Navigator.of(context).pop();
      }
      rethrow;
    }
  }

  /// Build table header cell
  static pw.Widget _buildTableHeader(String text) {
    return pw.Text(
      text,
      style: pw.TextStyle(
        fontSize: 10,
        fontWeight: pw.FontWeight.bold,
        color: PdfColors.grey800,
      ),
    );
  }

  /// Build table cell
  static pw.Widget _buildTableCell(String text) {
    return pw.Text(
      text,
      style: const pw.TextStyle(
        fontSize: 9,
        color: PdfColors.black,
      ),
    );
  }

  /// Build status cell with color coding
  static pw.Widget _buildStatusCell(String status) {
    PdfColor statusColor;
    switch (status.toLowerCase()) {
      case 'active':
        statusColor = PdfColors.green;
        break;
      case 'closed':
        statusColor = PdfColors.red;
        break;
      default:
        statusColor = PdfColors.grey700;
    }
    
    return pw.Container(
      padding: const pw.EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: pw.BoxDecoration(
        color: statusColor,
        borderRadius: pw.BorderRadius.circular(4),
      ),
      child: pw.Text(
        status,
        style: pw.TextStyle(
          fontSize: 8,
          fontWeight: pw.FontWeight.bold,
          color: PdfColors.white,
        ),
      ),
    );
  }

  /// Format date string for display
  static String _formatDate(String dateString) {
    try {
      if (dateString.isEmpty) return 'N/A';
      final date = DateTime.parse(dateString);
      return '${date.day}/${date.month}/${date.year}';
    } catch (e) {
      return dateString;
    }
  }

  /// Get date string for filename
  static String _getDateString() {
    final now = DateTime.now();
    return '${now.day}${now.month}${now.year}';
  }

  /// Show empty data dialog
  static void _showEmptyDataDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('No Data'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  /// Show error dialog
  static void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Export Failed'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
