import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:tubes_5_c_travel/common/models/User.dart';
import 'dart:typed_data';

import 'package:tubes_5_c_travel/common/models/pemesanan.dart';
import 'package:tubes_5_c_travel/home/screens/profile_screen.dart';

class PdfPreviewPage extends ConsumerWidget {
  final Pemesanan pemesanan;
  const PdfPreviewPage({super.key, required this.pemesanan});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Preview PDF')),
      body: PdfPreview(
        build: (format) => _generatePdf(format, ref),
      ),
    );
  }

  Future<Uint8List> _generatePdf(PdfPageFormat format, WidgetRef ref) async {
    final pdf = pw.Document();
    final userListener = ref.watch(userProvider);
    String biayaReguler = '';
    String totalBiayaReguler = '';
    String biayaVIP = '';
    String totalBiayaVIP = '';

    if (pemesanan.jumlahTiketReguler > 0) {
      biayaReguler = NumberFormat.currency(
        locale: 'id_ID',
        symbol: 'Rp',
        decimalDigits: 0,
      ).format(pemesanan.hargaTiketReguler);
      totalBiayaReguler = NumberFormat.currency(
        locale: 'id_ID',
        symbol: 'Rp',
        decimalDigits: 0,
      ).format(pemesanan.totalBiayaReguler);
    }
    if (pemesanan.jumlahTiketVIP > 0) {
      biayaVIP = NumberFormat.currency(
        locale: 'id_ID',
        symbol: 'Rp',
        decimalDigits: 0,
      ).format(pemesanan.hargaTiketVIP);
      totalBiayaVIP = NumberFormat.currency(
        locale: 'id_ID',
        symbol: 'Rp',
        decimalDigits: 0,
      ).format(pemesanan.totalBiayaVIP);
    }

    String biayaAdmin = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp',
      decimalDigits: 0,
    ).format(pemesanan.totalBiaya * 0.1);
    String biayaAkhir = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp',
      decimalDigits: 0,
    ).format(pemesanan.totalBiaya * 1.1);

    pdf.addPage(
      pw.Page(
        pageFormat: format,
        build: (context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                'ATMA TRAVEL',
                style:
                    pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold),
              ),
              pw.SizedBox(height: 16),
              pw.Text(
                'BUKTI PEMBELIAN (RECEIPT)',
                style:
                    pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold),
              ),
              pw.SizedBox(height: 8),
              pw.Text('ID Transaksi: ${pemesanan.id}'),
              pw.Text('Tanggal: ${pemesanan.tanggalPemesanan}'),
              pw.Divider(),
              pw.SizedBox(height: 8),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text('DATA PEMESAN:'),
                      pw.Text('Nama: ${userListener.when(
                        data: (user) {
                          return user.username;
                        },
                        error: (err, s) => true,
                        loading: () => true,
                      )}'),
                      pw.Text('Email: ${userListener.when(
                        data: (user) {
                          return user.email;
                        },
                        error: (err, s) => true,
                        loading: () => true,
                      )}'),
                      // pw.Text('ID User: ${pemesanan.idUser}'),
                      pw.Text('Jumlah Tiket: ${pemesanan.jumlahTiket}'),
                    ],
                  ),
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text('DATA PERUSAHAAN:'),
                      pw.Text('Nama: Atma Travel'),
                      pw.Text('Alamat: Jl. Babarsari No.43'),
                      pw.Text('Telepon: (0274) 487711'),
                    ],
                  ),
                ],
              ),
              pw.SizedBox(height: 16),
              pw.Table(
                border: pw.TableBorder.all(),
                children: [
                  pw.TableRow(
                    decoration: pw.BoxDecoration(color: PdfColors.grey300),
                    children: [
                      pw.Padding(
                        padding: pw.EdgeInsets.all(4),
                        child: pw.Text('No', textAlign: pw.TextAlign.center),
                      ),
                      pw.Padding(
                        padding: pw.EdgeInsets.all(4),
                        child: pw.Text('Jenis', textAlign: pw.TextAlign.center),
                      ),
                      pw.Padding(
                        padding: pw.EdgeInsets.all(4),
                        child:
                            pw.Text('Jumlah', textAlign: pw.TextAlign.center),
                      ),
                      pw.Padding(
                        padding: pw.EdgeInsets.all(4),
                        child: pw.Text('Harga Satuan',
                            textAlign: pw.TextAlign.center),
                      ),
                      pw.Padding(
                        padding: pw.EdgeInsets.all(4),
                        child: pw.Text(
                            'Total ${pemesanan.tiketList![0].kelas!}',
                            textAlign: pw.TextAlign.center),
                      ),
                    ],
                  ),
                  if (pemesanan.jumlahTiketReguler > 0)
                    pw.TableRow(
                      children: [
                        pw.Padding(
                          padding: pw.EdgeInsets.all(4),
                          child: pw.Text('1', textAlign: pw.TextAlign.center),
                        ),
                        pw.Padding(
                          padding: pw.EdgeInsets.all(4),
                          child: pw.Text('Reguler',
                              textAlign: pw.TextAlign.center),
                        ),
                        pw.Padding(
                          padding: pw.EdgeInsets.all(4),
                          child: pw.Text(
                              pemesanan.jumlahTiketReguler.toString(),
                              textAlign: pw.TextAlign.center),
                        ),
                        pw.Padding(
                          padding: pw.EdgeInsets.all(4),
                          child: pw.Text(biayaReguler,
                              textAlign: pw.TextAlign.center),
                        ),
                        pw.Padding(
                          padding: pw.EdgeInsets.all(4),
                          child: pw.Text(totalBiayaReguler,
                              textAlign: pw.TextAlign.center),
                        ),
                      ],
                    ),
                  if (pemesanan.jumlahTiketVIP > 0)
                    pw.TableRow(
                      children: [
                        pw.Padding(
                          padding: pw.EdgeInsets.all(4),
                          child: pw.Text(
                              pemesanan.jumlahTiketReguler > 0 ? '2' : '1',
                              textAlign: pw.TextAlign.center),
                        ),
                        pw.Padding(
                          padding: pw.EdgeInsets.all(4),
                          child: pw.Text('VIP', textAlign: pw.TextAlign.center),
                        ),
                        pw.Padding(
                          padding: pw.EdgeInsets.all(4),
                          child: pw.Text(pemesanan.jumlahTiketVIP.toString(),
                              textAlign: pw.TextAlign.center),
                        ),
                        pw.Padding(
                          padding: pw.EdgeInsets.all(4),
                          child:
                              pw.Text(biayaVIP, textAlign: pw.TextAlign.center),
                        ),
                        pw.Padding(
                          padding: pw.EdgeInsets.all(4),
                          child: pw.Text(totalBiayaVIP,
                              textAlign: pw.TextAlign.center),
                        ),
                      ],
                    ),
                ],
              ),
              pw.SizedBox(height: 16),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.end,
                children: [
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text('Biaya Admin (10%)'),
                      pw.Text('TOTAL'),
                    ],
                  ),
                  pw.SizedBox(width: 16),
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.end,
                    children: [
                      pw.Text(biayaAdmin),
                      pw.Text(biayaAkhir),
                    ],
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
}
