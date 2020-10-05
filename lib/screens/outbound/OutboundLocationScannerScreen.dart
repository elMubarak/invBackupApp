import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:inventory_app/screens/outbound/OutboundItemsScannerScreen.dart';
import 'package:inventory_app/screens/utils/ClearableTextField.dart';
import 'package:inventory_app/screens/utils/CustomOverlay.dart';
import 'package:inventory_app/utils/app_colors.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class OutboundLocationScannerScreen extends StatefulWidget {
  @override
  _OutboundLocationScannerScreenState createState() =>
      _OutboundLocationScannerScreenState();
}

class _OutboundLocationScannerScreenState
    extends State<OutboundLocationScannerScreen> {
  final locationController = TextEditingController();
  QRViewController _controller;

  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  void _onQRViewCreated(QRViewController controller) {
    this._controller = controller;
    controller.scannedDataStream.listen((scanData) async {
      _controller.pauseCamera();
      await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => ScanOutboundItemsScreenScreen(),
        ),
      );
      _controller.resumeCamera();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Outbound - Scan Location'),
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
                            "For verification purposes, please scan the location barcode",
                            style: Theme.of(context).textTheme.body1),
                      ),
                      SizedBox(height: 30),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * .4,
                        child: InkWell(
                          onDoubleTap: () => _controller.toggleFlash(),
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
                      SizedBox(height: 30),
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
                            textEditingController: locationController,
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
                      Future.delayed(Duration.zero, () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (_) => ScanOutboundItemsScreenScreen()));
                      });
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
}
