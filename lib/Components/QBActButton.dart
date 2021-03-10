import 'package:flutter/material.dart';

class QBActButtonItems {
  final String text;
  final IconData icon;
  final Color backgroundColor;
  final Function onTap;

  const QBActButtonItems(
      {this.onTap, this.icon, this.text, this.backgroundColor});
}

class QBActButton extends StatelessWidget {
  final List<QBActButtonItems> items;

  const QBActButton({
    Key key,
    this.items,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 90,
        width: double.infinity,
        child: ListView.separated(
            scrollDirection: Axis.horizontal,
            physics: ClampingScrollPhysics(),
            itemBuilder: (_, index) {
              BorderRadius _borderRadius = BorderRadius.circular(4);
              if (index == 0)
                _borderRadius = BorderRadius.only(
                    topRight: const Radius.circular(4),
                    bottomRight: const Radius.circular(4));
              if (index == this.items.length - 1)
                _borderRadius = BorderRadius.only(
                    topLeft: const Radius.circular(4),
                    bottomLeft: const Radius.circular(4));

              return SizedBox(
                width: 153,
                child: ClipRRect(
                  borderRadius: _borderRadius,
                  child: Material(
                    borderRadius: _borderRadius,
                    color: this.items[index].backgroundColor,
                    child: InkWell(
                      onTap: this.items[index].onTap,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(this.items[index].icon,
                              color: Theme.of(context).scaffoldBackgroundColor),
                          const SizedBox(
                            height: 6,
                          ),
                          Text(
                            "${this.items[index].text}",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Theme.of(context)
                                    .scaffoldBackgroundColor
                                    .withOpacity(0.9),
                                fontWeight: FontWeight.w500,
                                fontSize: 15),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
            separatorBuilder: (_, index) {
              return const SizedBox(
                width: 8,
              );
            },
            itemCount: this.items.length));
  }
}
