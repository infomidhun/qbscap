import 'package:qbscap/env.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qbscap/Forms/QBResult.dart';
import 'package:qbscap/Forms/QBScanner.dart';
import 'package:image_picker/image_picker.dart';
import 'package:qbscap/Components/QBSearchBox.dart';
import 'package:qbscap/Components/QBActButton.dart';
import 'package:qbscap/Components/QBRecentScans.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:qbscap/Components/QBRecentProjects.dart';
import 'package:permission_handler/permission_handler.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final GlobalKey<ScaffoldState> _globalKey = GlobalKey();
  String _searchText;
  List<QBActButtonItems> _qbaButtons;

  History _history;

  void _sysUIOverlay({bool bNormal = true}) {
    if (bNormal)
      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
          systemNavigationBarColor: Theme.of(context).scaffoldBackgroundColor,
          statusBarColor: Theme.of(context).scaffoldBackgroundColor));
    else
      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
          systemNavigationBarColor: Colors.black,
          statusBarIconBrightness: Brightness.light,
          statusBarColor: Colors.transparent));
  }

  void _scanQB() async {
    var status = await Permission.camera.status;
    if (!status.isGranted) {
      if (!await Permission.camera.request().isGranted) return;
    }
    _sysUIOverlay(bNormal: false);
    var result = await Navigator.of(_globalKey.currentContext)
        .push(MaterialPageRoute(builder: (_) => QBScanner()));
    _sysUIOverlay(bNormal: true);
    if (!(result is Barcode)) return;

    Barcode barcode = result;
    Navigator.of(context).push(MaterialPageRoute(
        builder: (_) => QBResult(
              format: barcode.format.formatName,
              data: barcode.code,
            )));
    _history.addScan([barcode.code, barcode.format.formatName]);
  }

  void _importQB() async {
    var status = await Permission.mediaLibrary.status;
    if (!status.isGranted) {
      if (!await Permission.mediaLibrary.request().isGranted) return;
    }

    final picker = ImagePicker();
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    if (pickedFile == null) return;
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => QBResult()));
  }

  @override
  void initState() {
    _searchText = "Search recent scans...";
    _qbaButtons = [
      QBActButtonItems(
          icon: Icons.qr_code_scanner_outlined,
          text: "Scan QR\nBarcode",
          backgroundColor: const Color(0XFF5EA7CC),
          onTap: () => _scanQB()),
      QBActButtonItems(
          icon: Icons.edit_outlined,
          text: "Create QR\nBarcode",
          backgroundColor: const Color(0xFFE6A73E)),
      QBActButtonItems(
          icon: Icons.print_outlined,
          text: "QR/Barcode\nLabel Print",
          backgroundColor: const Color(0xFF78CE6C)),
      QBActButtonItems(
          icon: Icons.photo_outlined,
          text: "Scan QR/Barcode\nFrom gallery",
          backgroundColor: const Color(0xFFE63E3E),
          onTap: () => _importQB())
    ];
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ///
    ///
    ///
    _history = context.watch<History>();

    ///
    /// Update device status bar color
    ///
    _sysUIOverlay(bNormal: true);

    ///
    ///
    ///
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: SafeArea(
        child: Scaffold(
          key: _globalKey,
          body: Column(
            children: [
              ///
              /// Search box button
              ///
              QBSearchBox(
                text: "$_searchText",
                onPressed: () {},
              ),

              ///
              ///
              ///
              QBActButton(
                items: _qbaButtons,
              ),

              ///
              ///
              ///
              QBRecentProjects(),

              ///
              ///
              ///
              QBRecentScans(
                defFunc: _scanQB,
              )
            ],
          ),
        ),
      ),
    );
  }
}
