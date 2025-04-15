import 'package:file_saver/file_saver.dart';
import 'package:flutter/services.dart';
import 'package:jiffy/jiffy.dart';
import 'package:number_to_words_english/number_to_words_english.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:safmobile_portal/model/customer.dart';
import 'package:safmobile_portal/model/invoice.dart';
import 'package:safmobile_portal/model/payment_method.dart';
import 'package:safmobile_portal/model/technician.dart';

class PdfInvoice {
  static Future<Uint8List> generatePdf({
    required Customer customer,
    required Invoice invoice,
    required Technician technician,
    required List<InvoiceItem> invoiceItems,
  }) async {
    final pdf = pw.Document();
    final imgLogo = await rootBundle.load('assets/images/logo_light.png');
    final safmobileLogo = imgLogo.buffer.asUint8List();
    final calculatedInvoiceDuration = Jiffy.parseFromDateTime(invoice.dueDate.toDate()).from(Jiffy.parseFromDateTime(invoice.startDate.toDate()), withPrefixAndSuffix: false);
    final totalPriceInWord = NumberToWordsEnglish.convert(invoice.finalPrice.toInt()).toUpperCase();
    String warrantyDur(InvoiceItem item) {
      final String dur = Jiffy.parseFromDateTime(item.warrantyEnd!.toDate()).from(Jiffy.parseFromDateTime(item.warrantyStart!.toDate()), withPrefixAndSuffix: false);

      if (dur == '0 seconds') {
        return '--';
      }
      if (dur == 'a few seconds') {
        return '--';
      }

      return dur;
    }

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Image(
                        pw.MemoryImage(
                          safmobileLogo,
                        ),
                        width: 50,
                        height: 50,
                      ),
                      pw.SizedBox(height: 10),
                      pw.Text(
                        'Saf Mobile Express - Sungai Ramal Luar',
                        style: pw.TextStyle(
                          fontWeight: pw.FontWeight.bold,
                          // fontSize: 1,
                          // color: PdfColors.blue,
                        ),
                      ),
                      pw.SizedBox(height: 5),
                      pw.Text(
                        'Lot Pt.87977, Lorong 10,\nJln. Paya Putra, Kg. Sg. Ramal Luar, \n43000 Kajang, Selangor',
                        style: const pw.TextStyle(
                          fontSize: 11,
                        ),
                      ),
                      pw.SizedBox(height: 5),
                      pw.Text(
                        'Technician: ${technician.name}',
                        style: const pw.TextStyle(
                          fontSize: 11,
                        ),
                      ),
                      pw.Text(
                        'Contact: 011-1142 6421',
                        style: const pw.TextStyle(
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.end,
                    children: [
                      pw.Text(
                        invoice.isPay == true ? 'RECEIPT' : 'INVOICE',
                        style: pw.TextStyle(
                          fontSize: 17,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                      pw.RichText(
                        text: pw.TextSpan(
                          text: '',
                          style: const pw.TextStyle(
                            fontSize: 11,
                          ),
                          children: [
                            pw.TextSpan(
                              text: '#${invoice.id}',
                              style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                      pw.RichText(
                        text: pw.TextSpan(
                          text: 'Date: ',
                          style: const pw.TextStyle(
                            fontSize: 11,
                          ),
                          children: [
                            pw.TextSpan(
                              text: Jiffy.parseFromDateTime(invoice.startDate.toDate()).format(pattern: 'dd/MM/yyyy'),
                              style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                      pw.SizedBox(height: 10),
                      pw.SizedBox(
                        height: 60,
                        width: 60,
                        child: pw.BarcodeWidget(
                          data: 'portal.safmobile.my/#/docs/${customer.uid}/${invoice.id.toString()}',
                          barcode: pw.Barcode.qrCode(),
                        ),
                      ),
                      pw.SizedBox(height: 5),
                      pw.Text(
                        invoice.isPay == true ? 'Scan Here To\nDownload Your Receipt' : 'Scan Here For\nFast & Easy Payment',
                        textAlign: pw.TextAlign.end,
                        style: const pw.TextStyle(
                          fontSize: 10,
                        ),
                      ),
                      pw.SizedBox(height: 10),
                    ],
                  ),
                ],
              ),
              pw.SizedBox(height: 20),
              pw.Table(
                border: pw.TableBorder.all(color: PdfColors.blue200),
                children: [
                  pw.TableRow(
                    decoration: const pw.BoxDecoration(color: PdfColors.blue200),
                    children: [
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(8),
                        child: pw.Text(
                          'Customer Contact Information',
                          style: pw.TextStyle(
                            fontWeight: pw.FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              pw.SizedBox(height: 10),
              pw.RichText(
                text: pw.TextSpan(
                  text: 'Name: ',
                  children: [
                    pw.TextSpan(
                      text: customer.name,
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                    ),
                  ],
                ),
              ),
              pw.SizedBox(height: 5),
              pw.RichText(
                text: pw.TextSpan(
                  text: 'Phone Number: ',
                  children: [
                    pw.TextSpan(
                      text: customer.phoneNumber,
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                    ),
                  ],
                ),
              ),
              pw.SizedBox(height: 5),
              pw.RichText(
                text: pw.TextSpan(
                  text: 'Email: ',
                  children: [
                    pw.TextSpan(
                      text: customer.email.contains(customer.phoneNumber) ? '-' : customer.email,
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                    ),
                  ],
                ),
              ),
              pw.SizedBox(height: 5),
              invoice.isPay == false
                  ? pw.SizedBox()
                  : pw.RichText(
                      text: pw.TextSpan(
                        text: 'Payment Method: ',
                        children: [
                          pw.TextSpan(
                            text: invoice.paymentMethod.displayName,
                            style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
              pw.SizedBox(height: 15),
              pw.Table(
                border: pw.TableBorder.all(color: PdfColors.blue200),
                children: [
                  pw.TableRow(
                    decoration: const pw.BoxDecoration(color: PdfColors.blue200),
                    children: [
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(8),
                        child: pw.Text(
                          'Items Description',
                          style: pw.TextStyle(
                            fontWeight: pw.FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              pw.SizedBox(height: 20),
              pw.Table(
                columnWidths: const {
                  0: pw.FractionColumnWidth(.5),
                  1: pw.FractionColumnWidth(.27),
                },
                border: pw.TableBorder.all(
                  width: 1,
                  style: pw.BorderStyle.solid,
                ),
                children: [
                  pw.TableRow(
                    decoration: const pw.BoxDecoration(
                      color: PdfColors.blue100,
                      // borderRadius: pw.BorderRadius.circular(15),
                    ),
                    children: [
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(12.0),
                        child: pw.Text(
                          'Item',
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                        ),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(12.0),
                        child: pw.Text(
                          'Warranty',
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                        ),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(12.0),
                        child: pw.Text(
                          'Price (RM)',
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  ...invoiceItems.map((item) {
                    return pw.TableRow(
                      children: [
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(12.0),
                          child: pw.Text(
                            item.itemName,
                          ),
                        ),
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(12.0),
                          child: pw.Text(warrantyDur(item)
                              // style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                        ),
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(12.0),
                          child: pw.Text(
                            item.itemPrice.toStringAsFixed(2),
                            // style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    );
                  }),
                  pw.TableRow(
                    // decoration: const pw.BoxDecoration(
                    //   color: PdfColors.blue100,
                    //   // borderRadius: pw.BorderRadius.circular(15),
                    // ),
                    children: [
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(12.0),
                        child: pw.Text(
                          'Total',
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                        ),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(12.0),
                        child: pw.Text(
                          '--',
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                        ),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(12.0),
                        child: pw.Text(
                          'RM ${invoice.finalPrice.toStringAsFixed(2)}',
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              pw.SizedBox(height: 10),
              pw.Align(
                alignment: pw.Alignment.centerRight,
                child: pw.Text('$totalPriceInWord RINGGIT MALAYSIA ONLY', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
              ),
              pw.SizedBox(height: 20),
              pw.Table(
                border: pw.TableBorder.all(color: PdfColors.blue200),
                children: [
                  pw.TableRow(
                    decoration: const pw.BoxDecoration(color: PdfColors.blue200),
                    children: [
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(8),
                        child: pw.Text(
                          'Notes',
                          style: pw.TextStyle(
                            fontWeight: pw.FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              pw.SizedBox(height: 10),
              invoice.isPay == true
                  ? pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text(
                          '1. This is an official receipt for the payment made; please keep this receipt for warranty purposes.',
                          style: const pw.TextStyle(
                            fontSize: 11,
                          ),
                        ),
                        pw.Text(
                          '2. Physical or water damage is not covered under warranty.',
                          style: const pw.TextStyle(fontSize: 11),
                        ),
                        pw.Text(
                          '3. Warranty is void if the device is tampered with by unauthorized personnel.',
                          style: const pw.TextStyle(fontSize: 11),
                        ),
                        pw.Text(
                          '4. Refunds are not applicable for services rendered.',
                          style: const pw.TextStyle(
                            fontSize: 11,
                          ),
                        ),
                        pw.Text(
                          '5. For any inquiries, visit our website or contact us at 011-1142 6421',
                          style: const pw.TextStyle(fontSize: 11),
                        ),
                      ],
                    )
                  : pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text(
                          '1. Payment must be made within $calculatedInvoiceDuration after the invoice is issued.',
                          style: const pw.TextStyle(
                            fontSize: 11,
                          ),
                        ),
                        pw.Text(
                          '2. Payment also can be made via online transfer to the following account:',
                          style: const pw.TextStyle(
                            fontSize: 11,
                          ),
                        ),
                        pw.SizedBox(height: 5),
                        pw.Text(
                          '   Assaff Enterprise',
                          style: pw.TextStyle(
                            fontSize: 11,
                            fontWeight: pw.FontWeight.bold,
                          ),
                        ),
                        pw.Text(
                          '   5620 2165 1202',
                          style: pw.TextStyle(
                            fontSize: 11,
                            fontWeight: pw.FontWeight.bold,
                          ),
                        ),
                        pw.Text(
                          '   Maybank Berhad',
                          style: pw.TextStyle(
                            fontSize: 11,
                            fontWeight: pw.FontWeight.bold,
                          ),
                        ),
                        pw.SizedBox(height: 5),
                        pw.Text(
                          '3. Please send the payment receipt to our WhatsApp number or email at safmobile@gmail.com',
                          style: const pw.TextStyle(
                            fontSize: 11,
                          ),
                        ),
                        pw.Text(
                          '4. For any inquiries, please contact us at 011-1142 6421',
                          style: const pw.TextStyle(
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
            ],
          );
        },
      ),
    );
    return pdf.save();
  }

  static savePDF(Uint8List pdfFile, bool isPay, String ticketId) async {
    await FileSaver.instance.saveFile(
      name: isPay == false ? 'Invoice#$ticketId.pdf' : 'Receipt#$ticketId.pdf',
      bytes: pdfFile,
      mimeType: MimeType.pdf,
    );
  }
}
