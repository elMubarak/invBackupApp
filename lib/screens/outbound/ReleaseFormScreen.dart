import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:inventory_app/screens/outbound/ReleaseSuccessScreen.dart';
import 'package:inventory_app/screens/utils/ClearableTextField.dart';
import 'package:inventory_app/utils/app_colors.dart';

class ReleaseFormScreen extends StatefulWidget {
  @override
  _ReleaseFormScreenState createState() => _ReleaseFormScreenState();
}

class _ReleaseFormScreenState extends State<ReleaseFormScreen> {
  String chosenType = "0";
  final poIdController = TextEditingController();


  bool tileIsOpen = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Outbound - Release Items'),
        ),
        body: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
                minHeight: MediaQuery
                    .of(context)
                    .size
                    .height - 80),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text('Release Items',
                          style: Theme
                              .of(context)
                              .textTheme
                              .title),
                      SizedBox(height: 10),
                      SizedBox(
                        width: MediaQuery
                            .of(context)
                            .size
                            .width * .8,
                        child: Text(
                            "Release items after this form been singed",
                            style: Theme
                                .of(context)
                                .textTheme
                                .body1),
                      ),

                      SizedBox(height: 30),
                      Center(
                        child: SizedBox(
                          width: MediaQuery
                              .of(context)
                              .size
                              .width * .82,
                          child: ClearableTextField(
                            textEditingController: poIdController,
                            label: "Receiver Name",
                          ),
                        ),
                      ),

                    ],
                  ),
                ),
//              Expanded(child: Container()),

              ],
            ),
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
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (_) => ReleaseSuccessScreen()));
            },
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4)),
            child: Text(
              'Complete Release and Print',
              style: Theme
                  .of(context)
                  .textTheme
                  .body1
                  .copyWith(color: AppWhite),
            ),
          ),
        ),
      ),
    );
  }
}
