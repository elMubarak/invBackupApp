import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/svg.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:inventory_app/graphQL/requests.dart';
import 'package:inventory_app/screens/stock-count/CountScannerScreen.dart';
import 'package:inventory_app/screens/stock-count/StockCountLocationScannerScreen.dart';
import 'package:inventory_app/screens/utils/ClearableTextField.dart';
import 'package:inventory_app/utils/app_colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';

import 'ItemModel.dart';

class StockCountLocationScreen extends StatefulWidget {
  final int countCycles;

  const StockCountLocationScreen({Key key, this.countCycles}) : super(key: key);
  @override
  _StockCountLocationScreenState createState() =>
      _StockCountLocationScreenState(countCycles);
}

class _StockCountLocationScreenState extends State<StockCountLocationScreen> {
  String chosenType = "0";
  final grnController = TextEditingController();
  var requests = Requests();
  bool tileIsOpen = false;

  final int countCycles;
  int cycles;

  _StockCountLocationScreenState(this.countCycles);

  @override
  void initState() {
    super.initState();
    initCycles();
  }

  void initCycles() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      cycles = prefs.getInt("countCycles") ?? 2;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Stock Count'),
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
                      Text('Scan Location',
                          style: Theme.of(context).textTheme.title),
                      SizedBox(height: 10),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * .8,
                        child: Text(
                            "You have selected $cycles cycle counts."
                            " Scan the store location to begin the count.",
                            style: Theme.of(context).textTheme.subtitle),
                      ),
                      SizedBox(height: 30),
                      Center(
                        child: SvgPicture.asset(
                            'assets/images/put-away-barcode.svg'),
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
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) =>
                                      StockCountLocationScannerScreen(),
                                ),
                              );
                            },
                            child: Text(
                              'Scan Location',
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
                              "You can also manually enter the Location ID",
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
                            label: "Location ID",
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
                  padding: EdgeInsets.symmetric(vertical: 15, horizontal: 25),
                  child: RaisedButton(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    elevation: 0,
                    color: AppDarkGreen,
                    onPressed: () {
                      if (grnController.text.isEmpty) {
                        Toast.show("Enter location ID", context);
                        return;
                      }
                      showLoadingDialog();
//                      Navigator.of(context).push(MaterialPageRoute(
//                          builder: (_) => CountScannerScreen()));
                    },
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4)),
                    child: Text(
                      'Submit Location ID',
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
        ),
      ),
    );
  }

  void showLoadingDialog() {
    var showLoader = false;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Query(
          options: QueryOptions(
            documentNode: gql(
              requests.getWarehouseLocation(),
            ),
            variables: {
              'filter': {'id': int.parse(grnController.text.toString())},
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
                    'Error in getting data',
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
            var data = result.data['warehouseLocations'];
            var data2 = result.data['warehouseLocations']['data'];
            var receipt = jsonEncode(data);
            var jsonReceipt = jsonDecode(receipt);
            var receipt2 = jsonEncode(data2[0]['items']);
            var jsonReceipt2 = jsonDecode(receipt2);
            print("Result: $receipt");
            var locations = jsonReceipt['data'];

            List<ItemModel> temp4 = [];
            for (int i = 0; i < jsonReceipt2.length; i++) {
              ItemModel result = ItemModel(jsonReceipt2[i]);
              temp4.add(result);
            }
            // ItemModel.fromJson(json.decode(locations));
            if (locations.length == 0) {
              return AlertDialog(
                content: Container(
                  color: Colors.white,
                  padding: EdgeInsets.all(16),
                  child: Text(
                    'Location ID not found',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              );
            }

            // result success
            // Navigator.of(context).pop();
//            Navigator.of(context).pushNamed('/location-scan-entry',
//                arguments: {"location": locations[0]});
            Future.delayed(Duration.zero, () {
              Navigator.of(context).pop();
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (_) => CountScannerScreen(widget.countCycles,
                      grnController.text.toString(), temp4)));
            });

            return Container();
          },
        );
      },
    );
  }
}
