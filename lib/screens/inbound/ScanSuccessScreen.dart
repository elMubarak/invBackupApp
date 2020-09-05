import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:inventory_app/screens/utils/CustomRaisedButton.dart';
import 'package:inventory_app/utils/app_colors.dart';

class ScanSuccessScreen extends StatefulWidget {
  @override
  _ScanSuccessScreenState createState() => _ScanSuccessScreenState();
}

class _ScanSuccessScreenState extends State<ScanSuccessScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Container(
        padding: EdgeInsets.symmetric(vertical: 30, horizontal: 20),
        child: Column(
          mainAxisSize: MainAxisSize.max,
//            mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            SizedBox(
              height: MediaQuery.of(context).size.height * .4,
              child: SvgPicture.asset('assets/images/scan-success.svg'),
            ),
            SizedBox(height: 30),
            Text('Done!', style: Theme.of(context).textTheme.title),
            SizedBox(
              width: MediaQuery.of(context).size.width * .8,
              child: Text(
                'All 6 items have been scanned'
                ' into the inventory app. What will you'
                ' like to do next?',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.body1.copyWith(height: 1.4),
              ),
            ),
            Expanded(child: Container()),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5.0),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: CustomRaisedButton(
                      onTap: () {
                        Navigator.pushNamedAndRemoveUntil(context, '/home', (_) => false);
                      },
                      label: 'Return Home',
                      type: ButtonType.LightPurple,
                      padding:
                          EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * .1,
                  ),
                  Expanded(
                    child: CustomRaisedButton(
                      onTap: () {},
                      label: 'Put Items Away',
                      type: ButtonType.DeepPurple,
                      padding:
                          EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                    ),
                  )
                ],
              ),
            ),
            Expanded(child: Container()),
            Row(
              children: <Widget>[
                Expanded(
                  child: RaisedButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(3)),
                    padding: EdgeInsets.symmetric(vertical: 17, horizontal: 16),
                    onPressed: () {
                      Navigator.pushNamedAndRemoveUntil(context, '/view-items', (_) => false);

                    },
                    color: AppLightPurple,
                    child: Text(
                      'Scan Another P.O',
                      style: TextStyle(
                        color: AppDeepPurple,
                      ),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      )),
    );
  }
}
