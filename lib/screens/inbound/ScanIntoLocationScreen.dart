import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:inventory_app/graphQL/network.dart';
import 'package:inventory_app/graphQL/requests.dart';
import 'package:inventory_app/screens/inbound/ScanIntoLocationSuccessScreen.dart';
import 'package:inventory_app/screens/utils/ClearableTextField.dart';
import 'package:inventory_app/screens/utils/CustomOverlay.dart';
import 'package:inventory_app/screens/utils/DialogUtils.dart';
import 'package:inventory_app/utils/app_colors.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

import 'ViewItemsScreen.dart';

class ScanIntoLocationScreen extends StatefulWidget {
  final dynamic locationID;

  const ScanIntoLocationScreen({Key key, this.locationID}) : super(key: key);
  @override
  _ScanIntoLocationScreenState createState() =>
      _ScanIntoLocationScreenState(locationID);
}

const flash_on = "FLASH ON";
const flash_off = "FLASH OFF";
const front_camera = "FRONT CAMERA";
const back_camera = "BACK CAMERA";

class _ScanIntoLocationScreenState extends State<ScanIntoLocationScreen> {
  var qrText = "";
  var flashState = flash_on;
  var cameraState = front_camera;
  QRViewController _controller;
  bool tileIsOpen = false;

  final _animatedListKey = GlobalKey<AnimatedListState>();

  final dynamic locationID;
  var network = Network();
  var requests = Requests();

  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  _ScanIntoLocationScreenState(this.locationID);

  _isFlashOn(String current) {
    return flash_on == current;
  }

  _isBackCamera(String current) {
    return back_camera == current;
  }

  bool showingSuccess = false;

  void _onQRViewCreated(QRViewController controller) {
    this._controller = controller;
    controller.scannedDataStream.listen((scanData) {
      _controller.pauseCamera();

      setState(() {
        showingSuccess = true;
      });

      // poList.add(POItem(scanData, 'Google Chromecast'));
      _animatedListKey.currentState
          ?.insertItem(0, duration: Duration(milliseconds: 500));

      setState(() {
        qrText = scanData;
      });

      Future.delayed(Duration(seconds: 1), () {
        _controller.resumeCamera();
        showingSuccess = false;
      });
    });
  }

  List<POItem> poList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Scan Into Location'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Text('Scan Items Into Location',
                  style: Theme.of(context).textTheme.title),
            ),
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: SizedBox(
                width: MediaQuery.of(context).size.width * .8,
                child: Text(
                    "Scan the items to be put away into the selected location",
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
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(3),
                  border: Border.all(color: Colors.grey[300]),
                  color: showingSuccess
                      ? Color(0xFFC7F6E2)
                      : poList.length > 0
                          ? tileIsOpen ? Color(0xFF839AB0) : Colors.white
                          : Colors.grey[300],
                ),
                child: ExpansionTile(
                  title: Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text('${poList.length} items in P.O',
                            style: TextStyle(
                                color: tileIsOpen ? Colors.white : null)),
                        Text('View',
                            style: TextStyle(
                                color: tileIsOpen ? Colors.white : null)),
                      ],
                    ),
                  ),
//                  children: _buildPoItems(poList),
                  children: <Widget>[
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
                textEditingController: TextEditingController(),
                label: 'Item ID',
              ),
            ),
            SizedBox(height: 30),
            Center(
              child: RaisedButton(
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4)),
                onPressed: () {},
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
              padding: EdgeInsets.symmetric(vertical: 15, horizontal: 25),
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
                                Navigator.of(context).pop();
//                                _controller.pauseCamera();
                                Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                        builder: (_) =>
                                            ScanIntoLocationSuccessScreen(
                                              locationID: locationID["id"],
                                            )));
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
                              text: ' ${poList.length}',
                              style: TextStyle(fontWeight: FontWeight.w700),
                            ),
                            TextSpan(text: ' items into Location ID: '),
                            TextSpan(
                                text: '${locationID["id"]}.',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            TextSpan(
                                text:
                                    ' This proves the items were handled by you.'),
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
              'poVar': {'poNo': "number here"},
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
              poList.add(item);
            }
            Navigator.of(context).pop();
            return Container();
          },
        );
      },
    );
  }
}
