import 'package:qbscap/env.dart';
import 'package:flutter/material.dart';

class QBSearchBox extends StatelessWidget {
  final String text;
  final Function onPressed;

  const QBSearchBox({
    Key key,
    this.text = "Search recent scans...",
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: SizedBox(
        height: 42,
        width: double.infinity,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(36),
          child: Material(
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.black54
                : COLOR_GRAY,
            child: InkWell(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      this.text,
                      style: TextStyle(
                          color: Theme.of(context).brightness == Brightness.dark
                              ? Colors.white54
                              : Colors.black54,
                          fontSize: 15),
                    ),
                    Icon(Icons.search,
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.white54
                            : Colors.black54)
                  ],
                ),
              ),
              onTap: this.onPressed,
            ),
          ),
        ),
      ),
    );
  }
}
