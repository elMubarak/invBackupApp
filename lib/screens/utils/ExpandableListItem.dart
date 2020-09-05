import 'package:flutter/material.dart';

class ExpandableListItem extends StatefulWidget {
  @override
  _ExpandableListItemState createState() => _ExpandableListItemState();
}

class _ExpandableListItemState extends State<ExpandableListItem> {
  bool tileIsOpen = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(3),
        border: Border.all(color: Colors.grey[300]),
        color: tileIsOpen ? Colors.grey[300] : Colors.white,
      ),
      child: ExpansionTile(
        title: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('A0001',
                  style: TextStyle(
                      fontSize: 15, color: tileIsOpen ? Colors.white : null)),
              Text('Google Chromecast',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: tileIsOpen ? Colors.white : null)),
            ],
          ),
        ),
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
                border: Border(top: BorderSide(color: Colors.grey[700]))),
            padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 12),
            child: Row(
//                                mainAxisAlignment:
//                                    MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Flexible(
                  child: CircleAvatar(
                    backgroundColor: Colors.blue,
//                                    radius: 30,
                  ),
                ),
                SizedBox(
                  width: 14,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Text(
                          'Google Chromecast',
                          style: TextStyle(fontSize: 14),
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 4),
                          width: 1,
                          height: 14,
                          color: Colors.black54,
                        ),
                        Text(
                          '12 left in stock',
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Row(
                      children: <Widget>[
                        Text(
                          'Item ID: ',
                          style: TextStyle(fontSize: 14),
                        ),
                        Text(
                          '323142213SK',
                          style: TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          )
        ],
        onExpansionChanged: (isOpen) {
          setState(() {
            tileIsOpen = isOpen;
          });
        },
      ),
    );
  }
}
