import 'package:flutter/material.dart';
import 'package:inventory_app/models/POItem.dart';
//import 'package:inventory_app/screens/inbound/ScanOutboundItemsScreenSuccessScreen.dart';
import 'package:inventory_app/screens/inbound/ScanSuccessScreen.dart';
import 'package:inventory_app/screens/outbound/ReleaseFormScreen.dart';
import 'package:inventory_app/screens/utils/ClearableTextField.dart';
import 'package:inventory_app/screens/utils/CustomOverlay.dart';
import 'package:inventory_app/screens/utils/DialogUtils.dart';
import 'package:inventory_app/utils/app_colors.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class VendorReturnScanScreen extends StatefulWidget {
  final dynamic locationID;

  const VendorReturnScanScreen({Key key, @required this.locationID})
      : super(key: key);
  @override
  _VendorReturnScanScreenState createState() =>
      _VendorReturnScanScreenState(locationID);
}

const flash_on = "FLASH ON";
const flash_off = "FLASH OFF";
const front_camera = "FRONT CAMERA";
const back_camera = "BACK CAMERA";

class _VendorReturnScanScreenState extends State<VendorReturnScanScreen> {
  var qrText = "";
  var flashState = flash_on;
  var cameraState = front_camera;
  QRViewController _controller;
  bool tileIsOpen = false;

  final _animatedListKey = GlobalKey<AnimatedListState>();

  final dynamic locationID;

  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  _VendorReturnScanScreenState(this.locationID);

  _isFlashOn(String current) {
    return flash_on == current;
  }

  _isBackCamera(String current) {
    return back_camera == current;
  }

  void _onQRViewCreated(QRViewController controller) {
    this._controller = controller;
    controller.scannedDataStream.listen((scanData) {
      _controller.pauseCamera();

      poList.add(POItem(scanData, 'Google Chromecast'));
      _animatedListKey.currentState
          ?.insertItem(0, duration: Duration(milliseconds: 500));

      setState(() {
        qrText = scanData;
      });

      Future.delayed(Duration(seconds: 1), () {
        _controller.resumeCamera();
      });
    });
  }

  List<POItem> poList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Scan Items in GRN'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Text('Scan Items in GRN',
                  style: Theme.of(context).textTheme.title),
            ),
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: SizedBox(
                width: MediaQuery.of(context).size.width * .8,
                child: Text(
                    "Scan the items one after the other to verifiy they match the items in the GRN",
                    style: Theme.of(context).textTheme.body1),
              ),
            ),
            SizedBox(height: 10),
            Center(
              child: Container(
                margin: EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Color(0xFFC7F6E2),
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 50),
                child: Text(
                  "Location ID: 12345SDF12SK",
                  style: TextStyle(color: Color(0xFF146A58), fontSize: 16),
                ),
              ),
            ),
            SizedBox(height: 10),
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
                  color: poList.length > 0
                      ? tileIsOpen ? Color(0xFF839AB0) : Colors.white
                      : Colors.grey[300],
                ),
                child: ExpansionTile(
                  title: Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          '${poList.length}  of ${poList.length} items scanned',
                          style: TextStyle(
                              color: tileIsOpen ? Colors.white : null,
                              fontSize: 15),
                        ),
                        Text(
                          'View',
                          style: TextStyle(
                              color: tileIsOpen ? Colors.white : null,
                              fontSize: 15),
                        ),
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
          onPressed: poList.length > 0
              ? () {
//                  Navigator.of(context).pushNamed('/scanner');
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => ReleaseFormScreen()));
                }
              : null,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
          child: Text(
            'Item Scan Complete',
            style: Theme.of(context).textTheme.body1.copyWith(color: AppWhite),
          ),
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
                title: Text(f.ID,
                    style: Theme.of(context)
                        .textTheme
                        .body2
                        .copyWith(fontSize: 15)),
                subtitle:
                    Text(f.title, style: Theme.of(context).textTheme.body1),
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
        title: Text(f.ID,
            style: Theme.of(context).textTheme.body2.copyWith(fontSize: 15)),
        subtitle: Text(f.title, style: Theme.of(context).textTheme.body1),
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
}
