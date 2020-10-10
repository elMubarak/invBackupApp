import 'package:flutter/material.dart';
import 'package:inventory_app/models/POItem.dart';
import 'package:inventory_app/screens/stock-transfer/IntraTransferLocationSelect.dart';
import 'package:inventory_app/screens/utils/ClearableTextField.dart';
import 'package:inventory_app/screens/utils/CustomOverlay.dart';
import 'package:inventory_app/screens/utils/CustomRaisedButton.dart';
import 'package:inventory_app/screens/utils/ExpandableListItem.dart';
import 'package:inventory_app/utils/app_colors.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:toast/toast.dart';

class IntraTransferScannerScreen extends StatefulWidget {
  const IntraTransferScannerScreen({Key key}) : super(key: key);
  @override
  _IntraTransferScannerScreenState createState() =>
      _IntraTransferScannerScreenState();
}

const flash_on = "FLASH ON";
const flash_off = "FLASH OFF";
const front_camera = "FRONT CAMERA";
const back_camera = "BACK CAMERA";

class _IntraTransferScannerScreenState
    extends State<IntraTransferScannerScreen> {
  var qrText = "";
  var flashState = flash_on;
  var cameraState = front_camera;
  QRViewController _controller;
  bool tileIsOpen = false;
  String itemId;
  String myItemId;

  final _animatedListKey = GlobalKey<AnimatedListState>();

  List<POItem> poList = [
    POItem('001', 'Google Chromecast'),
    POItem('002', 'Google Chromecast'),
    POItem('003', 'Google Chromecast'),
    POItem('004', 'Google Chromecast'),
    POItem('005', 'Google Chromecast'),
    POItem('006', 'Google Chromecast'),
    POItem('007', 'Google Chromecast'),
    POItem('008', 'Google Chromecast'),
  ];

  final itemIdController = TextEditingController();

  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  _IntraTransferScannerScreenState();

  void _onQRViewCreated(QRViewController controller) {
    this._controller = controller;
    controller.scannedDataStream.listen((scanData) {
      _controller.pauseCamera();

      poList.add(POItem(scanData, 'Google Chromecast'));
      _animatedListKey.currentState
          ?.insertItem(0, duration: Duration(milliseconds: 500));

      setState(() {
        qrText = scanData;
        myItemId = scanData;
      });

      Future.delayed(Duration(seconds: 2), () {
        _controller.resumeCamera();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Inter Warehouse - Scan Item'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child:
                  Text('Scan Item', style: Theme.of(context).textTheme.title),
            ),
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: SizedBox(
                width: MediaQuery.of(context).size.width * .6,
                child: Text(
                    "Scan any items within the store that you want to move",
                    style: Theme.of(context).textTheme.subtitle),
              ),
            ),
            SizedBox(height: 30),
            SizedBox(
              height: MediaQuery.of(context).size.height * .4,
              child: InkWell(
                onDoubleTap: () {
                  _controller.toggleFlash();
                },
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
            ),
            1<0? Padding(
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
                        Text('${poList.length} items SCANNED',
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
                      physics: NeverScrollableScrollPhysics(),
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
            ):Container(),
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
                textEditingController: itemIdController,
                label: 'Item ID',
              ),
            ),
            SizedBox(height: 30),
            Center(
                child: CustomRaisedButton(
              onTap: () {
                myItemId=itemIdController.text.toString();
                poList.add(POItem("000123067", 'Google Chromecast'));
                _animatedListKey.currentState
                    ?.insertItem(0, duration: Duration(milliseconds: 500));
                if(itemIdController.text.toString().isEmpty){
                  Toast.show(
                      "Enter Item ID", context,
                      duration: Toast.LENGTH_SHORT,
                      gravity: Toast.BOTTOM);
                }else{
                  Toast.show(
                      "Item Successfully Submitted", context,
                      duration: Toast.LENGTH_SHORT,
                      gravity: Toast.BOTTOM);
                }

              },
              label: 'Submit Item ID',
              type: ButtonType.DeepPurple,
            )),
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
          if(myItemId.isEmpty){
            Toast.show(
                "Enter Item ID", context,
                duration: Toast.LENGTH_SHORT,
                gravity: Toast.BOTTOM);
          }else {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => IntraTransferLocation(myItemId),
              ),
            );
          }
                }
              : null,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
          child: Text(
            'Move Scanned Items to Location',
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
