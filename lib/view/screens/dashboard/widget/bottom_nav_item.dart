import 'package:flutter/material.dart';

class BottomNavItem extends StatelessWidget {
  final IconData iconData;
  final Function onTap;
  final bool isSelected;
  final String label;
  BottomNavItem(
      {@required this.iconData,
      this.onTap,
      this.isSelected = false,
      @required this.label});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Wrap(
          //margin: const EdgeInsets.only(top: 0.0, bottom: 0.0),
          // padding: EdgeInsets.only(top: 10.0),
          spacing: 0.0,
          children: [
            Column(
                // spacing: 0.0,
                children: [
                  SizedBox(
                      child: Wrap(
                    spacing: 0.0,
                    children: [
                      IconButton(
                        style: ButtonStyle(
                            padding:
                                MaterialStateProperty.all(EdgeInsets.zero)),
                        icon: Icon(iconData,
                            color: isSelected
                                ? Theme.of(context).primaryColor
                                : Colors.grey,
                            size: 25),
                        onPressed: onTap,
                      ),
                      Text(label,
                      
                          textAlign: TextAlign.center,
                          style: isSelected
                              ? TextStyle(color: Colors.black)
                              : TextStyle(color: Colors.grey)),
                    ],
                  ))
                ]),
          ]),
    );
  }
}
