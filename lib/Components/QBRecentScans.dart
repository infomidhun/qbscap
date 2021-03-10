import 'package:flutter/material.dart';
import 'package:qbscap/Components/QBBlankItem.dart';
import 'package:qbscap/Components/QBListItem.dart';

class QBRecentScans extends StatelessWidget {
  const QBRecentScans({
    Key key,
  }) : super(key: key);

  Widget _getItems(width) {
    bool b = true;
    return Expanded(
        child: b
            ? Padding(
                padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
                child: QBBlankItem(
                  icon: Icons.qr_code_scanner_outlined,
                  color: Colors.blueGrey,
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
                children: List.generate(100, (index) {
                  return QBListItem();
                }).toList(),
              ));
  }

  @override
  Widget build(BuildContext context) {
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
                    "Total created projects (10)",
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  const Text(
                    "View All",
                    style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                        color: Colors.blue),
                  ),
                ],
              ),
            ]),
          ),
          SizedBox(
            height: 12,
          ),
          _getItems((MediaQuery.of(context).size.width - 24)),
        ],
      ),
    );
  }
}
