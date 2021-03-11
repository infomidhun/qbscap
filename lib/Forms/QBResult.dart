import 'package:barcode/barcode.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:qbscap/colors.dart';

class QBResult extends StatelessWidget {
  final String format, data;
  const QBResult({Key key, this.format, this.data}) : super(key: key);

  _getImage() {
    Barcode _result;
    switch (this.format) {
      case 'AZTEC':
        _result = Barcode.aztec();
        break;
      case 'CODABAR':
        _result = Barcode.codabar();
        break;
      case 'CODE_39':
        _result = Barcode.code39();
        break;
      case 'CODE_93':
        _result = Barcode.code93();
        break;
      case 'CODE_128':
        _result = Barcode.code128();
        break;
      case 'DATA_MATRIX':
        _result = Barcode.dataMatrix();
        break;
      case 'EAN_8':
        _result = Barcode.ean8();
        break;
      case 'EAN_13':
        _result = Barcode.ean13();
        break;
      case 'ITF':
        _result = Barcode.itf();
        break;
      case 'MAXICODE':
        _result = Barcode.dataMatrix();
        break;
      case 'PDF_417':
        _result = Barcode.pdf417();
        break;
      case 'QR_CODE':
        _result = Barcode.qrCode();
        break;
      case 'RSS14':
        _result = Barcode.rm4scc();
        break;
      case 'RSS_EXPANDED':
        _result = Barcode.rm4scc();
        break;
      case 'UPC_A':
        _result = Barcode.upcA();
        break;
      case 'UPC_E':
        _result = Barcode.upcE();
        break;
      case 'UPC_EAN_EXTENSION':
        _result = Barcode.upcE();
        break;
      default:
        return 'NOT_VALID';
    }
    final svg = _result.toSvg(this.data,
        height: this.format == "QR_CODE" ? 200 : 100,
        drawText: this.format != "QR_CODE",
        fullSvg: true);

    return Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
            color: COLOR_GRAY.withOpacity(0.54),
            borderRadius: BorderRadius.circular(4)),
        child: SvgPicture.string(svg));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          alignment: Alignment.center,
          child: SingleChildScrollView(
            child: Column(
              children: [
                _getImage(),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      this.format.split('_')[0],
                      style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.blue),
                    ),
                    SizedBox(
                      width: 4,
                    ),
                    this.format.split('_').length > 1
                        ? Row(
                            children: List.generate(
                                this.format.split('_').length - 1,
                                (index) => Text(
                                      this.format.split('_')[index + 1],
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    )),
                          )
                        : SizedBox(),
                  ],
                ),
                SizedBox(
                  height: 4,
                ),
                Text("${this.data}"),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                          icon: Icon(Icons.copy),
                          tooltip: "Copy",
                          splashRadius: 20,
                          onPressed: () {}),
                      IconButton(
                          icon: Icon(Icons.edit_outlined),
                          tooltip: "Edit",
                          splashRadius: 20,
                          onPressed: () {}),
                      IconButton(
                          icon: Icon(Icons.share_outlined),
                          tooltip: "Share",
                          splashRadius: 20,
                          onPressed: () {}),
                      IconButton(
                          icon: Icon(Icons.save_outlined),
                          tooltip: "Save",
                          splashRadius: 20,
                          onPressed: () {}),
                      IconButton(
                          icon: Icon(Icons.close),
                          tooltip: "Close",
                          splashRadius: 20,
                          onPressed: () => Navigator.pop(context))
                    ],
                  ),
                ),
                OutlinedButton(
                  style: ButtonStyle(
                      side: MaterialStateProperty.all<BorderSide>(BorderSide(
                    color: Colors.blue,
                  ))),
                  onPressed: () {},
                  child: Text(
                    "Open website",
                    style: const TextStyle(fontSize: 16),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
