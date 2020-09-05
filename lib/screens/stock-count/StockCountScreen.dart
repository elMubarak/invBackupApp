import 'package:flutter/material.dart';
import 'package:inventory_app/models/CountCycle.dart';
import 'package:inventory_app/screens/stock-count/StockCountLocationScreen.dart';
import 'package:inventory_app/screens/utils/ClearableTextField.dart';
import 'package:inventory_app/utils/app_colors.dart';
import 'dart:math';

import 'package:shared_preferences/shared_preferences.dart';

class StockCountScreen extends StatefulWidget {
  @override
  _StockCountScreenState createState() => _StockCountScreenState();
}

class _StockCountScreenState extends State<StockCountScreen> {
  var countCycles;
  final cycles = <CountCycle>[
    CountCycle(2, "2 Cycle Counts"),
    CountCycle(3, "3 Cycle Counts"),
    CountCycle(5, "5 Cycle Counts"),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Stock Count')),
      body: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height - 80),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text('Stock Count',
                        style: Theme.of(context).textTheme.title),
                    SizedBox(height: 10),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * .8,
                      child: Text(
                          "Please pick the number of counts before scanning the Location ID.",
                          style: Theme.of(context).textTheme.body1),
                    ),
                    SizedBox(height: 30),
                    Center(
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width * .9,
                        child: Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey[500]),
                              borderRadius: BorderRadius.circular(3)),
                          child: DropdownButton(
                            isExpanded: true,
                            value: countCycles,
                            icon: Icon(Icons.keyboard_arrow_down),
                            style:
                                TextStyle(fontSize: 15, color: Colors.black54),
                            hint: Text('Select the number of cycles'),
                            underline: Container(),
                            items: cycles
                                .map(
                                  (r) => DropdownMenuItem(
                                    child: Text.rich(
                                      TextSpan(
                                        children: <InlineSpan>[
                                          TextSpan(
                                            text: r.count.toString(),
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                          TextSpan(
                                            text: ' ${r.title.substring(2)}',
                                          ),
                                        ],
                                      ),
                                    ),
                                    value: r.count,
                                  ),
                                )
                                .toList(),
                            onChanged: (value) async {
                              print(value);
                              setState(() {
                                countCycles = value;
                              });
                              final prefs =
                                  await SharedPreferences.getInstance();
                              prefs.setInt("countCycles", value);
                              prefs.setInt("currentCycle", 1);
                            },
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Container(
                      width: MediaQuery.of(context).size.width * .7,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(3),
                          color: Color(0xFFF0F4F8)
//                        border: Border.all(color: Colors.grey)
                          ),
                      child: IntrinsicHeight(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
//                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              width: 4,
//                                  height: 20,
                              decoration: BoxDecoration(
                                  color: Color(0xFF5E5CF6),
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(3),
                                      bottomLeft: Radius.circular(3))),
//                            constraints: BoxConstraints.expand(width: 2),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 5),
                              width: MediaQuery.of(context).size.width * .65,
//                              constraints: BoxConstraints.expand(),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  SizedBox(width: 8),
                                  Container(
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Color(0xFFE6E6FE),
                                      ),
                                      padding: EdgeInsets.all(2),
                                      child: Icon(
                                        Icons.info_outline,
                                        color: AppDeepPurple,
                                        size: 16,
                                      )),
                                  SizedBox(width: 8),
                                  Expanded(
                                      child: Text(
                                    'This stands for the number of '
                                    'times you plan to recount the '
                                    'items in a selected store location',
                                    style: TextStyle(
                                        fontSize: 11,
                                        height: 1.4,
                                        color: Color(0xFF0E0F89)),
                                  ))
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    )
//                    SizedBox(height: MediaQuery.of(context).size.height * .1),
                  ],
                ),
              ),
//              Expanded(child: Container()),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        color: Colors.grey[100],
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 15, horizontal: 25),
        child: RaisedButton(
          padding: EdgeInsets.symmetric(vertical: 16),
          elevation: 0,
          color: AppDarkGreen,
          onPressed: countCycles != null
              ? () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (_) =>
                          StockCountLocationScreen(countCycles: countCycles)));
                }
              : null,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
          child: Text(
            'Proceed to Location Scan',
            style: Theme.of(context).textTheme.body1.copyWith(color: AppWhite),
          ),
        ),
      ),
    );
  }
}
