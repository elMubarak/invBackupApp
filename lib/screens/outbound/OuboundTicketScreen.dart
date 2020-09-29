import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:inventory_app/graphQL/requests.dart';
import 'package:inventory_app/screens/utils/ClearableTextField.dart';
import 'package:inventory_app/screens/utils/ExpandableListItem.dart';
import 'package:inventory_app/screens/utils/ScreenActionButton.dart';
import 'package:inventory_app/utils/app_colors.dart';
import 'package:toast/toast.dart';

class OutboundTicketScreen extends StatefulWidget {
  @override
  _OutboundTicketScreenState createState() => _OutboundTicketScreenState();
}

class _OutboundTicketScreenState extends State<OutboundTicketScreen> {
  final poIdController = TextEditingController();

  final List<ReceiptItem> poList = [];

  bool tileIsOpen = false;
  var locationID = '1249ABCDS12K';
  var requests = Requests();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Outbound - Pick Ticket ID'),
        ),
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
                      Text('Pick Ticket ID',
                          style: Theme.of(context).textTheme.title),
                      SizedBox(height: 10),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * .8,
                        child: Text(
                            "To carry out the outbound process please enter the pick ticket ID",
                            style: Theme.of(context).textTheme.body1),
                      ),
                      SizedBox(height: 30),
                      Center(
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width * .82,
                          child: ClearableTextField(
                            textEditingController: poIdController,
                            label: "Pick Ticket ID",
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 30),
                        child: Center(
                          child: RaisedButton(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(3)),
                            padding: EdgeInsets.symmetric(
                                vertical: 12, horizontal: 16),
                            onPressed: () {
                              poList.clear();
                              if (poIdController.text.isEmpty) {
                                Toast.show(
                                    "Enter Ticket ID", context);
                              } else {
                                showLoadingDialog();
                              }
                            },
                            child: Text(
                              'Submit ID',
                              style: Theme.of(context)
                                  .textTheme
                                  .body1
                                  .copyWith(color: AppWhite),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(3),
                          border: Border.all(color: Colors.grey[300]),
                          color: poList.length > 0
                              ? tileIsOpen ? Color(0xFF839AB0) : Colors.white
                              : Colors.grey[300],
                        ),
                        child: ExpansionTile(
                          title: Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text('${poList.length} items in Ticket Id',
                                    style: TextStyle(
                                        color:
                                        tileIsOpen ? Colors.white : null)),
                                Text('View',
                                    style: TextStyle(
                                        color:
                                        tileIsOpen ? Colors.white : null)),
                              ],
                            ),
                          ),
                          children: _buildPoItems(poList),
                          onExpansionChanged: (isOpen) {
                            setState(() {
                              tileIsOpen = isOpen;
                            });
                          },
                        ),
                      ),
//                      AnimatedOpacity(
//                        opacity: tileIsOpen ? 1.0 : 0.0,
//                        duration: Duration(milliseconds: 300),
//                        child: Column(
//                          children: <Widget>[
//                            Text(
//                              '3 items in ticket',
//                              style: TextStyle(
//                                  fontSize: 24, fontWeight: FontWeight.bold),
//                            ),
//                            Container(
//                              decoration: BoxDecoration(
//                                color: Color(0xFFC7F6E2),
//                                borderRadius: BorderRadius.circular(8),
//                              ),
//                              padding: EdgeInsets.symmetric(
//                                  vertical: 10, horizontal: 5),
//                              child: Text(
//                                "Items Location ID: $locationID",
//                                style: TextStyle(
//                                    color: Color(0xFF146A58), fontSize: 14),
//                              ),
//                            ),
//                            SizedBox(height: 20),
//                            ListView.separated(
//                                physics: NeverScrollableScrollPhysics(),
//                                shrinkWrap: true,
//                                itemBuilder: (context, int) =>
//                                    ExpandableListItem(),
//                                separatorBuilder: (c, i) {
//                                  return SizedBox(
//                                    height: 20,
//                                  );
//                                },
//                                itemCount: 3)
//                          ],
//                        ),
//                      )
                    ],
                  ),
                ),
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
            onPressed: tileIsOpen ? () {
              Navigator.of(context).pushNamed('/outbound-location-scan');
            } : null,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
            child: Text(
              'Proceed to pick items',
              style:
                  Theme.of(context).textTheme.body1.copyWith(color: AppWhite),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildPoItems(List<ReceiptItem> items) {
    return items
        .map((f) => Container(
      decoration: BoxDecoration(
          color: AppWhite,
          border: Border(bottom: BorderSide(color: AppMediumGray))),
      child: ListTile(
        title: Text(
          "Name: ${f.name}",
          /*style:
                      Theme.of(context).textTheme.body2.copyWith(fontSize: 15),*/
        ),
        subtitle: Text(
          f.description == null
              ? "Desc : NA"
              : "Desc: ${f.description}",
          //style: Theme.of(context).textTheme.body1,
        ),
        trailing: Column(
          children: <Widget>[
            Text('Sku: ${f.sku}'),
            Text('Qty: ${f.qty}'),
          ],
        ),
      ),
    ))
        .toList();
  }

  void showLoadingDialog() {
    var showLoader = false;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Query(
          options: QueryOptions(
            documentNode: gql(
              requests.getGrns(),
            ),
            variables: {
              'filter': {'receiptNo': poIdController.text.toString()},
            },
          ),
          builder: (QueryResult result,
              {VoidCallback refetch, FetchMore fetchMore}) {
            if (result.hasException) {
              print("Exception:: ${result.exception.toString()}");
              return AlertDialog(
                content: Container(
                  color: Colors.white,
                  padding: EdgeInsets.all(16),
                  child: Text(
                    'Purchase order ID not found',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              );
            }

            if (result.loading) {
              return AlertDialog(
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
              );
            }

            // it can be either Map or List
            //  print("Response: ${jsonEncode(result.data)}");
            var data = result.data['goodsReceipts'];
            var receipt = jsonEncode(data);
            var jsonReceipt = jsonDecode(receipt);
            print("Result: $receipt");
            poList.clear();
            for (int i = 0; i < jsonReceipt['data'].length; i++) {
              POItem item = POItem.fromJson(jsonReceipt['data'][i]);
              poList.addAll(item.items);
            }
            Navigator.of(context).pop();
            return Container();
          },
        );
      },
    );
  }
}

class POItem {
  String poNo;
  List<ReceiptItem> items = List();

//  POItem(this.ID, this.title);
  POItem.fromJson(Map<String, dynamic> json) {
    poNo = json['poNo'];
    var arr = json['items'];
    for (int i = 0; i < arr.length; i++) {
      ReceiptItem item = ReceiptItem.fromJson(arr[i]);
      items.add(item);
    }
  }
}

class ReceiptItem {
  int id;
  String name;
  String sku;
  int qty;
  String description;

//  POItem(this.ID, this.title);
  ReceiptItem.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    sku = json['sku'];
    qty = json['qty'];
  }
}
