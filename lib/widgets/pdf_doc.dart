import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';
import 'package:flutter/services.dart' show rootBundle;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf_generator/generated/assets.dart';
import 'package:pdf_generator/shared/data.dart';
import 'package:printing/printing.dart';

Future<Uint8List> generatePdfDoc(PdfPageFormat pageFormat, CustomData data) async {
  final invoice = PdfDoc(
    baseColor: PdfColors.teal,
    accentColor: PdfColors.blueGrey900,
  );

  return await invoice.buildPdf(pageFormat);
}

class PdfDoc {
  PdfDoc({
    required this.baseColor,
    required this.accentColor,
  });

  final PdfColor baseColor;
  final PdfColor accentColor;

  String? _logo;
  ByteData? checkImg;

  Future<Uint8List> buildPdf(PdfPageFormat pageFormat) async {
    // Create a PDF document.
    final doc = pw.Document();

    _logo = await rootBundle.loadString('assets/logo.svg');
    checkImg = await rootBundle.load('assets/check.png');

    // Add page to the PDF
    doc.addPage(
      pw.MultiPage(
        pageTheme: _buildTheme(
          pageFormat,
          await PdfGoogleFonts.robotoRegular(),
          await PdfGoogleFonts.robotoBold(),
          await PdfGoogleFonts.robotoItalic(),
          await PdfGoogleFonts.materialIcons(),
        ),
        build: (context) => [
          _contentLogoRow(context),
          pw.SizedBox(height: 20),
          _contentTable(context),
          pw.SizedBox(height: 20),
          _contentTableWithCheckBox(context),
        ],
      ),
    );
    // Return the PDF file content
    return doc.save();
  }

  pw.PageTheme _buildTheme(PdfPageFormat pageFormat, pw.Font base, pw.Font bold, pw.Font italic, pw.Font material) {
    return pw.PageTheme(
      pageFormat: pageFormat,
      theme: pw.ThemeData.withFont(
        base: base,
        bold: bold,
        italic: italic,
        icons: material,
      ),
    );
  }

  pw.Widget _contentLogoRow(pw.Context context) {
    return pw.Container(
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.blueGrey200),
      ),
      child: pw.Row(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
        pw.Container(
          padding: const pw.EdgeInsets.symmetric(vertical: 20, horizontal: 10),
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Container(
                alignment: pw.Alignment.topLeft,
                height: 32,
                child: _logo != null ? pw.SvgImage(svg: _logo!) : pw.PdfLogo(),
              ),
              pw.SizedBox(height: 10),
              pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text('Name: John Deo', style: const pw.TextStyle(fontSize: 12)),
                    pw.SizedBox(height: 5),
                    pw.Text('Email: test@email.com'),
                  ],
                ),
                pw.SizedBox(width: 20),
                pw.Container(alignment: pw.Alignment.topLeft, height: 30, width: 30, color: PdfColors.blueGrey200),
              ])
            ],
          ),
        ),
        pw.Container(
          padding: const pw.EdgeInsets.symmetric(vertical: 20, horizontal: 10),
          margin: const pw.EdgeInsets.only(left: 20),
          decoration: const pw.BoxDecoration(border: pw.Border(left: pw.BorderSide(color: PdfColors.blueGrey200))),
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                'FLHA v2',
                style: pw.TextStyle(
                  fontSize: 22,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 10),
              pw.Text('Date: 04 Jan 2023', style: const pw.TextStyle(fontSize: 12)),
              pw.SizedBox(height: 5),
              pw.Text('Submit: 04 Jan 2023'),
            ],
          ),
        ),
      ]),
    );
  }

  pw.Widget _contentTable(pw.Context context) {
    return pw.Container(
      decoration: pw.BoxDecoration(border: pw.Border.all(color: PdfColors.blueGrey200)),
      child: pw.Column(
        children: [
          pw.Row(children: [
            pw.Padding(
              padding: const pw.EdgeInsets.all(10),
              child: pw.Text('Step 1'),
            ),
          ]),
          pw.Table(
            border: pw.TableBorder.all(color: PdfColors.blueGrey200),
            children: [
              pw.TableRow(
                children: [
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(10),
                    child: pw.Text('Date'),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(10),
                    child: pw.Text('07:40 AM, 04 Jan 2023'),
                  ),
                ],
              ),
              pw.TableRow(
                children: [
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(10),
                    child: pw.Text('Date'),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(10),
                    child: pw.Text('07:40 AM, 04 Jan 2023'),
                  ),
                ],
              ),
              pw.TableRow(
                children: [
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(10),
                    child: pw.Text('EMP'),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(10),
                    child: pw.Text('112'),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  pw.Widget _contentTableWithCheckBox(pw.Context context) {
    return pw.Container(
      decoration: pw.BoxDecoration(border: pw.Border.all(color: PdfColors.blueGrey200)),
      child: pw.Column(
        children: [
          pw.Row(children: [
            pw.Padding(
              padding: const pw.EdgeInsets.all(10),
              child: pw.Text('Step 2'),
            ),
          ]),
          pw.Table(
            border: pw.TableBorder.all(color: PdfColors.blueGrey200),
            children: [
              pw.TableRow(

                children: [
                  pw.Container(
                    width: 200,
                    child: pw.Padding(
                      padding: const pw.EdgeInsets.all(10),
                      child: pw.Text('Life Saving Rules'),
                    ),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(10),
                    child: pw.Wrap(
                      runSpacing: 10,
                      spacing: 10,
                      children: [
                        pw.Wrap(
                          crossAxisAlignment: pw.WrapCrossAlignment.center,
                          children: [
                            pw.Container(
                              padding: pw.EdgeInsets.all(7),
                              decoration: pw.BoxDecoration(
                                  borderRadius: pw.BorderRadius.circular(10),
                                  color: PdfColors.blue900
                              ),
                              child: pw.Image(
                                height: 15,
                                pw.MemoryImage(checkImg!.buffer.asUint8List()),
                              ),
                            ),
                            pw.SizedBox(width: 10),
                            pw.Flexible(
                              child: pw.Text('Confined Space')
                            ),
                          ]
                        ),
                        pw.Wrap(
                            crossAxisAlignment: pw.WrapCrossAlignment.center,
                            children: [
                              pw.Container(
                                padding: pw.EdgeInsets.all(7),
                                decoration: pw.BoxDecoration(
                                    borderRadius: pw.BorderRadius.circular(10),
                                    color: PdfColors.blue900
                                ),
                                child: pw.Image(
                                  height: 15,
                                  pw.MemoryImage(checkImg!.buffer.asUint8List()),
                                ),
                              ),
                              pw.SizedBox(width: 10),
                              pw.Flexible(
                                  child: pw.Text('Confined Space')
                              ),
                            ]
                        ),
                        pw.Wrap(
                            crossAxisAlignment: pw.WrapCrossAlignment.center,
                            children: [
                              pw.Container(
                                padding: pw.EdgeInsets.all(7),
                                decoration: pw.BoxDecoration(
                                    borderRadius: pw.BorderRadius.circular(10),
                                    color: PdfColors.blue900
                                ),
                                child: pw.Image(
                                  height: 15,
                                  pw.MemoryImage(checkImg!.buffer.asUint8List()),
                                ),
                              ),
                              pw.SizedBox(width: 10),
                              pw.Flexible(
                                  child: pw.Text('Confined Space')
                              ),
                            ]
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
