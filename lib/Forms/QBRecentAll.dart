import 'package:flutter/material.dart';
import 'package:qbscap/Components/QBRecentScans.dart';
import 'package:qbscap/Components/QBSearchBox.dart';

enum QBRecentMode { Project, Scan }

class QBRecentAll extends StatefulWidget {
  final QBRecentMode recentMode;
  final String title, description;

  const QBRecentAll({Key key, this.title, this.description, this.recentMode})
      : super(key: key);

  @override
  _QBRecentAllState createState() => _QBRecentAllState();
}

class _QBRecentAllState extends State<QBRecentAll> {
  String _searchText;
  @override
  void initState() {
    _searchText =
        "Search recent ${widget.recentMode == QBRecentMode.Scan ? "scans" : "projects"}...";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: SafeArea(
        child: Scaffold(
          body: Column(
            children: [
              ///
              /// Search box button
              ///
              QBSearchBox(
                text: "$_searchText",
                onPressed: () {},
              ),
              QBRecentScans(
                bShowViewAll: false,
                defFunc: null,
              )
            ],
          ),
        ),
      ),
    );
  }
}
