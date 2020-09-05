import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:inventory_app/screens/scan-items/SingleItemScannerScreen.dart';
import 'package:inventory_app/screens/stock-transfer/IntraTransferScanner.dart';
import 'package:inventory_app/screens/utils/ClearableTextField.dart';
import 'package:inventory_app/utils/app_colors.dart';

class IntraTransferScreen extends StatefulWidget {
  @override
  _IntraTransferScreenState createState() => _IntraTransferScreenState();
}

class _IntraTransferScreenState extends State<IntraTransferScreen> {
  final itemIdController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Intra Warehouse - Scan Item'),
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
                    Text('Scan Items', style: Theme.of(context).textTheme.title),
                    SizedBox(height: 10),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * .6,
                      child: Text(
                          "Scan items within the store that you want to move",
                          style: Theme.of(context).textTheme.subtitle),
                    ),
                    SizedBox(height: 30),
                    Center(
                      child: SvgPicture.asset('assets/images/scanner.svg'),
                    ),
//                    SizedBox(height: 15,),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 20),
                      child: Center(
                        child: RaisedButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(3)),
                          padding: EdgeInsets.symmetric(
                              vertical: 12, horizontal: 16),
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (_) => IntraTransferScannerScreen()));
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
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20.0),
                      child: Center(
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width * .6,
                          child: Text(
                            'You can also manually enter the Item ID',
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                    Center(
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width * .82,
                        child: ClearableTextField(
                          textEditingController: itemIdController,
                          label: "Item ID",
                        ),
                      ),
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
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (_) => IntraTransferScannerScreen()));
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
//                    SizedBox(height: MediaQuery.of(context).size.height * .1),
                  ],
                ),
              ),
//              Expanded(child: Container()),
            ],
          ),
        ),
      ),
    );
  }
}
