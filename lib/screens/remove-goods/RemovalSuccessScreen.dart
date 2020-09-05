import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:inventory_app/screens/utils/CustomRaisedButton.dart';
import 'package:inventory_app/utils/app_colors.dart';

class RemovalSuccessScreen extends StatefulWidget {
  @override
  _RemovalSuccessScreenState createState() => _RemovalSuccessScreenState();
}

class _RemovalSuccessScreenState extends State<RemovalSuccessScreen> {
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
                'All 6 items have been '
                'taken out as obsolete goods',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.subtitle.copyWith(height: 1.4),
              ),
            ),
            SizedBox(height: 25),
            CustomRaisedButton(
              onTap: () {
                Navigator.pushNamedAndRemoveUntil(context, '/home', (_) => false);
              },
              label: 'Return Home',
              type: ButtonType.DeepPurple,
              padding:
                  EdgeInsets.symmetric(vertical: 16, horizontal: 16),
            ),
          ],
        ),
      )),
    );
  }
}
