import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qbscap/Components/QBActButton.dart';
import 'package:qbscap/Components/QBRecentProjects.dart';
import 'package:qbscap/Components/QBRecentScans.dart';
import 'package:qbscap/Components/QBSearchBox.dart';
import 'package:qbscap/Forms/QBRScanner.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final GlobalKey<ScaffoldState> _globalKey = GlobalKey();
  String _searchText;
  List<QBActButtonItems> _qbaButtons;

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

  @override
  void initState() {
    _searchText = "Search recent scans...";
    _qbaButtons = [
      QBActButtonItems(
          icon: Icons.qr_code_scanner_outlined,
          text: "Scan QR\nBarcode",
          backgroundColor: const Color(0XFF5EA7CC),
          onTap: () async {
            _sysUIOverlay(bNormal: false);
            var result = await Navigator.of(_globalKey.currentContext)
                .push(MaterialPageRoute(builder: (_) => QBRScanner()));
            _sysUIOverlay(bNormal: true);
            if (!(result is Barcode)) return;
            Barcode barcode = result;
            print(barcode.format);
          }),
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
          backgroundColor: const Color(0xFFE63E3E))
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
              QBRecentScans(),
            ],
          ),
        ),
      ),
    );
  }
}
