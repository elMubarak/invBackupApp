import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:inventory_app/graphQL/network.dart';
import 'package:inventory_app/graphQL/requests.dart';
import 'package:inventory_app/models/POItem.dart';
import 'package:inventory_app/screens/stock-count/CountSuccessScreen.dart';
import 'package:inventory_app/screens/utils/ClearableTextField.dart';
import 'package:inventory_app/screens/utils/CustomOverlay.dart';
import 'package:inventory_app/screens/utils/DialogUtils.dart';
import 'package:inventory_app/utils/app_colors.dart';
import 'package:inventory_app/utils/links.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';

import 'ItemModel.dart';

class CountScannerScreen extends StatefulWidget {
  int countCycles = 0;
  String locationId = "";
  List<ItemModel> items;
  CountScannerScreen(int countCycles, String locationId, items) {
    this.countCycles = countCycles;
    this.locationId = locationId;
    this.items=items;
  }


  @override
  _CountScannerScreenState createState() => _CountScannerScreenState();
}

class _CountScannerScreenState extends State<CountScannerScreen> {
  int cycles;
  int currentCycle;
  QRViewController _controller;
  bool tileIsOpen = false;
  var qrText = "";
  int itemsCount = 0;
  int shown = 0;
  List<ItemModel> temp=List();
//  List<POItem> poList = [
//    POItem('001', 'Google Chromecast'),
//    POItem('002', 'Google Chromecast'),
//    POItem('003', 'Google Chromecast'),
//    POItem('004', 'Google Chromecast'),
//    POItem('005', 'Google Chromecast'),
//    POItem('006', 'Google Chromecast'),
//    POItem('007', 'Google Chromecast'),
//    POItem('008', 'Google Chromecast'),
//  ];
  var network = Network();
  var requests = Requests();
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  final _animatedListKey = GlobalKey<AnimatedListState>();
  var _controllerItem = TextEditingController();

  @override
  void initState() {
    super.initState();
    initCycles();
  }

  void initCycles() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      cycles = prefs.getInt("countCycles") ?? 2;
      currentCycle = prefs.getInt("currentCycle") ?? 0;
    });
  }

  void _onQRViewCreated(QRViewController controller) {
    this._controller = controller;
    controller.scannedDataStream.listen((scanData) {
      _controller.pauseCamera();

      setState(() {
        qrText = scanData;
        itemsCount = itemsCount < widget.items.length ? itemsCount + 1 : itemsCount;
      });

      Future.delayed(Duration(milliseconds: 1500), () {
        _controller.resumeCamera();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return GraphQLProvider(
      client: network.getClient('Bearer $token'), child: Scaffold(
      appBar: AppBar(title: Text('Count')),
      body: Mutation(
        options: MutationOptions(
          documentNode: gql(
            requests.countStock(),
          ),
          update: (Cache cache, QueryResult result) {
            return cache;
          },
          onCompleted: (dynamic result) {
            var data = jsonEncode(result);
            print("On Complete countStock : ${jsonEncode(result)}");
            var newResult = jsonDecode(data);

            _controllerItem.clear();
            // shown==0?showAlertDialog( context):Container();

//
            if (currentCycle >= cycles) {
              Navigator.of(context).pushReplacementNamed('/home');
            } else {
              Toast.show(_controllerItem.text.toString()+' in Location ID ${widget.locationId} is successful.', context);

            }
          },
        ),
        builder: (RunMutation runMutation, QueryResult result) {
          if (result.hasException) {
            Toast.show("Please check network connection", context);
          }
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(height: 30),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Text('Stock count cycle $currentCycle of $cycles.',
                      style: Theme
                          .of(context)
                          .textTheme
                          .title),
                ),
                SizedBox(height: 30),
                SizedBox(
                  height: MediaQuery
                      .of(context)
                      .size
                      .height * .4,
                  child: QRView(
                    key: qrKey,
                    onQRViewCreated: _onQRViewCreated,
                    overlay: CustomOverlay(
                      borderColor: Colors.yellow,
                      borderRadius: 10,
                      borderLength: 30,
                      borderWidth: 10,
                      cutOutSize: 250,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(3),
                      border: Border.all(color: Colors.grey[300]),
                      color: widget.items.length > 0
                          ? tileIsOpen ? Color(0xFF839AB0) : Colors.white
                          : Colors.grey[300],
                    ),
                    child: ExpansionTile(
                      title: Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text.rich(
                              TextSpan(
                                children: <InlineSpan>[
                                  TextSpan(
                                    text: '${widget.items.length}',
                                    style: Theme
                                        .of(context)
                                        .textTheme
                                        .caption
                                        .copyWith(
                                        color: tileIsOpen ? Colors.white : null,
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  TextSpan(
                                      text: ' items in this location.',
                                      style: Theme
                                          .of(context)
                                          .textTheme
                                          .caption
                                          .copyWith(
                                        fontSize: 14,
                                        color: tileIsOpen ? Colors.white : null,
                                      ))
                                ],
                              ),
                            ),
                            Text('View',
                                style: Theme
                                    .of(context)
                                    .textTheme
                                    .caption
                                    .copyWith(
                                    color: tileIsOpen ? Colors.white : null,
                                    fontSize: 14)),
                          ],
                        ),
                      ),
//                  children: _buildPoItems(poList),
                      children: <Widget>[
                        AnimatedList(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          key: _animatedListKey,
                          itemBuilder: (context, index, animation) {
                            return SlideTransition(
                              position: Tween<Offset>(
                                begin: const Offset(-1, 0),
                                end: Offset.zero,
                              ).animate(animation),
                              child: _buildSinglePoItem(widget.items[index], index),
                            );
                          },
                          initialItemCount: widget.items.length,
                        )
                      ],
                      onExpansionChanged: (isOpen) {
                        setState(() {
                          tileIsOpen = isOpen;
                        });
                      },
                    ),
                  ),
                ),
                SizedBox(height: 25),
                Center(
                  child: Text(
                    itemsCount.toString(),
                    style: Theme
                        .of(context)
                        .textTheme
                        .body1
                        .copyWith(fontSize: 30, fontWeight: FontWeight.w700),
                  ),
                ),
                SizedBox(height: 25),
                Center(
                  child: SizedBox(
                    width: MediaQuery
                        .of(context)
                        .size
                        .width * .75,
                    child: Text(
                      'You can also manually enter the Item ID',
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                SizedBox(height: 30),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 35.0),
                  child: TextField(
                    controller: _controllerItem,
                    decoration: InputDecoration(
                      hintText: "Item ID",
                      suffixIcon: IconButton(
                        onPressed: () => _controllerItem.clear(),
                        icon: Icon(Icons.clear),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 30),
                Center(
                  child: RaisedButton(
                    padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4)),
                    onPressed: () {
                      if(temp.length>0){
                        temp.clear();
                      }
                      var exist=0;
                      for(int i=0;i<widget.items.length;i++){
                        if(_controllerItem.text.toString()==widget.items[i].id){
                          exist=1;
                          temp.add(widget.items[i]);
                        }
                      }
                      if(exist==0){
                        Toast.show("Item ID does not exist.", context);
                        return;
                      }
                      if (currentCycle < cycles) {
                        setState(() {
                          currentCycle++;
                          itemsCount=temp.length;
                        });

                      }
                      _controllerItem.clear();

                    },
                    child: Text(
                      'Submit Item ID',
                      style: Theme
                          .of(context)
                          .textTheme
                          .body2
                          .copyWith(color: AppWhite),
                    ),
                  ),
                ),
                SizedBox(height: 30),

              ],
            ),
          );
        },
      ),
      bottomNavigationBar: Mutation(
          options: MutationOptions(
            documentNode: gql(
              requests.countStock(),
            ),
            update: (Cache cache, QueryResult result) {
              return cache;
            },
            onCompleted: (dynamic result) {
              var data = jsonEncode(result);
              print("On Complete countStock : ${jsonEncode(result)}");
              var newResult = jsonDecode(data);

              _controllerItem.clear();
              // shown==0?showAlertDialog( context):Container();

//
//              if (currentCycle >= cycles) {
//                Navigator.of(context).pushReplacementNamed('/home');
//              } else {
//                Toast.show(_controllerItem.text.toString()+' in Location ID ${widget.locationId} is successful.', context);
//
//              }
            },
          ),
          builder: (RunMutation runMutation, QueryResult result) {
            if (result.hasException) {
              Toast.show("Please check network connection", context);
            }
            return Container(
        color: Colors.grey[100],
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 15, horizontal: 25),
        child: RaisedButton(
          padding: EdgeInsets.symmetric(vertical: 16),
          elevation: 0,
          color: AppDarkGreen,
          onPressed: widget.items.length > 0
              ? () {
//                  Navigator.of(context).pushNamed('/scanner');
            DialogUtils.showCustomDialog(
              context: context,
              actions: <Widget>[
                RaisedButton(
                  color: Color(0xFFE6E6FE),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    'Keep Scanning',
                    style: TextStyle(
                      color: Color(0xFF3732E2),
                    ),
                  ),
                  padding: EdgeInsets.symmetric(
                      vertical: 12, horizontal: 16),
                ),
                RaisedButton(
                  onPressed: () {
                    runMutation(
                          {
                            "filter": {
                              "warehouseLocationId": int.parse(
                                  widget.locationId),
                              "sku": _controllerItem.text.toString(),
                              "qty": widget.countCycles
                            }
                          }
                      );
                    Navigator.of(context).pop();
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (_) =>
                            CountSuccessScreen(
                              countDetails: {
                                'total': widget.items.length,
                                'counted': itemsCount,
                                'locationId': widget.locationId,
                                'items': widget.items,
                              },
                            ),
                      ),
                    );
                  },
                  color: Color(0xFF239374),
                  child: Text('I agree'),
                  padding: EdgeInsets.symmetric(
                      vertical: 12, horizontal: 16),
                ),
              ],
              dialogBody: <TextSpan>[
                TextSpan(text: 'Hey Abayomi,'),
                TextSpan(text: '\n\n'),
                TextSpan(text: 'You have scanned'),
                TextSpan(
                  text: ' $itemsCount',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                TextSpan(text: ' items in Location ID: '),
                TextSpan(
                  text: widget.locationId.toString(),
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                TextSpan(
                    text:
                    ' This proves the items were counted by you.'),
              ],
            );
          }
              : null,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4)),
          child: Text(
            'Stock Count Complete',
            style: Theme
                .of(context)
                .textTheme
                .body1
                .copyWith(color: AppWhite),
          ),
        ),
      );})),
    );
  }

  Widget _buildSinglePoItem(ItemModel f, int index) {
    return Container(
      decoration: BoxDecoration(
          color: AppWhite,
          border: Border(bottom: BorderSide(color: AppMediumGray))),
      child: ListTile(
        title: Text(f.name,
            style: Theme
                .of(context)
                .textTheme
                .body2
                .copyWith(fontSize: 15)),
        subtitle: Text(f.description, style: Theme
            .of(context)
            .textTheme
            .body1
            .copyWith(fontSize: 12)),
        trailing:Container(child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text('Sku: ${f.sku}', style: Theme
                  .of(context)
                  .textTheme
                  .body1
                  .copyWith(fontSize: 12)),
              Text('Qty: ${f.qty}', style: Theme
                  .of(context)
                  .textTheme
                  .body1
                  .copyWith(fontSize: 12)),
            ],
          ),
          PopupMenuButton(
            onSelected: (value) {
              _animatedListKey.currentState.removeItem(index,
                      (context, animation) {
                    return _buildRemovedItem(index, f);
                  }, duration: Duration(seconds: 1));
              setState(() {
                widget.items.remove(f);
              });
            },
            itemBuilder: (_) =>
            <PopupMenuEntry<String>>[
              const PopupMenuItem(
                child: Text('Undo Item Scan'),
                value: 'delete',
              )
            ],
          ),
        ],),)
      ),
    );
  }

  Card _buildRemovedItem(int index, ItemModel f) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      color: Color(0xFF253B52),
      elevation: 10,
      child: ListTile(
        leading: Text('Removed'),
        trailing: Text(
          'Restore Item',
          style: TextStyle(color: Color(0xFF91ECC8)),
        ),
        onTap: () {
          setState(() {
            widget.items.insert(index, f);
          });
          _animatedListKey.currentState.insertItem(
            index,
            duration: Duration(milliseconds: 500),
          );
        },
      ),
    );
  }

  void showAlertDialog(BuildContext context) {
    setState(() {
      shown=1;
    });
    Widget okButton = FlatButton(
      child: Text("OK"),
      onPressed: () { },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("My title"),
      content: Text(_controllerItem.text.toString()+' in Location ID ${widget.locationId} is successful.'),
      actions: [
        okButton,
      ],
    );

    // show the dialog
     showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
