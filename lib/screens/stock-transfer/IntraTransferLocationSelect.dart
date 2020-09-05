import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:inventory_app/models/WarehouseLocation.dart';
import 'package:inventory_app/screens/stock-transfer/IntraTransferSuccess.dart';
import 'package:inventory_app/utils/app_colors.dart';

class IntraTransferLocation extends StatefulWidget {
  @override
  _IntraTransferLocationState createState() => _IntraTransferLocationState();
}

class _IntraTransferLocationState extends State<IntraTransferLocation> {
  String locationID;
  final locations = <WarehouseLocation>[
    WarehouseLocation('2', "Mainland Warehouse - Lagos"),
    WarehouseLocation('3', "Apapa Warehouse - Lagos"),
    WarehouseLocation('5', "Mile12 Warehouse - Lagos"),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Stock Transfer - Select Location')),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Text('Select Location',
                  style: Theme.of(context).textTheme.title),
            ),
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: SizedBox(
                width: MediaQuery.of(context).size.width * .6,
                child: Text("Select the location you want to move the items to",
                    style: Theme.of(context).textTheme.subtitle),
              ),
            ),
            SizedBox(height: 30),
            Center(
              child:
                  SvgPicture.asset('assets/images/stock-transfer-trimmed.svg'),
            ),
            SizedBox(height: 30),
            Center(
              child: SizedBox(
                width: MediaQuery.of(context).size.width * .9,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey[500]),
                      borderRadius: BorderRadius.circular(3)),
                  child: DropdownButton(
                    isExpanded: true,
                    value: locationID,
                    icon: Icon(Icons.keyboard_arrow_down),
                    style: TextStyle(fontSize: 15, color: Colors.black54),
                    hint: Text('Select location'),
                    underline: Container(),
                    items: locations
                        .map(
                          (r) => DropdownMenuItem(
                            child: Text(r.title),
                            value: r.locationID,
                          ),
                        )
                        .toList(),
                    onChanged: (value) async {
                      print(value);
                      setState(() {
                        locationID = value;
                      });
                    },
                  ),
                ),
              ),
            ),
            SizedBox(height: 10),
          ],
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
          onPressed: locationID != null
              ? () {
//                  Navigator.of(context).pushNamed('/scanner');
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => IntraTransferSuccessScreen(
                        location: locations
                            .firstWhere((l) => l.locationID == locationID)
                            .title,
                      ),
                    ),
                  );
                }
              : null,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
          child: Text(
            'Submit Location',
            style: Theme.of(context).textTheme.body1.copyWith(color: AppWhite),
          ),
        ),
      ),
    );
  }
}
