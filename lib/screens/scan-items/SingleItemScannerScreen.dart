import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:inventory_app/screens/utils/ClearableTextField.dart';
import 'package:inventory_app/screens/utils/CustomOverlay.dart';
import 'package:inventory_app/screens/utils/CustomRaisedButton.dart';
import 'package:inventory_app/screens/utils/ExpandableListItem.dart';
import 'package:inventory_app/utils/app_colors.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class SingleItemScannerScreen extends StatefulWidget {
  final String itemIdFromPrevious;

  const SingleItemScannerScreen({Key key, this.itemIdFromPrevious})
      : super(key: key);
  @override
  _SingleItemScannerScreenState createState() =>
      _SingleItemScannerScreenState(itemIdFromPrevious);
}

const flash_on = "FLASH ON";
const flash_off = "FLASH OFF";
const front_camera = "FRONT CAMERA";
const back_camera = "BACK CAMERA";

class _SingleItemScannerScreenState extends State<SingleItemScannerScreen>
    with SingleTickerProviderStateMixin {
  final String itemIdFromPrevious;

  var qrText = "";
  var flashState = flash_on;
  var cameraState = front_camera;
  QRViewController _controller;
  bool tileIsOpen = false;
  String itemId;

  bool showingToast = false;

  AnimationController anim;

  Animation fade;

  final itemIdController = TextEditingController();
  @override
  void initState() {
    super.initState();

    anim = AnimationController(
        animationBehavior: AnimationBehavior.normal,
        vsync: this,
        reverseDuration: Duration(milliseconds: 1000),
        duration: Duration(milliseconds: 1000));
    fade = Tween(begin: 0, end: 1).animate(anim);

    fade.addListener(() {
      if (fade.isCompleted) {
        anim.reset();
      }
    });

    itemId = itemIdFromPrevious ?? "";
  }

  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  _SingleItemScannerScreenState(this.itemIdFromPrevious);

  void _onQRViewCreated(QRViewController controller) {
    this._controller = controller;
    controller.scannedDataStream.listen((scanData) {
      _controller.pauseCamera();

      setState(() {
        qrText = scanData;
        itemId = scanData;
        showToast();
      });

      Future.delayed(Duration(seconds: 1), () {
        _controller.resumeCamera();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Scan Item'),
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
                    "Scan any item within the store to view its details",
                    style: Theme.of(context).textTheme.body2),
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
            Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: Center(
                child: Visibility(
                  visible: showingToast,
                  child: FadeTransition(
                    opacity: anim,
                    child: Container(
                      margin: EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: Color(0xFFC7F6E2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 50),
                      child: Text(
                        "Scan Success",
                        style:
                            TextStyle(color: Color(0xFF146A58), fontSize: 16),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Visibility(
//              opacity: itemId.isEmpty ? 0 : 1,
//              duration: Duration(milliseconds: 300),
              maintainAnimation: true,
              maintainState: true,
              visible: itemId.isNotEmpty,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(3),
                    border: Border.all(color: Colors.grey[300]),

                  ),
                  child: ExpandableListItem(),
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
                textEditingController: itemIdController,
                label: 'Item ID',
              ),
            ),
            SizedBox(height: 30),
            Center(
              child: RaisedButton(
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4)),
                onPressed: () {
                  setState(() {
                    itemId = itemIdController.text;
                    showToast();
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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 35.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: CustomRaisedButton(
                      onTap: () {
                        Navigator.pushNamedAndRemoveUntil(
                            context, '/home', (_) => false);
                      },
                      label: 'Return Home',
                      padding:
                          EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  void showToast() async {
    if (itemId.isNotEmpty) {
      anim.forward();

      setState(() {
        showingToast = true;
      });
      Future.delayed(
          Duration(
            milliseconds: 1200,
          ), () {
        setState(() {
          showingToast = false;
        });
      });
    }
  }

  @override
  void dispose() {
    anim.dispose();
    _controller.pauseCamera();
    _controller.dispose();

    super.dispose();
  }
}
