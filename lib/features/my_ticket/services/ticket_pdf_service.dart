import 'dart:io';
import 'dart:typed_data';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:dio/dio.dart';
import '../../../networks/dio/dio.dart';
import '../model/my_orders_response_model.dart';

class TicketPdfService {
  TicketPdfService._();

  static String _formatDateTime(DateTime? dateTime) {
    if (dateTime == null) return 'N/A';
    try {
      return DateFormat("dd MMM yyyy – hh:mm a").format(dateTime.toLocal());
    } catch (_) {
      return dateTime.toString();
    }
  }

  static Future<Uint8List?> _fetchQrImageBytes(String? url) async {
    if (url == null || url.isEmpty || !url.startsWith('http')) {
      return null;
    }
    try {
      final response = await DioSingleton.instance.dio.get<List<int>>(
        url,
        options: Options(
          responseType: ResponseType.bytes,
          receiveTimeout: const Duration(seconds: 10),
        ),
      );
      if (response.data != null && response.data!.isNotEmpty) {
        return Uint8List.fromList(response.data!);
      }
    } catch (_) {}
    return null;
  }

  static Future<Uint8List> generateTicketPdf(MyOrderData order) async {
    final pdf = pw.Document();

    final qrBytes = await _fetchQrImageBytes(order.qrCode);
    final eventName = order.eventId?.title ?? 'Event';
    final location = order.eventId?.placeName ?? 'Location not specified';
    final dateTime = _formatDateTime(order.eventId?.startDate);
    final organizer = order.hostId?.businessProfile?.businessName ??
        order.hostId?.name ??
        "Event Organizer";
    final ticketId = order.ticketId ?? order.id ?? "N/A";
    final orderId = order.id ?? "N/A";
    final totalAmount = order.totalAmount != null
        ? '\$${order.totalAmount!.toStringAsFixed(2)}'
        : '\$0.00';
    final totalTickets = order.totalTicketQuantity?.toString() ?? '1';
    final status = order.status ?? 'CONFIRMED';

    final primaryOrange = PdfColor.fromHex('#F28F31');
    final darkCard = PdfColor.fromHex('#1A1D24');
    final darkCardLighter = PdfColor.fromHex('#232730');
    final textColorWhite = PdfColors.white;
    final textMuted = PdfColor.fromHex('#9E9E9E');

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        build: (pw.Context context) {
          return pw.Container(
            decoration: pw.BoxDecoration(
              color: darkCard,
              borderRadius: pw.BorderRadius.circular(16),
            ),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.stretch,
              children: [
                // Top Header Banner
                pw.Container(
                  padding: const pw.EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 20,
                  ),
                  decoration: pw.BoxDecoration(
                    color: darkCardLighter,
                    borderRadius: const pw.BorderRadius.only(
                      topLeft: pw.Radius.circular(16),
                      topRight: pw.Radius.circular(16),
                    ),
                  ),
                  child: pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Text(
                            "TEAMSTREAK PROMO",
                            style: pw.TextStyle(
                              color: primaryOrange,
                              fontSize: 12,
                              fontWeight: pw.FontWeight.bold,
                              letterSpacing: 1.5,
                            ),
                          ),
                          pw.SizedBox(height: 4),
                          pw.Text(
                            "EVENT ADMISSION TICKET",
                            style: pw.TextStyle(
                              color: textColorWhite,
                              fontSize: 16,
                              fontWeight: pw.FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      pw.Container(
                        padding: const pw.EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: pw.BoxDecoration(
                          color: status == 'CANCELLED'
                              ? PdfColors.red800
                              : primaryOrange,
                          borderRadius: pw.BorderRadius.circular(20),
                        ),
                        child: pw.Text(
                          status.toUpperCase(),
                          style: pw.TextStyle(
                            color: PdfColors.white,
                            fontSize: 11,
                            fontWeight: pw.FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Main Ticket Body
                pw.Padding(
                  padding: const pw.EdgeInsets.all(24),
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      // Event Title
                      pw.Text(
                        eventName,
                        style: pw.TextStyle(
                          color: textColorWhite,
                          fontSize: 22,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                      pw.SizedBox(height: 18),

                      // QR Code Section
                      pw.Center(
                        child: pw.Container(
                          padding: const pw.EdgeInsets.all(12),
                          decoration: pw.BoxDecoration(
                            color: PdfColors.white,
                            borderRadius: pw.BorderRadius.circular(12),
                          ),
                          child: qrBytes != null
                              ? pw.Image(
                                  pw.MemoryImage(qrBytes),
                                  width: 130,
                                  height: 130,
                                  fit: pw.BoxFit.contain,
                                )
                              : pw.BarcodeWidget(
                                  barcode: pw.Barcode.qrCode(),
                                  data: order.ticketId ?? order.id ?? "TICKET",
                                  width: 130,
                                  height: 130,
                                ),
                        ),
                      ),
                      pw.SizedBox(height: 8),
                      pw.Center(
                        child: pw.Text(
                          "Scan QR code at entry",
                          style: pw.TextStyle(
                            color: textMuted,
                            fontSize: 10,
                          ),
                        ),
                      ),
                      pw.SizedBox(height: 20),

                      // Dashed Divider
                      pw.Container(
                        height: 1,
                        child: pw.CustomPaint(
                          painter: (PdfGraphics canvas, PdfPoint size) {
                            canvas.setStrokeColor(PdfColor.fromHex('#3A3F4B'));
                            canvas.setLineWidth(1);
                            double x = 0;
                            while (x < size.x) {
                              canvas.drawLine(x, 0, x + 5, 0);
                              x += 9;
                            }
                            canvas.strokePath();
                          },
                        ),
                      ),
                      pw.SizedBox(height: 18),

                      // Key Ticket Details Grid
                      pw.Row(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Expanded(
                            child: _buildInfoItem(
                              title: "EVENT LOCATION",
                              value: location,
                              textColor: textColorWhite,
                              mutedColor: textMuted,
                            ),
                          ),
                          pw.SizedBox(width: 16),
                          pw.Expanded(
                            child: _buildInfoItem(
                              title: "DATE & TIME",
                              value: dateTime,
                              textColor: textColorWhite,
                              mutedColor: textMuted,
                            ),
                          ),
                        ],
                      ),
                      pw.SizedBox(height: 14),

                      pw.Row(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Expanded(
                            child: _buildInfoItem(
                              title: "EVENT ORGANIZER",
                              value: organizer,
                              textColor: textColorWhite,
                              mutedColor: textMuted,
                            ),
                          ),
                          pw.SizedBox(width: 16),
                          pw.Expanded(
                            child: _buildInfoItem(
                              title: "TICKET ID",
                              value: ticketId,
                              textColor: textColorWhite,
                              mutedColor: textMuted,
                            ),
                          ),
                        ],
                      ),
                      pw.SizedBox(height: 14),

                      pw.Row(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Expanded(
                            child: _buildInfoItem(
                              title: "ORDER ID",
                              value: orderId,
                              textColor: textColorWhite,
                              mutedColor: textMuted,
                            ),
                          ),
                          pw.SizedBox(width: 16),
                          pw.Expanded(
                            child: _buildInfoItem(
                              title: "TICKETS COUNT",
                              value: "$totalTickets ticket(s)",
                              textColor: textColorWhite,
                              mutedColor: textMuted,
                            ),
                          ),
                        ],
                      ),

                      // Ticket Items Table (if available)
                      if (order.tickets != null && order.tickets!.isNotEmpty) ...[
                        pw.SizedBox(height: 18),
                        pw.Container(
                          padding: const pw.EdgeInsets.all(12),
                          decoration: pw.BoxDecoration(
                            color: darkCardLighter,
                            borderRadius: pw.BorderRadius.circular(8),
                          ),
                          child: pw.Column(
                            children: [
                              pw.Row(
                                mainAxisAlignment:
                                    pw.MainAxisAlignment.spaceBetween,
                                children: [
                                  pw.Text(
                                    "Ticket Type",
                                    style: pw.TextStyle(
                                      color: textMuted,
                                      fontSize: 10,
                                      fontWeight: pw.FontWeight.bold,
                                    ),
                                  ),
                                  pw.Text(
                                    "Qty",
                                    style: pw.TextStyle(
                                      color: textMuted,
                                      fontSize: 10,
                                      fontWeight: pw.FontWeight.bold,
                                    ),
                                  ),
                                  pw.Text(
                                    "Price",
                                    style: pw.TextStyle(
                                      color: textMuted,
                                      fontSize: 10,
                                      fontWeight: pw.FontWeight.bold,
                                    ),
                                  ),
                                  pw.Text(
                                    "Subtotal",
                                    style: pw.TextStyle(
                                      color: textMuted,
                                      fontSize: 10,
                                      fontWeight: pw.FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              pw.Divider(
                                color: PdfColor.fromHex('#3A3F4B'),
                                height: 12,
                              ),
                              ...order.tickets!.map(
                                (ticket) {
                                  final subtotal = (ticket.unitPrice ?? 0) *
                                      (ticket.quantity ?? 1);
                                  return pw.Padding(
                                    padding: const pw.EdgeInsets.symmetric(
                                        vertical: 2),
                                    child: pw.Row(
                                      mainAxisAlignment:
                                          pw.MainAxisAlignment.spaceBetween,
                                      children: [
                                        pw.Text(
                                          ticket.categoryName ?? 'General',
                                          style: pw.TextStyle(
                                            color: textColorWhite,
                                            fontSize: 10,
                                          ),
                                        ),
                                        pw.Text(
                                          'x${ticket.quantity ?? 1}',
                                          style: pw.TextStyle(
                                            color: textColorWhite,
                                            fontSize: 10,
                                          ),
                                        ),
                                        pw.Text(
                                          '\$${(ticket.unitPrice ?? 0).toStringAsFixed(2)}',
                                          style: pw.TextStyle(
                                            color: textColorWhite,
                                            fontSize: 10,
                                          ),
                                        ),
                                        pw.Text(
                                          '\$${subtotal.toStringAsFixed(2)}',
                                          style: pw.TextStyle(
                                            color: primaryOrange,
                                            fontSize: 10,
                                            fontWeight: pw.FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ],

                      pw.SizedBox(height: 18),
                      // Total Amount Paid Banner
                      pw.Container(
                        padding: const pw.EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        decoration: pw.BoxDecoration(
                          color: darkCardLighter,
                          borderRadius: pw.BorderRadius.circular(8),
                          border: pw.Border.all(
                            color: primaryOrange,
                            width: 1,
                          ),
                        ),
                        child: pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                          children: [
                            pw.Text(
                              "TOTAL PAID",
                              style: pw.TextStyle(
                                color: textColorWhite,
                                fontSize: 13,
                                fontWeight: pw.FontWeight.bold,
                              ),
                            ),
                            pw.Text(
                              totalAmount,
                              style: pw.TextStyle(
                                color: primaryOrange,
                                fontSize: 16,
                                fontWeight: pw.FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // Footer Notice
                pw.Container(
                  padding: const pw.EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 14,
                  ),
                  decoration: pw.BoxDecoration(
                    color: darkCardLighter,
                    borderRadius: const pw.BorderRadius.only(
                      bottomLeft: pw.Radius.circular(16),
                      bottomRight: pw.Radius.circular(16),
                    ),
                  ),
                  child: pw.Center(
                    child: pw.Text(
                      "Please present this valid ticket or QR code at event entry. Generated by TeamStreak Promo.",
                      style: pw.TextStyle(
                        color: textMuted,
                        fontSize: 9,
                      ),
                      textAlign: pw.TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );

    return pdf.save();
  }

  static pw.Widget _buildInfoItem({
    required String title,
    required String value,
    required PdfColor textColor,
    required PdfColor mutedColor,
  }) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          title,
          style: pw.TextStyle(
            color: mutedColor,
            fontSize: 9,
            fontWeight: pw.FontWeight.bold,
          ),
        ),
        pw.SizedBox(height: 3),
        pw.Text(
          value,
          style: pw.TextStyle(
            color: textColor,
            fontSize: 12,
            fontWeight: pw.FontWeight.bold,
          ),
          maxLines: 2,
        ),
      ],
    );
  }

  static Future<File> saveToDownloads({
    required Uint8List bytes,
    required String fileName,
  }) async {
    Directory? targetDir;

    if (Platform.isAndroid) {
      try {
        final publicDownload = Directory('/storage/emulated/0/Download');
        if (await publicDownload.exists()) {
          final file = File('${publicDownload.path}/$fileName');
          await file.writeAsBytes(bytes);
          return file;
        }
      } catch (_) {}

      try {
        final extDir = await getExternalStorageDirectory();
        if (extDir != null) {
          final file = File('${extDir.path}/$fileName');
          await file.writeAsBytes(bytes);
          return file;
        }
      } catch (_) {}
    } else if (Platform.isIOS) {
      targetDir = await getApplicationDocumentsDirectory();
    } else {
      try {
        targetDir = await getDownloadsDirectory();
      } catch (_) {}
    }

    targetDir ??= await getApplicationDocumentsDirectory();

    final filePath = '${targetDir.path}/$fileName';
    final file = File(filePath);
    await file.writeAsBytes(bytes);
    return file;
  }
}
