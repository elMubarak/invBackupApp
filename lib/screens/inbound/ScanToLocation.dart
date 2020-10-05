import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/svg.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:inventory_app/graphQL/requests.dart';
import 'package:inventory_app/screens/inbound/PutAwayScreenGrn.dart';
import 'package:inventory_app/screens/utils/ClearableTextField.dart';
import 'package:inventory_app/utils/app_colors.dart';
import 'package:toast/toast.dart';

class ScanToLocationScreen extends StatefulWidget {
  final dynamic locationID;

  const ScanToLocationScreen({Key key, this.locationID}) : super(key: key);
  @override
  _ScanToLocationScreenState createState() =>
      _ScanToLocationScreenState(locationID);
}

class _ScanToLocationScreenState extends State<ScanToLocationScreen> {
  String chosenType = "0";
  final dynamic locationID;
  var requests = Requests();
  ReceiptItem selectedItem;
  final grnController = TextEditingController();

  bool tileIsOpen = false;

  var showLoader = false;

  _ScanToLocationScreenState(this.locationID);

  @override
  Widget build(BuildContext context) {
    print("ITEMS id : ${jsonEncode(locationID['location']['id'])}");
    print("ITEMS2: ${jsonEncode(locationID['data'])}");
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Scan To Location'),
        ),
        body: Mutation(
          options: MutationOptions(
              documentNode: gql(
                requests.addItemToLocation(),
              ),
              update: (Cache cache, QueryResult result) {
                return cache;
              },
              onCompleted: (dynamic result) {
                setState(() {
                  showLoader = false;
                });
                var data = jsonEncode(result);
                print("On Complete : ${jsonEncode(result)}");
                if (result == null) {
                  return;
                }
                var newResult = jsonDecode(data);
                /* Toast.show(
                    "${newResult['addWarehouseLocationItem']['name']} is added to ${locationID['location']['name']}",
                    context);*/
                /* var message =
                    "${newResult['addWarehouseLocationItem']['name']} is added to ${locationID['location']['name']}";*/
                showMessage("Itemm added successfully");
              },
              onError: (error) {
                showMessage(error.toString());
              }),
          builder: (RunMutation runMutation, QueryResult result) {
            /*if (result.hasException) {
              Toast.show(result.exception.toString(), context);
            }*/
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                    minHeight: MediaQuery.of(context).size.height - 80),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text('Scan Items Into Location',
                              style: Theme.of(context).textTheme.title),
                          SizedBox(height: 10),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * .8,
                            child: Text(
                                "Scan the items to be put away into the selected location",
                                style: Theme.of(context).textTheme.body1),
                          ),
                          SizedBox(height: 30),
                          Center(
                            child: Container(
                              decoration: BoxDecoration(
                                color: Color(0xFFC7F6E2),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              padding: EdgeInsets.symmetric(
                                  vertical: 15, horizontal: 50),
                              child: Text(
                                "Location ID: ${locationID["location"]['id']}",
                                style: TextStyle(color: Color(0xFF146A58)),
                              ),
                            ),
                          ),
                          Center(
                            child:
                                SvgPicture.asset('assets/images/scanner.svg'),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 10),
                            child: Center(
                              child: RaisedButton(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(3)),
                                padding: EdgeInsets.symmetric(
                                    vertical: 12, horizontal: 16),
                                onPressed: () {
//                              setState(() {});
                                  Navigator.of(context).pushNamed(
                                      '/location-scan-items',
                                      arguments: {"id": locationID["id"]});
                                },
                                child: Text(
                                  'Scan Items',
                                  style: Theme.of(context)
                                      .textTheme
                                      .body1
                                      .copyWith(color: AppWhite),
                                ),
                              ),
                            ),
                          ),
                          Center(
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width * .7,
                              child: Text(
                                  "You can also manually enter the Item ID",
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context).textTheme.body1),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Center(
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width * .82,
                              child: ClearableTextField(
                                textEditingController: grnController,
                                label: "Item ID",
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 20),
                            child: Center(
                              child: RaisedButton(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(3)),
                                padding: EdgeInsets.symmetric(
                                    vertical: 12, horizontal: 16),
                                onPressed: () {
                                  setState(() {
                                    var enteredSku =
                                        grnController.text.toString().trim();
                                    for (ReceiptItem item
                                        in locationID['data']) {
                                      if (item.sku == enteredSku) {
                                        selectedItem = item;
                                        break;
                                      }
                                    }

                                    if (selectedItem == null) {
                                      Toast.show(
                                          "Item sku not foud in selected list",
                                          context);
                                    } else {
                                      Toast.show(
                                          "SKU matched, Please complete process.",
                                          context);
                                    }
                                  });
                                },
                                child: Text(
                                  'Submit Item ID',
                                  style: Theme.of(context)
                                      .textTheme
                                      .body1
                                      .copyWith(color: AppWhite),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
//              Expanded(child: Container()),
                    Container(
                      color: Colors.grey[100],
                      width: double.infinity,
                      padding:
                          EdgeInsets.symmetric(vertical: 15, horizontal: 25),
                      child: RaisedButton(
                        padding: EdgeInsets.symmetric(vertical: 16),
                        elevation: 0,
                        color: AppDarkGreen,
                        onPressed: () {
                          // Navigator.of(context).pushNamed('/into-location-scanner');
                          if (selectedItem == null) {
                            Toast.show("Please select item first", context);
                            return;
                          }

                          setState(() {
                            showLoader = true;
                          });
                          runMutation(
                            {
                              "item": {
                                "warehouseLocationId": locationID["location"]
                                    ['id'],
                                "sku": selectedItem.sku,
                                "name": selectedItem.name,
                                "qty": selectedItem.qty,
                                "description": selectedItem.description,
                              },
                            },
                          );
                        },
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4)),
                        child: showLoader
                            ? CircularProgressIndicator(
                                backgroundColor: Colors.white,
                              )
                            : Text(
                                'Item Scan Complete',
                                style: Theme.of(context)
                                    .textTheme
                                    .body1
                                    .copyWith(color: AppWhite),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  void showMessage(message) {
    var showLoader = false;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Container(
            color: Colors.white,
            padding: EdgeInsets.all(16),
            child: Text(
              message,
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        );
      },
    );
  }
}
