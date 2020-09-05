import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:inventory_app/screens/stock-count/CountScannerScreen.dart';
import 'package:inventory_app/screens/utils/CustomRaisedButton.dart';
import 'package:inventory_app/screens/utils/DialogUtils.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CountSuccessScreen extends StatefulWidget {
  final dynamic countDetails;

  const CountSuccessScreen({Key key, this.countDetails}) : super(key: key);
  @override
  _CountSuccessScreenState createState() =>
      _CountSuccessScreenState(countDetails);
}

class _CountSuccessScreenState extends State<CountSuccessScreen> {
  int cycles;
  int currentCycle;
  SharedPreferences prefs;
  final dynamic countDetails;

  _CountSuccessScreenState(this.countDetails);
  @override
  void initState() {
    super.initState();
    initCycles();
  }

  void initCycles() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      cycles = prefs.getInt("countCycles") ?? 2;
      currentCycle = prefs.getInt("currentCycle") ?? 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 0, horizontal: 20),
          child: SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height - 80,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.max,
//            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  SizedBox(height: 30,),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * .4,
                    child: SvgPicture.asset('assets/images/lean-robot.svg'),
                  ),
                  SizedBox(height: 30),
                  Text('Count $currentCycle of $cycles complete!',
                      style: Theme.of(context).textTheme.title),

                  Container(
                    margin: EdgeInsets.symmetric(vertical: 14),
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(3),
                      border: Border.all(width: 1.5, color: Color(0xFF839AB0)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              'Items in',
                              style: Theme.of(context)
                                  .textTheme
                                  .caption
                                  .copyWith(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500),
                            ),
                            Text(
                              'Location ID: 1249ABCD12SK',
                              style: Theme.of(context)
                                  .textTheme
                                  .caption
                                  .copyWith(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500),
                            )
                          ],
                        ),
                        Text(
                          countDetails["total"]?.toString() ?? '0',
                          style: Theme.of(context)
                              .textTheme
                              .body1
                              .copyWith(fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(bottom: 16),
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 13),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(3),
                      border: Border.all(width: 1.5, color: Color(0xFF839AB0)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              'Items Counted',
                              style: Theme.of(context)
                                  .textTheme
                                  .caption
                                  .copyWith(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                        Text(
                          countDetails["counted"]?.toString() ?? '0',
                          style: Theme.of(context)
                              .textTheme
                              .body1
                              .copyWith(fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 25),
                    child: Text(
                      'Outstanding: '
                      '${(countDetails["total"] - countDetails["counted"])}',
                      style: Theme.of(context)
                          .textTheme
                          .body1
                          .copyWith(fontWeight: FontWeight.w700),
                    ),
                  ),
//                  SizedBox(
//                    height: 16,
//                  ),
                  Visibility(
                    visible: currentCycle >= cycles,
                    child: CustomRaisedButton(
                      onTap: () => Navigator.pushNamedAndRemoveUntil(
                          context, '/home', (_) => false),
                      label: 'Return Home',
                      type: ButtonType.DeepPurple,
                    ),
                  ),
                  Visibility(
                    visible: currentCycle < cycles,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 16, horizontal: 5.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          CustomRaisedButton(
                            onTap: () {
                              DialogUtils.showCustomDialog(
                                context: context,
                                actions: <Widget>[
                                  RaisedButton(
                                    color: Color(0xFFE6E6FE),
                                    onPressed: () {
                                      Navigator.of(context)
                                          .pushNamedAndRemoveUntil(
                                              '/home', (_) => false);
                                    },
                                    child: Text(
                                      'Home',
                                      style: TextStyle(
                                        color: Color(0xFF3732E2),
                                      ),
                                    ),
                                    padding: EdgeInsets.symmetric(
                                        vertical: 12, horizontal: 16),
                                  ),
                                  RaisedButton(
                                    onPressed: () async {
                                      Navigator.of(context).pop();
//                                Navigator.of(context).pop
                                    },
                                    color: Color(0xFF239374),
                                    child: Text('Next Count Cycle'),
                                    padding: EdgeInsets.symmetric(
                                        vertical: 12, horizontal: 16),
                                  ),
                                ],
                                dialogBody: <TextSpan>[
                                  TextSpan(text: 'Hey Abayomi,'),
                                  TextSpan(text: '\n\n'),
                                  TextSpan(
                                      text:
                                          'Are you sure? Going home would cancel this count cycle. You have'),
                                  TextSpan(
                                    text: ' ${cycles - currentCycle}',
                                    style:
                                        TextStyle(fontWeight: FontWeight.w700),
                                  ),
                                  TextSpan(text: ' more count cycles to go.'),
                                ],
                              );
                            },
                            label: 'Home',
                            padding: EdgeInsets.symmetric(
                                vertical: 16, horizontal: 16),
                          ),
//                  Expanded(child: Spacer(), flex: 1,),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * .08,
                          ),
                          Expanded(
                            flex: 2,
                            child: CustomRaisedButton(
                              onTap: () async {
                                final currentCount =
                                    prefs.getInt("currentCycle") ?? 1;
                                await prefs.setInt(
                                    "currentCycle", currentCount + 1);
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => CountScannerScreen(),
                                  ),
                                );
                              },
                              label: 'Begin Next Count Cycle',
                              type: ButtonType.DeepPurple,
                              padding: EdgeInsets.symmetric(
                                  vertical: 16, horizontal: 16),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
//            Expanded(child: Container()),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
