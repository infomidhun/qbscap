import 'package:flutter/material.dart';

class QBBlankItem extends StatelessWidget {
  final IconData icon;
  final MaterialColor color;
  final String text;
  final Function onPress;
  const QBBlankItem({
    Key key,
    this.icon,
    this.text,
    this.color,
    this.onPress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(4),
      color: Theme.of(context).brightness == Brightness.dark
          ? Colors.black54
          : this.color.shade50,
      child: InkWell(
        splashColor: Theme.of(context).brightness == Brightness.dark
            ? Colors.black54
            : Theme.of(context).splashColor,
        onTap: () => this.onPress(),
        borderRadius: BorderRadius.circular(4),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      border: Border.all(
                          color: this.color.shade400,
                          style: BorderStyle.solid,
                          width: 1.4)),
                  child: Icon(
                    this.icon,
                    color: this.color.shade400,
                  )),
              SizedBox(
                height: 6,
              ),
              Text(
                "${this.text}",
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: this.color.shade500, fontWeight: FontWeight.w500),
              )
            ],
          ),
        ),
      ),
    );
  }
}
