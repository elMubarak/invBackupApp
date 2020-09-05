import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:inventory_app/screens/utils/CustomRaisedButton.dart';
import 'package:inventory_app/utils/app_colors.dart';

class VendorReturnSuccessScreen extends StatefulWidget {

  const VendorReturnSuccessScreen({Key key}) : super(key: key);
  @override
  _VendorReturnSuccessScreenState createState() => _VendorReturnSuccessScreenState();
}

class _VendorReturnSuccessScreenState extends State<VendorReturnSuccessScreen> {

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
                  child: SvgPicture.asset('assets/images/smoking-robot.svg'),
                ),
                SizedBox(height: 30),
                Text('Done!', style: Theme.of(context).textTheme.title),
                SizedBox(
                  width: MediaQuery.of(context).size.width * .8,
                  child: Text(
                    'All scanned items have been returned to the vendor',
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
