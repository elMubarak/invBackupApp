import 'dart:convert';
import 'dart:ffi';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:inventory_app/graphQL/network.dart';
import 'package:inventory_app/graphQL/requests.dart';
import 'package:inventory_app/screens/inbound/ScanSuccessScreen.dart';
import 'package:inventory_app/screens/utils/ClearableTextField.dart';
import 'package:inventory_app/screens/utils/CustomOverlay.dart';
import 'package:inventory_app/screens/utils/DialogUtils.dart';
import 'package:inventory_app/utils/Constants.dart';
import 'package:inventory_app/utils/app_colors.dart';
import 'package:inventory_app/utils/links.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:toast/toast.dart';

import 'ViewItemsScreen.dart';

class ScanScreen extends StatefulWidget {
  final dynamic data;

  const ScanScreen({Key key, this.data}) : super(key: key);

  @override
  _ScanScreenState createState() => _ScanScreenState(this.data);
}

const flash_on = "FLASH ON";
const flash_off = "FLASH OFF";
const front_camera = "FRONT CAMERA";
const back_camera = "BACK CAMERA";

class _ScanScreenState extends State<ScanScreen> {
  var qrText = "";
  var flashState = flash_on;
  var cameraState = front_camera;
  QRViewController _controller;
  bool tileIsOpen = false;
  final List<POItem> poList2 = [];
  final _animatedListKey = GlobalKey<AnimatedListState>();

  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  bool showingScanSuccess = false;
  final dynamic data;

  var skuController = TextEditingController();
  var requests = Requests();
  POItem selectedItem;
  var network = Network();

  _ScanScreenState(this.data);

  @override
  void initState() {
    super.initState();
    setState(() {
      print("ITEMS: ${jsonEncode(data['items'])}");
      poList.addAll(data['items']);
    });
  }

  void _onQRViewCreated(QRViewController controller) {
    this._controller = controller;
    controller.scannedDataStream.listen((scanData) {
      _controller.pauseCamera();
      showScanSuccess();

      // poList.add(POItem(scanData, 'Google Chromecast'));
      _animatedListKey.currentState
          ?.insertItem(0, duration: Duration(milliseconds: 500));

      setState(() {
        qrText = scanData;
        var enteredSku = qrText.toString().trim();
        for (POItem item in poList) {
          if (item.sku == enteredSku) {
            selectedItem = item;
            setState(() {
              poList.remove(item);
            });
            break;
          }
        }

        if (selectedItem == null) {
          Toast.show("Item sku not foud in selected list", context);
        } else {
          Toast.show("SKU matched, Please complete process.", context);
          poList2.add(selectedItem);
        }
      });
      Future.delayed(Duration(seconds: 1), () {
        _controller.resumeCamera();
      });
    });
  }

  List<POItem> poList = [];

  @override
  Widget build(BuildContext context) {
    return GraphQLProvider(
      client: network.getClient('Bearer $token'),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Scan Items in P.O'),
        ),
        body: Mutation(
            options: MutationOptions(
              documentNode: gql(
                requests.NewGRN(),
              ),
              update: (Cache cache, QueryResult result) {
                return cache;
              },
              onCompleted: (dynamic result) {
                var data = jsonEncode(result);
                print("On Complete : ${jsonEncode(result)}");
                var newResult = jsonDecode(data);
                var newResult1 = jsonDecode(data);
             var createGoodsReceipt = newResult['createGoodsReceipt'];
             var poNumber = newResult['createGoodsReceipt']['receiptNo'];
             if(createGoodsReceipt!=null){
                                    Navigator.of(context).pop();
//                                _controller.pauseCamera();
                                Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                        builder: (_) => ScanSuccessScreen(poList2.length,poNumber)));

             }
//              setState(() {
//                Constants.contactName =
//                newResult['authenticate']['contactName'];
//              });
//              if (email == null) {
//                Toast.show("Please check credentials", context);
//              } else {
//                Navigator.of(context).pushReplacementNamed('/home');
//              }
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
                      child: Text('Scan Items Into Warehouse',
                          style: Theme.of(context).textTheme.title),
                    ),
                    SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width * .8,
                        child: Text(
                            "Scan the items one after the other to verifiy " +
                                "they match the items in the P.O",
                            style: Theme.of(context).textTheme.body1),
                      ),
                    ),
                    SizedBox(height: 30),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * .4,
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
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(3),
                          border: Border.all(color: Colors.grey[300]),
                          color: showingScanSuccess
                              ? Color(0xFFC7F6E2)
                              : poList.length > 0
                                  ? tileIsOpen
                                      ? Color(0xFF839AB0)
                                      : Colors.white
                                  : Colors.grey[300],
                        ),
                        child: ExpansionTile(
                          title: Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text('${poList.length} items in P.O',
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
                          /*children: <Widget>[
                    AnimatedList(
                      shrinkWrap: true,
                      key: _animatedListKey,
                      itemBuilder: (context, index, animation) {
                        return SlideTransition(
                          position: Tween<Offset>(
                            begin: const Offset(-1, 0),
                            end: Offset.zero,
                          ).animate(animation),
                          child: _buildSinglePoItem(poList[index], index),
                        );
                      },
                      initialItemCount: poList.length,
                    )
                  ],*/
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
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width * .75,
                        child: Text(
                          'You can also manually enter the Item ID',
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    SizedBox(height: 30),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 35.0),
                      child: ClearableTextField(
                        textEditingController: skuController,
                        label: 'Item ID',
                      ),
                    ),
                    SizedBox(height: 30),
                    Center(
                      child: RaisedButton(
                        padding:
                            EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4)),
                        onPressed: () {
                          setState(() {
                            var enteredSku =
                                skuController.text.toString().trim();
                            for (POItem item in poList) {
                              if (item.sku == enteredSku) {
                                selectedItem = item;
                                setState(() {
                                  poList.remove(item);
                                });
                                break;
                              }else{
                                selectedItem=null;
                              }
                            }

                            if (selectedItem == null) {
                              Toast.show("Item sku not foud in selected list",
                                  context);
                            } else {
                              Toast.show(
                                  "SKU matched, Please complete process.",
                                  context);
                              if (poList2.length > 0) {
                                for (int u = 0; u < poList2.length; u++) {
                                  if (selectedItem.sku == poList2[u].sku) {
                                    Toast.show(
                                        "Item ID already Added.", context);
                                    return;
                                  }
                                }
                              }
                              if (poList2.length < poList.length) {
                                poList2.add(selectedItem);
                              }
                            }
                          });
                        },
                        child: Text(
                          'Submit Item ID',
                          style: Theme.of(context)
                              .textTheme
                              .body2
                              .copyWith(color: AppWhite),
                        ),
                      ),
                    ),
                    SizedBox(height: 30),
                    Container(
                      color: Colors.grey[100],
                      width: double.infinity,
                      padding:
                          EdgeInsets.symmetric(vertical: 15, horizontal: 25),
                      child: RaisedButton(
                        padding: EdgeInsets.symmetric(vertical: 16),
                        elevation: 0,
                        color: AppDarkGreen,
                        onPressed: poList.length > 0
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
                                        List<ModelListPo> list = [];
                                        for(int i=0;i<poList2.length;i++){
                                          ModelListPo model= new ModelListPo();
                                          model.qty=poList2[i].qty.toDouble();
                                          model.sku=poList2[i].sku;
                                          model.price=poList2[i].price.toDouble();
                                          model.total=poList2[i].total.toDouble();
                                          list.add(model);
                                        }
                                        var json=jsonEncode(list).replaceAll("\\", "");
                                        var jsOBj=jsonDecode(json);
//                                        var poId=data['POID'];
                                        var andomNumber=generateRandomNumber();
                                        runMutation(
                                            {
                                              "newReceipt": {

                                                "remark": "good",
                                                "warehouseId": 1,
                                                "poNo": ""+data['POID'],
                                                "receiptNo": ""+andomNumber,
                                                "items": jsOBj


                                              }

                                            }
                                        );


//                                dsfgsdg
//                                Navigator.of(context).pop();
////                                _controller.pauseCamera();
//                                Navigator.of(context).pushReplacement(
//                                    MaterialPageRoute(
//                                        builder: (_) => ScanSuccessScreen(poList2.length)));
                                      },
                                      color: Color(0xFF239374),
                                      child: Text('I agree'),
                                      padding: EdgeInsets.symmetric(
                                          vertical: 12, horizontal: 16),
                                    ),
                                  ],
                                  dialogBody: <TextSpan>[
                                    TextSpan(
                                        text: 'Hey ${Constants.contactName},'),
                                    TextSpan(text: '\n\n'),
                                    TextSpan(text: 'You have scanned'),
                                    TextSpan(
                                      text:
                                          ' ${poList2.length} of ${poList.length}',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w700),
                                    ),
                                    TextSpan(text: ' items from the P.O ID.'),
                                    TextSpan(
                                        text: ' This proves you ' +
                                            'have accepted these items.'),
                                    TextSpan(text: '\n\n'),
                                    TextSpan(
                                      text: "" +
                                          ((poList.length) - (poList2.length))
                                              .toString() +
                                          ' Outstanding items',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w700),
                                    ),
                                  ],
                                );
                              }
                            : null,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4)),
                        child: Text(
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
              );
            }),
      ),
    );
  }

  @override
  void dispose() {
    _controller.pauseCamera();
    _controller.dispose();
    super.dispose();
  }

  List<Widget> _buildPoItems(List<POItem> items) {
    return poList
        .map((f) => Container(
              decoration: BoxDecoration(
                  color: AppWhite,
                  border: Border(bottom: BorderSide(color: AppMediumGray))),
              child: ListTile(
                title: Text(f.name.toString(),
                    style: Theme.of(context)
                        .textTheme
                        .body2
                        .copyWith(fontSize: 15)),
                subtitle: Text(f.statusCode,
                    style: Theme.of(context).textTheme.body1),
                trailing: PopupMenuButton(
                  onSelected: (value) {
                    setState(() {
                      poList.remove(f);
                    });
                  },
                  itemBuilder: (_) => <PopupMenuEntry<String>>[
                    const PopupMenuItem(
                      child: Text('Undo Item Scan'),
                      value: 'delete',
                    )
                  ],
                ),
              ),
            ))
        .toList();
  }

  void showScanSuccess() {
    setState(() {
      showingScanSuccess = true;
    });

    Future.delayed(Duration(milliseconds: 1200), () {
      setState(() {
        showingScanSuccess = false;
      });
    });
  }

  Widget _buildSinglePoItem(POItem f, int index) {
    return Container(
      decoration: BoxDecoration(
          color: AppWhite,
          border: Border(bottom: BorderSide(color: AppMediumGray))),
      child: ListTile(
        title: Text(f.name.toString(),
            style: Theme.of(context).textTheme.body2.copyWith(fontSize: 15)),
        subtitle: Text(f.statusCode, style: Theme.of(context).textTheme.body1),
        trailing: PopupMenuButton(
          onSelected: (value) {
            _animatedListKey.currentState.removeItem(index,
                (context, animation) {
              return _buildRemovedItem(index, f);
            }, duration: Duration(seconds: 1));
            setState(() {
              poList.remove(f);
            });
          },
          itemBuilder: (_) => <PopupMenuEntry<String>>[
            const PopupMenuItem(
              child: Text('Undo Item Scan'),
              value: 'delete',
            )
          ],
        ),
      ),
    );
  }

  Card _buildRemovedItem(int index, POItem f) {
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
            poList.insert(index, f);
          });
          _animatedListKey.currentState.insertItem(
            index,
            duration: Duration(milliseconds: 500),
          );
        },
      ),
    );
  }

  generateRandomNumber() {
    var random = new Random();
    return random.nextInt(100000000).toString();
  }
}

class ModelListPo {
  double qty;
  String sku;
  double price;
  double total;

  Map<String, dynamic> toJson() {
    return {

      'sku': this.sku,
      'qty': this.qty,
      'price': this.price,
      'total': this.total,
    };
  }
//  POItem(this.ID, this.title);
//  ModelListPo.fromJson(Map<String, dynamic> json) {
//    price = json['price'];
//    total = json['total'];
//    sku = json['sku'];
//    qty = json['qty'];
//  }
}
