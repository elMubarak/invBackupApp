import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:inventory_app/graphQL/requests.dart';
import 'package:inventory_app/models/WarehouseLocation.dart';
import 'package:inventory_app/screens/stock-transfer/IntraTransferSuccess.dart';
import 'package:inventory_app/utils/app_colors.dart';
import 'package:toast/toast.dart';

class IntraTransferLocation extends StatefulWidget {
  String myItemId="";
  IntraTransferLocation(String myItemId){
    this.myItemId=myItemId;
  }

  @override
  _IntraTransferLocationState createState() => _IntraTransferLocationState();
}

class _IntraTransferLocationState extends State<IntraTransferLocation> {
  String locationID;
//  final locations = <WarehouseLocation>[
//    WarehouseLocation('2', "Mainland Warehouse - Lagos"),
//    WarehouseLocation('3', "Apapa Warehouse - Lagos"),
//    WarehouseLocation('5', "Mile12 Warehouse - Lagos"),
//  ];
  var requests = Requests();
  final List<Data> poList = [];
  @override
  Widget build(BuildContext context) {
    return Query(
      options: QueryOptions(
        documentNode: gql(
          requests.getLocation(),
        ),
        variables: {
          'filter': {'warehouseId':double.parse(widget.myItemId)},
        },
      ),
      builder: (QueryResult result,
          {VoidCallback refetch, FetchMore fetchMore}) {
        if (result.hasException) {
          print("Exception:: ${result.exception.toString()}");

        }
        try {
          var data2 = result.data['warehouseLocations'];
          var receipt = jsonEncode(data2);
          var jsonReceipt = jsonDecode(receipt);
          print("Result: $receipt");
          poList.clear();
          if (jsonReceipt['data'].length == 0) {
            Toast.show(
                "No Location found in Item ID " + widget.myItemId, context,
                duration: Toast.LENGTH_SHORT,
                gravity: Toast.BOTTOM);
          }
          for (int i = 0; i < jsonReceipt['data'].length; i++) {
            Data item = Data.fromJson(jsonReceipt['data'][i]);
            poList.add(item);
          }
        }catch(Exception){

        }
        return Scaffold(
          appBar: AppBar(title: Text('Stock Transfer - Select Location')),
          body: Stack(children: [
            SingleChildScrollView(
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
                          items: poList
                              .map(
                                (r) => DropdownMenuItem(
                              child: Text(r.name),
                              value: r.name,
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

            result.loading? AlertDialog(
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  CircularProgressIndicator(),
                  Container(
                    height: 16,
                  ),
                  Center(
                    child: Text(
                      'Loading data, Please wait...',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ):Container()
          ],),
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
                    location: poList
                        .firstWhere((l) => l.name == locationID)
                        .name,
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


        // it can be either Map or List
        //  print("Response: ${jsonEncode(result.data)}");
       // var data = result.data['data'];

        //Navigator.of(context).pop();

      },
    );

  }
}
class Data {

  String name;


//  POItem(this.ID, this.title);
  Data.fromJson(Map<String, dynamic> json) {
    name = json['name'];
  }
}