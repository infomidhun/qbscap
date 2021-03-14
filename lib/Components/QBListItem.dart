import 'package:flutter_svg/flutter_svg.dart';
import 'package:qbscap/env.dart';
import 'package:flutter/material.dart';

class QBListItem extends StatelessWidget {
  final Color backgroundColor;
  final Function onPressed;
  final String title, description, barcodeType, barcodeData;

  const QBListItem({
    Key key,
    this.backgroundColor = COLOR_GRAY,
    this.title,
    this.description,
    this.barcodeType,
    this.barcodeData,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(4),
      child: Material(
        color: Theme.of(context).brightness == Brightness.dark
            ? Colors.black54
            : this.backgroundColor,
        borderRadius: BorderRadius.circular(4),
        child: InkWell(
          splashColor: Theme.of(context).brightness == Brightness.dark
              ? Colors.black54
              : Theme.of(context).splashColor,
          onTap: () => this.onPressed(),
          child: Container(
            width: 118,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    padding: EdgeInsets.all(4),
                    decoration: BoxDecoration(
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.white54
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(2)),
                    child: SvgPicture.string(barcodeFromString(this.barcodeType)
                        .toSvg(this.barcodeData,
                            height: this.barcodeType == "QR_CODE" ? 200 : 100,
                            drawText: this.barcodeType != "QR_CODE",
                            fullSvg: true)),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(4),
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                            Colors.transparent,
                            Colors.black.withOpacity(0.81)
                          ])),
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 4, vertical: 1),
                            decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.81),
                                borderRadius: BorderRadius.circular(3)),
                            child: Text(
                              "${this.title}",
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style: TextStyle(
                                  color: Theme.of(context).brightness ==
                                          Brightness.dark
                                      ? Colors.amber
                                      : Colors.amber,
                                  fontWeight: FontWeight.w800),
                            ),
                          ),
                          Text(
                            "${this.description}",
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: TextStyle(
                                fontSize: 10,
                                color: Theme.of(context).brightness ==
                                        Brightness.dark
                                    ? Colors.blueGrey.shade800
                                    : Colors.blueGrey.shade300),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
