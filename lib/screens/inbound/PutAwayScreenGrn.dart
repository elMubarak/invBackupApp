import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:inventory_app/screens/utils/ClearableTextField.dart';
import 'package:inventory_app/utils/app_colors.dart';

class PutAwayScreenGrn extends StatefulWidget {
  @override
  _PutAwayScreenGrnState createState() => _PutAwayScreenGrnState();
}

class _PutAwayScreenGrnState extends State<PutAwayScreenGrn> {
  String chosenType = "0";
  final grnController = TextEditingController();

  final List<POItem> poList = [];

  bool tileIsOpen = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Put Items Away - Input GRN'),
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
                      Text('Input GRN',
                          style: Theme.of(context).textTheme.title),
                      SizedBox(height: 10),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * .8,
                        child: Text(
                            "Before you can put items away, you need to input the GRN",
                            style: Theme.of(context).textTheme.body1),
                      ),
                      SizedBox(height: 30),
                      Center(
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width * .82,
                          child: ClearableTextField(
                            textEditingController: grnController,
                            label: "GRN",
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
                              setState(() {
                                poList.clear();
                                poList.addAll([
                                  POItem("A00001", "Google Chromecast"),
                                  POItem("A00001", "Google Chromecast"),
                                  POItem("A00001", "Google Chromecast"),
                                ]);
                              });
                            },
                            child: Text(
                              'Submit GRN',
                              style: Theme.of(context)
                                  .textTheme
                                  .body1
                                  .copyWith(color: AppWhite),
                            ),
                          ),
                        ),
                      ),
                      Container(
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
                                Text('${poList.length} items in GRN',
                                    style: TextStyle(
                                        color:
                                        tileIsOpen ? Colors.white : null)),
                                Text('View',
                                    style: TextStyle(
                                        color:
                                        tileIsOpen ? Colors.white : null)),
                              ],
                            ),
                          ),
                          children: _buildPoItems(poList),
                          onExpansionChanged: (isOpen) {
                            setState(() {
                              tileIsOpen = isOpen;
                            });
                          },
                        ),
                      ),
//                    SizedBox(height: MediaQuery.of(context).size.height * .1),
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
                    onPressed: poList.length > 0
                        ? () {
                      Navigator.of(context).pushNamed('/put-away');
                    }
                        : null,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4)),
                    child: Text(
                      'Proceed to Location Scan',
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

  List<Widget> _buildPoItems(List<POItem> items) {
    return items
        .map((f) => Container(
      decoration: BoxDecoration(
          color: AppWhite,
          border: Border(bottom: BorderSide(color: AppMediumGray))),
      child: ListTile(
        title: Text(
          f.ID,
          style:
          Theme.of(context).textTheme.body2.copyWith(fontSize: 15),
        ),
        subtitle: Text(
          f.title,
          style: Theme.of(context).textTheme.body1,
        ),
      ),
    ))
        .toList();
  }
}

class POItem {
  final String ID;
  final String title;

  POItem(this.ID, this.title);
}
