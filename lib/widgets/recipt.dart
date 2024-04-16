import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

Future<void> savePdf(String name, int id, String product, double cost) async {
  final pdf = pw.Document();

  pdf.addPage(
    pw.Page(
      build: (pw.Context context) {
        return pw.Center(
          child: pw.Column(
            mainAxisAlignment: pw.MainAxisAlignment.center,
            children: [
              pw.Text('Name: $name'),
              pw.Text('ID: $id'),
              pw.Text('Product: $product'),
              pw.Text('Cost: $cost'),
            ],
          ),
        );
      },
    ),
  );

  final directory = await getExternalStorageDirectory();
  final file = File('${directory?.path}/example.pdf');
  await file.writeAsBytes(await pdf.save());
}
