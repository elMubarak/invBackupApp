import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/svg.dart';
import 'package:inventory_app/screens/stock-count/CountScannerScreen.dart';
import 'package:inventory_app/screens/stock-count/StockCountLocationScannerScreen.dart';
import 'package:inventory_app/screens/utils/ClearableTextField.dart';
import 'package:inventory_app/utils/app_colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (_) => CountScannerScreen()));
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
