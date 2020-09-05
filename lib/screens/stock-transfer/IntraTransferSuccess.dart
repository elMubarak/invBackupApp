import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:inventory_app/screens/utils/CustomRaisedButton.dart';
import 'package:inventory_app/utils/app_colors.dart';

class IntraTransferSuccessScreen extends StatefulWidget {
  const IntraTransferSuccessScreen({Key key, this.location}) : super(key: key);

  final String location;
  @override
  _IntraTransferSuccessScreenState createState() =>
      _IntraTransferSuccessScreenState(location);
}

class _IntraTransferSuccessScreenState
    extends State<IntraTransferSuccessScreen> {
  final String location;

  _IntraTransferSuccessScreenState(this.location);
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
              child: SvgPicture.asset('assets/images/smoking-robot.svg'),
            ),
            SizedBox(height: 30),
            Text('Done!', style: Theme.of(context).textTheme.title),
            SizedBox(
              width: MediaQuery.of(context).size.width * .8,
              child: Text.rich(
                TextSpan(
                  children: <InlineSpan>[
                    TextSpan(
                      text: 'All scanned items have been moved to ',
                      style: Theme.of(context)
                          .textTheme
                          .body1
                          .copyWith(height: 1.4),
                    ),
                    TextSpan(
                      text: location,
                      style: Theme.of(context)
                          .textTheme
                          .body1
                          .copyWith(height: 1.4, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Expanded(child: Container()),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  CustomRaisedButton(
                    onTap: () {
                      Navigator.pushNamedAndRemoveUntil(
                          context, '/home', (_) => false);
                    },
                    label: 'Return Home',
                    type: ButtonType.DeepPurple,
                    padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                  ),
                ],
              ),
            ),
            Expanded(child: Container()),
          ],
        ),
      )),
    );
  }
}
