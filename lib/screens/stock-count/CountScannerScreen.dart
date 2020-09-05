import 'package:flutter/material.dart';
import 'package:inventory_app/models/POItem.dart';
import 'package:inventory_app/screens/stock-count/CountSuccessScreen.dart';
import 'package:inventory_app/screens/utils/ClearableTextField.dart';
import 'package:inventory_app/screens/utils/CustomOverlay.dart';
import 'package:inventory_app/screens/utils/DialogUtils.dart';
import 'package:inventory_app/utils/app_colors.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CountScannerScreen extends StatefulWidget {
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

  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  final _animatedListKey = GlobalKey<AnimatedListState>();

  @override
  void initState() {
    super.initState();
    initCycles();
  }

  void initCycles() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      cycles = prefs.getInt("countCycles") ?? 2;
      currentCycle = prefs.getInt("currentCycle") ?? 1;
    });
  }

  void _onQRViewCreated(QRViewController controller) {
    this._controller = controller;
    controller.scannedDataStream.listen((scanData) {
      _controller.pauseCamera();

      setState(() {
        qrText = scanData;
        itemsCount = itemsCount < poList.length ? itemsCount + 1 : itemsCount;
      });

      Future.delayed(Duration(milliseconds: 1500), () {
        _controller.resumeCamera();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Count')),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Text('Stock count cycle $currentCycle of $cycles.',
                  style: Theme.of(context).textTheme.title),
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
                  color: poList.length > 0
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
                                text: '${poList.length}',
                                style: Theme.of(context)
                                    .textTheme
                                    .caption
                                    .copyWith(
                                        color: tileIsOpen ? Colors.white : null,
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold),
                              ),
                              TextSpan(
                                  text: ' items in this location.',
                                  style: Theme.of(context)
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
                            style: Theme.of(context).textTheme.caption.copyWith(
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
              child: Text(
                itemsCount.toString(),
                style: Theme.of(context)
                    .textTheme
                    .body1
                    .copyWith(fontSize: 30, fontWeight: FontWeight.w700),
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
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (_) => CountSuccessScreen(
                          countDetails: {'total': poList.length, 'counted': itemsCount},
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
                  text: '1234ASDF12SK.',
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
            style: Theme.of(context)
                .textTheme
                .body1
                .copyWith(color: AppWhite),
          ),
        ),
      ),
    );
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
