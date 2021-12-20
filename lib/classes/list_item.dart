import 'package:flutter/material.dart';

class ListItem extends StatefulWidget{
  final Icon listItemIcon;
  final String listItemTitle;
  final Widget viewer;

  const ListItem({Key? key,
    required this.listItemIcon,
    required this.listItemTitle,
    required this.viewer,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ListState();
}

class _ListState extends State<ListItem> {
  late ListItem item;

  @override
  void initState() {
    super.initState();
    item = widget;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Padding(
        padding: const EdgeInsets.only(
          bottom: 20.0,
        ),
        child: Container(
          height: 75,
          color: Colors.black12,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: <Widget>[
                item.listItemIcon,
                Padding(
                  padding: const EdgeInsets.only(
                    left: 16.0,
                  ),
                  child: Text(
                    item.listItemTitle,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => item.viewer
          )
        );
      }
    );
  }
}