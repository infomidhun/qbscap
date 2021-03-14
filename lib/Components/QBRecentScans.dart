import 'package:qbscap/Forms/QBRecentAll.dart';
import 'package:qbscap/Forms/QBResult.dart';
import 'package:qbscap/env.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qbscap/Components/QBBlankItem.dart';
import 'package:qbscap/Components/QBListItem.dart';

class QBRecentScans extends StatelessWidget {
  final Function defFunc;
  final bool bShowViewAll;
  const QBRecentScans({
    Key key,
    this.defFunc,
    this.bShowViewAll = true,
  }) : super(key: key);

  Widget _getItems(width, History history, BuildContext context) {
    List<List<String>> _scans = history.getScans();
    return Expanded(
        child: _scans.length == 0
            ? Padding(
                padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
                child: QBBlankItem(
                  icon: Icons.qr_code_scanner_outlined,
                  color: Colors.blueGrey,
                  onPress: () => this.defFunc(),
                  text: "You haven't scanned any QR/Barcodes yet\nScan one.",
                ),
              )
            : GridView.count(
                physics: BouncingScrollPhysics(),
                padding: EdgeInsets.only(left: 12, right: 12, bottom: 12),
                crossAxisCount: (width / 118).round(),
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
                childAspectRatio: 118 / 108,
                children: List.generate(
                    this.bShowViewAll
                        ? (_scans.length < 25 ? _scans.length : 25)
                        : _scans.length, (index) {
                  return QBListItem(
                      title: _scans[index][1].replaceAll("_", " "),
                      description: _scans[index][0],
                      barcodeType: _scans[index][1],
                      barcodeData: _scans[index][0],
                      onPressed: () => Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (_) => QBResult(
                                  data: _scans[index][0],
                                  format: _scans[index][1]))));
                }).toList(),
              ));
  }

  @override
  Widget build(BuildContext context) {
    History _history = context.watch<History>();

    return Expanded(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text(
                "Recent scans",
                style:
                    const TextStyle(fontWeight: FontWeight.w800, fontSize: 20),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Total scanned items (${_history.getScans().length})",
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  if (_history.getScans().length != 0 && this.bShowViewAll)
                    GestureDetector(
                      onTap: () => Navigator.of(context).push(MaterialPageRoute(
                          builder: (_) => QBRecentAll(
                                title: "Recent scans",
                                description:
                                    "Total scanned items (${_history.getScans().length})",
                                recentMode: QBRecentMode.Scan,
                              ))),
                      child: Container(
                        color: Colors.transparent,
                        child: const Text(
                          "View All",
                          style: const TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                              color: Colors.blue),
                        ),
                      ),
                    ),
                ],
              ),
            ]),
          ),
          SizedBox(
            height: 12,
          ),
          _getItems(
              (MediaQuery.of(context).size.width - 24), _history, context),
        ],
      ),
    );
  }
}
