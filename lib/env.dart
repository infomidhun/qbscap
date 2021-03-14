import 'dart:convert';

import 'package:barcode_image/barcode_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

const Color COLOR_GRAY = Color(0xFFF0F2F3);

Barcode barcodeFromString(String format) {
  switch (format) {
    case 'AZTEC':
      return Barcode.aztec();
    case 'CODABAR':
      return Barcode.codabar();
    case 'CODE_39':
      return Barcode.code39();
    case 'CODE_93':
      return Barcode.code93();
    case 'CODE_128':
      return Barcode.code128();
    case 'DATA_MATRIX':
      return Barcode.dataMatrix();
    case 'EAN_8':
      return Barcode.ean8();
    case 'EAN_13':
      return Barcode.ean13();
    case 'ITF':
      return Barcode.itf();
    case 'MAXICODE':
      return Barcode.dataMatrix();
    case 'PDF_417':
      return Barcode.pdf417();
    case 'QR_CODE':
      return Barcode.qrCode();
    case 'RSS14':
      return Barcode.rm4scc();
    case 'RSS_EXPANDED':
      return Barcode.rm4scc();
    case 'UPC_A':
      return Barcode.upcA();
    case 'UPC_E':
      return Barcode.upcE();
    case 'UPC_EAN_EXTENSION':
      return Barcode.upcE();
    default:
      return null;
  }
}

class History with ChangeNotifier {
  final List<List<String>> _scanItems = [];
  SharedPreferences _prefs;

  List<List<String>> getScans() => _scanItems;
  List<String> getScan(index) => _scanItems[index];

  void alloc() async {
    if (_prefs != null) return;
    _prefs = await SharedPreferences.getInstance();
    final _dataRecent = _prefs.getString('RECENT_SCANS') ?? null;

    if (_dataRecent != null)
      jsonDecode(_dataRecent)
          .forEach((element) => _scanItems.add([element[0], element[1]]));
    notifyListeners();
  }

  void addScan(List<String> data) async {
    _scanItems.insert(0, data);
    _prefs.setString('RECENT_SCANS', jsonEncode(_scanItems));
    notifyListeners();
  }

  void removeScan(int index) async {
    _scanItems.removeAt(index);
    notifyListeners();
  }

  void removeAllScans(int index) async {
    _scanItems.removeRange(0, _scanItems.length);
    notifyListeners();
  }
}
