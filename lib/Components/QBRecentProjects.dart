import 'package:flutter/material.dart';
import 'package:qbscap/Components/QBBlankItem.dart';
import 'package:qbscap/Components/QBListItem.dart';

class QBRecentProjects extends StatelessWidget {
  const QBRecentProjects({
    Key key,
  }) : super(key: key);

  Widget _getItems() {
    bool b = true;
    return b
        ? QBBlankItem(
            icon: Icons.edit_outlined,
            color: Colors.green,
            text: "You haven't created any projects yet, create one.",
          )
        : ListView.separated(
            scrollDirection: Axis.horizontal,
            physics: BouncingScrollPhysics(),
            itemBuilder: (_, index) {
              return QBListItem();
            },
            separatorBuilder: (_, index) {
              return const SizedBox(
                width: 8,
              );
            },
            itemCount: 10);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Padding(
        padding: EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Recent projects",
              style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 20),
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
            SizedBox(
              height: 12,
            ),
            SizedBox(
              width: double.infinity,
              height: 108,
              child: _getItems(),
            )
          ],
        ),
      ),
    );
  }
}
