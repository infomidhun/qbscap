import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class QBRScanner extends StatefulWidget {
  @override
  _QBRScannerState createState() => _QBRScannerState();
}

class _QBRScannerState extends State<QBRScanner> {
  QRViewController _controller;
  bool _cameraPause;
  final GlobalKey _key = GlobalKey(debugLabel: 'QR');

  /* @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) _controller.pauseCamera();
    _controller.resumeCamera();
  }*/

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _cameraPause = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
            MediaQuery.of(context).size.height < 400)
        ? 250.0
        : 300.0;

    return Material(
      color: Colors.transparent,
      child: Column(
        children: [
          Expanded(
            child: QRView(
              key: _key,
              overlay: QrScannerOverlayShape(
                  borderColor: Colors.orange,
                  borderRadius: 4,
                  borderLength: 22,
                  borderWidth: 4,
                  cutOutSize: scanArea),
              onQRViewCreated: (controller) {
                setState(() {
                  _controller = controller;
                });
                _controller.scannedDataStream.listen((scanData) {
                  _controller.dispose();
                  Navigator.pop(context, scanData);
                });
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                    splashRadius: 24,
                    icon: const Icon(Icons.flip_camera_ios_outlined),
                    onPressed: () async => _controller?.flipCamera()),
                IconButton(
                    splashRadius: 24,
                    icon: const Icon(Icons.flash_on_rounded),
                    onPressed: () async => _controller?.toggleFlash()),
                IconButton(
                    splashRadius: 24,
                    icon: Icon(_cameraPause
                        ? Icons.qr_code_scanner_rounded
                        : Icons.pause),
                    onPressed: () async {
                      _cameraPause
                          ? _controller.resumeCamera()
                          : _controller?.pauseCamera();
                      setState(() {
                        _cameraPause = !_cameraPause;
                      });
                    }),
                IconButton(
                    splashRadius: 24,
                    icon: Icon(Icons.close),
                    onPressed: () {
                      _controller.dispose();
                      Navigator.pop(context, null);
                    }),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
