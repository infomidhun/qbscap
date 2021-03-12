import 'dart:io';
import 'package:path/path.dart';
import 'package:share/share.dart';
import 'package:qbscap/colors.dart';
import 'package:barcode/barcode.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:image/image.dart' as img;
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:path_provider/path_provider.dart';
import 'package:barcode_image/barcode_image.dart';

class QBResult extends StatelessWidget {
  final String format, data;
  const QBResult({Key key, this.format, this.data}) : super(key: key);

  Barcode _getResult() {
    switch (this.format) {
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

  String _toSVG(Barcode bcode) {
    return bcode.toSvg(this.data,
        height: this.format == "QR_CODE" ? 200 : 100,
        drawText: this.format != "QR_CODE",
        fullSvg: true);
  }

  ///
  /// The QR result mode, if text, url, contact, phone, sms
  ///
  List<String> _getMode() {
    if (this.data.indexOf('http://') == 0 || this.data.indexOf('https://') == 0)
      return ['url', 'Open website', this.data];
    else if (this.data.indexOf('BEGIN:VCARD') == 0)
      return ['contact', 'Share contact', this.data];
    else if (this.data.indexOf('tel:') == 0 || this.data.indexOf('TEL:') == 0)
      return ['tel', 'Call to phone', this.data];
    else if (this.data.indexOf('mailto:') == 0 ||
        this.data.indexOf('MAILTO:') == 0)
      return ['mailto', 'Write an email', this.data];
    else if (this.data.indexOf('smsto:') == 0 ||
        this.data.indexOf('SMSTO:') == 0 ||
        this.data.indexOf('sms:') == 0 ||
        this.data.indexOf('SMS:') == 0)
      return ['sms', 'Send a message', this.data];
    else
      return null;
  }

  @override
  Widget build(BuildContext context) {
    final _mode = _getMode();

    return SafeArea(
      child: Scaffold(
        body: Container(
          alignment: Alignment.center,
          padding: EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        color: COLOR_GRAY.withOpacity(0.54),
                        borderRadius: BorderRadius.circular(4)),
                    child: SvgPicture.string(_toSVG(_getResult()))),
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
                          onPressed: () async {
                            await Clipboard.setData(
                                ClipboardData(text: this.data));

                            ScaffoldMessenger.of(context).hideCurrentSnackBar();
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content:
                                    const Text('Data copied to clipboard.'),
                              ),
                            );
                          }),
                      IconButton(
                          icon: Icon(Icons.edit_outlined),
                          tooltip: "Edit",
                          onPressed: () {}),
                      IconButton(
                          icon: Icon(Icons.share_outlined),
                          tooltip: "Share",
                          onPressed: () async {
                            final _dir = await getTemporaryDirectory();
                            final _path = (join(_dir.path, 'QB Scap.pdf'));
                            final _bcode = _getResult();
                            final _svg = _toSVG(_getResult());
                            final _ind = '<svg viewBox="';
                            final _pos = _svg.indexOf(_ind);
                            final _pex = _svg
                                .substring(_pos + _ind.length,
                                    _svg.indexOf('"', _pos + _ind.length))
                                .trim();
                            final _spl = _pex.split(' ');
                            final _width = double.parse(_spl[2]);
                            final _height = double.parse(_spl[3]);
                            final pdf = pw.Document();

                            pdf.addPage(
                              pw.Page(
                                build: (pw.Context context) => pw.Center(
                                    child: pw.BarcodeWidget(
                                        textStyle: pw.Theme.of(context)
                                            .defaultTextStyle
                                            .copyWith(fontSize: 16),
                                        data: this.data,
                                        width: _width,
                                        height: _height,
                                        barcode: _bcode)),
                              ),
                            );
                            final file = File(_path);
                            await file.writeAsBytes(await pdf.save());

                            Share.shareFiles([_path],
                                mimeTypes: ['application/pdf'],
                                subject: "QB Scap",
                                text: "${this.format} :: ${this.data}");
                          }),
                      PopupMenuButton(
                          offset: const Offset(79, 10),
                          tooltip: "Save",
                          color: Colors.black,
                          elevation: 1,
                          padding: EdgeInsets.zero,
                          icon: Icon(Icons.save_outlined),
                          onSelected: (value) async {
                            final _dir = await getExternalStorageDirectory();
                            final _path = (join(_dir.path,
                                "${DateTime.now().millisecondsSinceEpoch}"));
                            final _bcode = _getResult();

                            switch (value) {
                              case 'pdf':
                                {
                                  final _svg = _toSVG(_getResult());
                                  final _ind = '<svg viewBox="';
                                  final _pos = _svg.indexOf(_ind);
                                  final _pex = _svg
                                      .substring(_pos + _ind.length,
                                          _svg.indexOf('"', _pos + _ind.length))
                                      .trim();
                                  final _spl = _pex.split(' ');
                                  final _width = double.parse(_spl[2]);
                                  final _height = double.parse(_spl[3]);
                                  final pdf = pw.Document();

                                  pdf.addPage(
                                    pw.Page(
                                      build: (pw.Context context) => pw.Center(
                                          child: pw.BarcodeWidget(
                                              textStyle: pw.Theme.of(context)
                                                  .defaultTextStyle
                                                  .copyWith(fontSize: 16),
                                              data: this.data,
                                              width: _width,
                                              height: _height,
                                              barcode: _bcode)),
                                    ),
                                  );
                                  final file = File("$_path.pdf");
                                  await file.writeAsBytes(await pdf.save());
                                  ScaffoldMessenger.of(context)
                                      .hideCurrentSnackBar();
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('PDF Saved on: $_path.pdf'),
                                    ),
                                  );
                                }
                                break;

                              case 'png':
                                {
                                  final image = img.Image(600, 350);
                                  drawBarcode(image, _bcode, this.data,
                                      font: img.arial_24);
                                  File("$_path.png")
                                      .writeAsBytesSync(img.encodePng(image));
                                  ScaffoldMessenger.of(context)
                                      .hideCurrentSnackBar();
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('PNG Saved on: $_path.png'),
                                    ),
                                  );
                                }
                                break;
                              case 'jpg':
                                {
                                  final image = img.Image(600, 350);
                                  img.fill(image, img.getColor(255, 255, 255));
                                  drawBarcode(image, _bcode, this.data,
                                      font: img.arial_24);
                                  File("$_path.jpg")
                                      .writeAsBytesSync(img.encodeJpg(image));
                                  ScaffoldMessenger.of(context)
                                      .hideCurrentSnackBar();
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('JPG Saved on: $_path.jpg'),
                                    ),
                                  );
                                }
                                break;
                              case 'svg':
                                {
                                  final svg =
                                      '<?xml version="1.0" encoding="utf-8"?>\n' +
                                          '<!DOCTYPE svg PUBLIC "-//W3C//DTD SVG 1.1//EN" "http://www.w3.org/Graphics/SVG/1.1/DTD/svg11.dtd">\n' +
                                          _toSVG(_getResult());
                                  await File("$_path.svg").writeAsString(svg);
                                  ScaffoldMessenger.of(context)
                                      .hideCurrentSnackBar();
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('SVG Saved on: $_path.svg'),
                                    ),
                                  );
                                }
                                break;
                            }
                          },
                          itemBuilder: (_) {
                            return [
                              PopupMenuItem<String>(
                                  child: const Text(
                                    'PDF',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w500,
                                        color: Colors.red),
                                  ),
                                  value: 'pdf'),
                              PopupMenuItem<String>(
                                  child: const Text('PNG',
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w500,
                                          color: Colors.green)),
                                  value: 'png'),
                              PopupMenuItem<String>(
                                  child: const Text('JPG',
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w500,
                                          color: Colors.blue)),
                                  value: 'jpg'),
                              PopupMenuItem<String>(
                                  child: const Text('SVG',
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w500,
                                          color: Colors.orange)),
                                  value: 'svg')
                            ];
                          }),
                      IconButton(
                          icon: Icon(Icons.close),
                          tooltip: "Close",
                          onPressed: () => Navigator.pop(context))
                    ],
                  ),
                ),
                _mode != null
                    ? OutlinedButton(
                        style: ButtonStyle(
                            side: MaterialStateProperty.all<BorderSide>(
                                BorderSide(
                          color: Colors.blue,
                        ))),
                        onPressed: () async {
                          switch (_mode[0]) {
                            case 'url':
                              if (await canLaunch(_mode[2]))
                                await launch(_mode[2]);
                              break;
                            case 'contact':
                              final _dir = await getTemporaryDirectory();
                              final _path = (join(_dir.path, 'QB Scap.vcf'));

                              File(_path).writeAsStringSync(this.data);
                              Share.shareFiles([_path],
                                  mimeTypes: ['text/vcard'],
                                  subject: "QB Scap",
                                  text: "${this.data}");
                              break;
                            case 'tel':
                              if (await canLaunch(_mode[2]))
                                await launch(_mode[2]);
                              break;
                            case 'mailto':
                              if (await canLaunch(_mode[2]))
                                await launch(_mode[2]);
                              break;
                            case 'sms':
                              final _data = _mode[2]
                                  .replaceFirst("SMSTO:", "sms:")
                                  .replaceFirst("smsto:", "sms:")
                                  .replaceFirst("SMS:", "sms:")
                                  .split(":");
                              if (_data.length >= 3) {
                                if (await canLaunch(
                                    "${_data[0]}:${_data[1]}?body=${_data[2]}"))
                                  await launch(
                                      "${_data[0]}:${_data[1]}?body=${_data[2]}");
                              } else if (await canLaunch(
                                  "${_data[0]}:${_data[1]}"))
                                await launch("${_data[0]}:${_data[1]}");
                              break;
                          }
                        },
                        child: Text(
                          _mode[1],
                          style: const TextStyle(fontSize: 16),
                        ),
                      )
                    : SizedBox()
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class HelloWorld extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
