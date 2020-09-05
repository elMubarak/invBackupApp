import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:inventory_app/screens/utils/CustomRaisedButton.dart';
import 'package:inventory_app/utils/app_colors.dart';

class ReleaseSuccessScreen extends StatefulWidget {

  const ReleaseSuccessScreen({Key key}) : super(key: key);
  @override
  _ReleaseSuccessScreenState createState() => _ReleaseSuccessScreenState();
}

class _ReleaseSuccessScreenState extends State<ReleaseSuccessScreen> {

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
                  child: SvgPicture.asset('assets/images/standing-robot.svg'),
                ),
                SizedBox(height: 30),
                Text('Done!', style: Theme.of(context).textTheme.title),
                SizedBox(
                  width: MediaQuery.of(context).size.width * .8,
                  child: Text(
                    'Check out the store app to print out the release note',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.body1.copyWith(height: 1.4),
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
                          Navigator.pushNamedAndRemoveUntil(context, '/home', (_) => false);
                        },
                        label: 'Return Home',
                        type: ButtonType.DeepPurple,
                        padding:
                        EdgeInsets.symmetric(vertical: 16, horizontal: 16),
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
